import * as admin from 'firebase-admin'
import { Request, Response } from 'express';
import { generateUuid } from './uuid-generator'

export async function generateAccessToken(req: Request, res: Response) {
    try {
        if (req.method !== 'POST') {
            console.log(`generateAccessToken should be called with the POST method`)
            res.sendStatus(400)
            return
        }
        // TODO: grant_type=client_credentials?
        const authorizationKey = parseBasicAuthorizationKey(req.rawHeaders)
        if (authorizationKey === undefined) {
            console.log(`generateAccessToken must be called with an {'Authorization': 'Basic <apiKey>'} header`)
            res.sendStatus(400)
            return
        }
        console.log(`generateAccessToken found ${authorizationKey} authorization key`)

        const firestore = admin.firestore()
        const responseData = await firestore.runTransaction(async (transaction) => {
            // check if the authorization key exists
            const authorizationKeyDocRef = firestore.collection('authorizationKeys').doc(authorizationKey)
            const authorizationKeyDocSnapshot = await transaction.get(authorizationKeyDocRef)
            if (!authorizationKeyDocSnapshot.exists) {
                console.log(`authorizationKey ${authorizationKey} does not exist in the system`)
                return { statusCode: 400 }
            }
            // find the corresponding user for that authorization key
            const authorizationKeyDocData = authorizationKeyDocSnapshot.data()!
            const uid = authorizationKeyDocData.uid
            const environment = authorizationKeyDocData.environment
            if (uid === undefined || environment === undefined) {
                console.error(`could not find 'uid', 'environment' for authorizationKey ${authorizationKey}`)
                return { statusCode: 500 }
            }
            const userDocRef = admin.firestore().collection('users').doc(uid)
            const userDocSnapshot = await transaction.get(userDocRef)
            if (!userDocSnapshot.exists) {
                console.log(`users/${uid} not found`)
                return { statusCode: 400 }
            }
            // check if there is already an access token for that user
            const data = userDocSnapshot.data()!
            const accessTokenKey = `${environment}AccessToken`
            const accessTokenData = data[accessTokenKey]
            if (accessTokenData === undefined) {
                // generate a new access token and send response
                const newAccessTokenData = generateNewToken(transaction, environment, userDocRef, uid)
                return { statusCode: 200, accessTokenData: newAccessTokenData }

            } else {
                const currentTime = new Date().valueOf()
                if (currentTime > accessTokenData.expirationTime) {
                    // delete old token
                    const accessTokenDocRef = firestore.collection('accessTokens').doc(accessTokenData.accessToken)
                    transaction.delete(accessTokenDocRef)
                    // generate a new access token and send response
                    const newAccessTokenData = generateNewToken(transaction, environment, userDocRef, uid)
                    return { statusCode: 200, accessTokenData: newAccessTokenData }
                }
                else {
                    return { statusCode: 200, accessTokenData: accessTokenData }
                }
            }
        });
        if (responseData.statusCode === 200) {
            res.status(200).send({
                access_token: responseData.accessTokenData.accessToken,
                expiration_time: responseData.accessTokenData.expirationTime,
                expiration_date: responseData.accessTokenData.expirationDate
            })
        } else {
            res.sendStatus(responseData.statusCode)
        }

    } catch (error) {
        console.log(`Error generating access token: `, error);
        res.sendStatus(400)
        throw error;
    }
}

function generateNewToken(transaction: admin.firestore.Transaction, environment: string, userDocRef: admin.firestore.DocumentReference, uid: string) {
    const firestore = admin.firestore()
    const newAccessToken = generateUuid()
    const tokenCreationDate = new Date()
    const tokenCreationTimeMs = tokenCreationDate.valueOf()
    const tokenExpirationTimeMs = tokenCreationTimeMs + 3600 * 1000
    const tokenExpirationDate = new Date(tokenExpirationTimeMs)
    console.log(`token creation date: ${tokenCreationDate}, token expiration date: ${tokenExpirationDate}`)
    // write it to `users/$uid`
    const accessTokenData = {
        accessToken: newAccessToken,
        expirationTime: tokenExpirationTimeMs,
        expirationDate: tokenExpirationDate.toISOString()
    }
    const newData = environment === 'sandbox'
        ? { sandboxAccessToken: accessTokenData }
        : { productionAccessToken: accessTokenData }
    transaction.set(userDocRef, newData, { merge: true })
    // write it to `accessTokens/$accessToken`
    const accessTokenDocRef = firestore.collection('accessTokens').doc(newAccessToken)
    transaction.set(accessTokenDocRef, {
        uid: uid,
        environment: environment,
        ...accessTokenData
    }, { merge: true })
    return accessTokenData
}

function parseBasicAuthorizationKey(rawHeaders: string[]) {
    let didFindAuthorization = false
    let authBasicHeader = ''
    for (const header of rawHeaders) {
        if (header === 'Authorization') {
            didFindAuthorization = true
        }
        if (header.indexOf('Basic ') === 0) {
            authBasicHeader = header
        }
    }
    if (!didFindAuthorization || authBasicHeader.length === 0) {
        return undefined
    }
    return authBasicHeader.slice(6)
}
