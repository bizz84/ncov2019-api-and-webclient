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
        const userDocRef = admin.firestore().collection('users').doc(userRecord.uid)
        return await userDocRef.set({
            sandboxKey: sandboxKey,
            productionKey: productionKey,
        }, { merge: true })
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

        console.log(`Generating new ${environment} key for: 'users/${uid}`)
        const newKey = crypto.randomBytes(32).toString('hex')
        const userDocRef = admin.firestore().collection('users').doc(uid)
        if (environment === 'sandbox') {
            return await userDocRef.set({
                sandboxKey: newKey,
            }, { merge: true })
        } else {
            return await userDocRef.set({
                productionKey: newKey,
            }, { merge: true })
        }
    } catch (error) {
        console.log(`Error generating authorization keys for 'users/${uid}'`, error);
        throw error;
    }
}