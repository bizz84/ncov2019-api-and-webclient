import * as admin from 'firebase-admin'
import { Request, Response } from 'express';
import { generateUuid } from './uuid-generator'
import {
    accessTokenRequiresGetMethodErrorData,
    accessTokenRequiresBasicAuthorizationErrorData,
    authorizationKeyDoesNotExistErrorData,
    missingUidEnvironmentAuthorizationKeyErrorData,
    userNotFoundForAuthorizationKeyErrorData,
    errorGeneratingAccessTokenErrorData
} from './errors'

/// Generates an access token
export async function token(req: Request, res: Response) {
    try {
        if (req.method !== 'POST') {
            console.log(`token should be called with the POST method`)
            res.status(400).send(accessTokenRequiresGetMethodErrorData(req.method))
            return
        }
        // TODO: grant_type=client_credentials?
        const authorizationKey = parseBasicAuthorizationKey(req.rawHeaders)
        if (authorizationKey === undefined) {
            console.log(`token must be called with an {'Authorization': 'Basic <apiKey>'} header`)
            res.status(400).send(accessTokenRequiresBasicAuthorizationErrorData())
            return
        }
        console.log(`token found ${authorizationKey} authorization key`)

        const currentTime = new Date().valueOf()
        const firestore = admin.firestore()
        const responseData = await firestore.runTransaction(async (transaction) => {
            // check if the authorization key exists
            const authorizationKeyDocRef = firestore.collection('authorizationKeys').doc(authorizationKey)
            const authorizationKeyDocSnapshot = await transaction.get(authorizationKeyDocRef)
            if (!authorizationKeyDocSnapshot.exists) {
                return { statusCode: 400, error: authorizationKeyDoesNotExistErrorData(authorizationKey) }
            }
            // find the corresponding user for that authorization key
            const authorizationKeyDocData = authorizationKeyDocSnapshot.data()!
            const uid = authorizationKeyDocData.uid
            const environment = authorizationKeyDocData.environment
            if (uid === undefined || environment === undefined) {
                return { statusCode: 500, error: missingUidEnvironmentAuthorizationKeyErrorData(authorizationKey) }
            }
            const userDocRef = admin.firestore().collection('users').doc(uid)
            const userDocSnapshot = await transaction.get(userDocRef)
            if (!userDocSnapshot.exists) {
                return { statusCode: 400, error: userNotFoundForAuthorizationKeyErrorData(authorizationKey) }
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
            const expiresInSeconds = (responseData.accessTokenData.expirationTime - currentTime) / 1000
            res.status(200).send({
                access_token: responseData.accessTokenData.accessToken,
                token_type: 'Bearer',
                expires_in: Math.round(expiresInSeconds),
            })
        } else {
            console.warn(responseData.error)
            res.status(responseData.statusCode).send(responseData.error)
        }

    } catch (error) {
        console.log(`Error generating access token: `, error);
        res.status(500).send(errorGeneratingAccessTokenErrorData(error))
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
