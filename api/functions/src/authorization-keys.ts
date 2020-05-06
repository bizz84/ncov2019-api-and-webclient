import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import { UserRecord } from 'firebase-functions/lib/providers/auth'
import { generateUuid } from './uuid-generator'

export async function generateAuthorizationKeys(userRecord: UserRecord, _: functions.EventContext) {
    try {

        console.log(`Generating sandbox and production keys for 'users/${userRecord.uid}'`)
        const firestore = admin.firestore()
        await firestore.runTransaction(async (transaction) => {
            // create a sandbox key
            const sandboxKey = generateUuid()
            const authorizationSandboxKeyDocument = firestore.collection('authorizationKeys').doc(sandboxKey)
            transaction.create(authorizationSandboxKeyDocument, {
                uid: userRecord.uid,
                environment: 'sandbox'
            })
            // create a production key
            const productionKey = generateUuid()
            const authorizationProductionKeyDocument = firestore.collection('authorizationKeys').doc(productionKey)
            transaction.create(authorizationProductionKeyDocument, {
                uid: userRecord.uid,
                environment: 'production'
            })
            // create a user document for that key
            const userDocRef = firestore.collection('users').doc(userRecord.uid)
            transaction.set(userDocRef, {
                sandboxKey: sandboxKey,
                productionKey: productionKey,
            }, { merge: true })
        })
    } catch (error) {
        console.log(`Error generating authorization keys for 'users/${userRecord.uid}'`, error);
        throw error;
    }
}

export async function regenerateAuthorizationKey(data: any, context: functions.https.CallableContext) {
    const uid = context.auth?.uid
    try {
        if (uid === null || uid === undefined) {
            throw new functions.https.HttpsError('unauthenticated',
                'The user is not authenticated.')
        }
        const environment = getEnvironment(data)
        if (environment === undefined || environment !== 'sandbox' && environment !== 'production') {
            // Throwing an HttpsError so that the client gets the error details.
            throw new functions.https.HttpsError('invalid-argument',
                'The function must be called with ' +
                'one argument { "environment": $environment } (either sandbox or production)')
        }
        const firestore = admin.firestore()
        await firestore.runTransaction(async (transaction) => {
            // Get the authorizationKey for the given environment and delete the corresponding document if one exists
            console.log(`Removing old ${environment} key for: 'users/${uid}'`)
            const userDocRef = firestore.collection('users').doc(uid)
            const userDocSnapshot = await transaction.get(userDocRef)
            const userDocSnapshotData = userDocSnapshot.data()
            if (userDocSnapshotData !== undefined) {
                const key = `${environment}Key`
                const authorizationKey = userDocSnapshotData[key]
                if (authorizationKey !== undefined) {
                    transaction.delete(firestore.collection('authorizationKeys').doc(authorizationKey))
                }
            }
            // create the new key
            console.log(`Generating new ${environment} key for: 'users/${uid}'`)
            const newAuthorizationKey = generateUuid()
            const authorizationKeyDocument = firestore.collection('authorizationKeys').doc(newAuthorizationKey)
            transaction.create(authorizationKeyDocument, {
                uid: uid,
                environment: environment
            })
            const newData = environment === 'sandbox'
                ? { sandboxKey: newAuthorizationKey }
                : { productionKey: newAuthorizationKey }
            transaction.set(userDocRef, newData, { merge: true })
        });
    } catch (error) {
        console.warn(`Error generating authorization keys for 'users/${uid}'`, error);
        throw error;
    }
}

function getEnvironment(data: any) {
    if (typeof data !== 'object') {
        return undefined
    }
    return data.environment
}
