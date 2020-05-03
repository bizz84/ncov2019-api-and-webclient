import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import { UserRecord } from "firebase-functions/lib/providers/auth"
import * as crypto from 'crypto'

export async function generateAuthorizationKeys(userRecord: UserRecord, _: functions.EventContext) {
    try {
        // https://stackoverflow.com/a/40191779/436422
        const sandboxKey = crypto.randomBytes(32).toString('hex')
        const productionKey = crypto.randomBytes(32).toString('hex')

        console.log(`Generating sandbox and production keys for 'users/${userRecord.uid}'`)
        const firestore = admin.firestore()
        await firestore.runTransaction(async (transaction) => {
            // create a sandbox key
            const authorizationSandboxKeyDocument = firestore.collection('authorizationKeys').doc(sandboxKey)
            transaction.create(authorizationSandboxKeyDocument, {
                uid: userRecord.uid,
                type: 'sandbox'
            })
            // create a production key
            const authorizationProductionKeyDocument = firestore.collection('authorizationKeys').doc(sandboxKey)
            transaction.create(authorizationProductionKeyDocument, {
                uid: userRecord.uid,
                type: 'production'
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

export async function regenerateAuthorizationKey(environment: any, context: functions.https.CallableContext) {
    const uid = context.auth?.uid
    try {
        if (uid === null || uid === undefined) {
            throw new functions.https.HttpsError('unauthenticated',
                'The user is not authenticated.')
        }
        if (environment !== 'sandbox' && environment !== 'production') {
            // Throwing an HttpsError so that the client gets the error details.
            throw new functions.https.HttpsError('invalid-argument',
                'The function must be called with ' +
                'one argument "environment" (either sandbox or production)')
        }
        const firestore = admin.firestore()
        await firestore.runTransaction(async (transaction) => {
            // Get the authorizationKey for the given environment and delete the corresponding document if one exists
            console.log(`Removing old ${environment} key for: 'users/${uid}'`)
            const userDocRef = firestore.collection('users').doc(uid)
            const userDocSnapshot = await transaction.get(userDocRef)
            const data = userDocSnapshot.data()
            if (data !== undefined) {
                const key = `${environment}Key`
                const authorizationKey = data[key]
                if (authorizationKey !== undefined) {
                    transaction.delete(firestore.collection('authorizationKeys').doc(authorizationKey))
                }
            }
            // create the new key
            console.log(`Generating new ${environment} key for: 'users/${uid}'`)
            const newAuthorizationKey = crypto.randomBytes(32).toString('hex')
            const authorizationKeyDocument = firestore.collection('authorizationKeys').doc(newAuthorizationKey)
            transaction.create(authorizationKeyDocument, {
                uid: uid,
                type: environment
            })
            if (environment === 'sandbox') {
                transaction.set(userDocRef, {
                    sandboxKey: newAuthorizationKey,
                }, { merge: true })
            } else {
                transaction.set(userDocRef, {
                    productionKey: newAuthorizationKey,
                }, { merge: true })
            }
        });
    } catch (error) {
        console.log(`Error generating authorization keys for 'users/${uid}'`, error);
        throw error;
    }
}