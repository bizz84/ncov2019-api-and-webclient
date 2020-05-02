import * as admin from 'firebase-admin'
import * as express from 'express';

export async function generateAccessToken(req: Request, res: express.Response) {
    try {
        if (req.method !== 'POST') {
            console.log(`generateAccessToken should be called with the POST method`)
            res.sendStatus(400)
        }
        // TODO: grant_type=client_credentials?
        const authHeader = req.headers.get('Authorization')
        if (authHeader === undefined) {
            console.log(`generateAccessToken must be called with an Authorization header`)
            res.sendStatus(400)
        }
        if (authHeader?.indexOf('Basic ') !== 0) {
            console.log(`generateAccessToken Authorization header should be of type Basic`)
            res.sendStatus(400)
        }
        const authorizationKey = authHeader?.substr(6) || ''
        console.log(`generateAccessToken found ${authorizationKey} authorization key`)

        // TODO: Find which user this authorizationKey belongs to
        const userDocSnapshot = await findUserDocumentMatching(authorizationKey)
        if (userDocSnapshot === null) {
            console.log(`authorizationKey ${authorizationKey} does not exist in the system`)
            res.sendStatus(400)
        }

        const accessTokenDocRef = await admin.firestore().collection('accessTokens').add({
            uid: userDocSnapshot?.id,
            // TODO: expires
        })
        res.status(200).send({
            'access-token': accessTokenDocRef.id
        })
    } catch (error) {
        //console.log(`Error generating authorization keys for 'users/${userRecord.uid}'`, error);
        throw error;
    }
}

async function findUserDocumentMatching(authorizationKey: string): Promise<admin.firestore.QueryDocumentSnapshot?> {
    const usersCollection = await admin.firestore().collection('users').get()
    for (var userDocSnapshot of usersCollection.docs) {
        const userDocData = userDocSnapshot.data()
        if (userDocData.sandboxKey === authorizationKey) {
            return userDocSnapshot
        }
        if (userDocData.productionKey === authorizationKey) {
            return userDocSnapshot
        }
    }
    return null
}