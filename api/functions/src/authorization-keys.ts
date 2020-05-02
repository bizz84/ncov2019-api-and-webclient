import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import { UserRecord } from "firebase-functions/lib/providers/auth"
import * as crypto from 'crypto'

export async function generateAuthorizationKeys(userRecord: UserRecord, _: functions.EventContext) {
    try {
        const userDocRef = admin.firestore().collection('users').doc(userRecord.uid)

        // https://stackoverflow.com/a/40191779/436422
        const sandboxKey = crypto.randomBytes(32).toString('hex')
        const productionKey = crypto.randomBytes(32).toString('hex')

        console.log(`Generating sandbox and production keys for 'users/${userRecord.uid}'`)
        return await userDocRef.set({
            sandboxKey: sandboxKey,
            productionKey: productionKey,
        }, { merge: true })
    } catch (error) {
        console.log(`Error generating authorization keys for 'users/${userRecord.uid}'`, error);
        throw error;
    }
}
