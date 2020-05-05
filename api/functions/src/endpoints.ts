import * as admin from 'firebase-admin'
import { Request, Response } from 'express';

export async function cases(req: Request, res: Response) {
    const validAccessToken = await readAndValidateAccessToken(req)
    if (!validAccessToken) {
        res.status(401).send(invalidTokenResponseData())
        return
    }
    const totalsData = await getTotals()
    if (totalsData === undefined) {
        res.status(404).send(unavailableDataResponseData('cases'))
        return
    }
    const value = totalsData?.data.confirmed
    const date = totalsData?.dateString
    res.send([{
        cases: value,
        date: date
    }])
}

export async function casesSuspected(req: Request, res: Response) {
    const validAccessToken = await readAndValidateAccessToken(req)
    if (!validAccessToken) {
        res.status(401).send(invalidTokenResponseData())
        return
    }
    const totalsData = await getTotals()
    if (totalsData === undefined) {
        res.status(404).send(unavailableDataResponseData('casesSuspected'))
        return
    }
    const date = totalsData?.dateString
    res.send([{
        data: 0,
        date: date
    }])
}

export async function casesConfirmed(req: Request, res: Response) {
    const validAccessToken = await readAndValidateAccessToken(req)
    if (!validAccessToken) {
        res.status(401).send(invalidTokenResponseData())
        return
    }
    const totalsData = await getTotals()
    if (totalsData === undefined) {
        res.status(404).send(unavailableDataResponseData('casesConfirmed'))
        return
    }
    const value = totalsData?.data.confirmed
    const date = totalsData?.dateString
    res.send([{
        data: value,
        date: date
    }])
}

export async function deaths(req: Request, res: Response) {
    const validAccessToken = await readAndValidateAccessToken(req)
    if (!validAccessToken) {
        res.status(401).send(invalidTokenResponseData())
        return
    }
    const totalsData = await getTotals()
    if (totalsData === undefined) {
        res.status(404).send(unavailableDataResponseData('deaths'))
        return
    }
    const value = totalsData?.data.deaths
    const date = totalsData?.dateString
    res.send([{
        data: value,
        date: date
    }])
}

export async function recovered(req: Request, res: Response) {
    const validAccessToken = await readAndValidateAccessToken(req)
    if (!validAccessToken) {
        res.status(401).send(invalidTokenResponseData())
        return
    }
    const totalsData = await getTotals()
    if (totalsData === undefined) {
        res.status(404).send(unavailableDataResponseData('recovered'))
        return
    }
    const value = totalsData?.data.recovered
    const date = totalsData?.dateString
    res.send([{
        data: value,
        date: date
    }])
}

async function getTotals() {

    const latestDoc = await admin.firestore().collection('latest').doc('totals').get()
    if (latestDoc === undefined) {
        return undefined
    }
    return latestDoc.data()
}

async function readAndValidateAccessToken(req: Request) {
    const accessToken = await getAccessToken(req)
    if (accessToken === undefined) {
        return false
    }
    return await isAccessTokenValid(accessToken)
}

async function getAccessToken(req: Request) {
    if (req.method !== 'GET') {
        console.log(`checkAccessToken should be called with the GET method`)
        return undefined
    }
    // TODO: grant_type=client_credentials?
    const authHeader = req.headers.authorization
    if (authHeader === undefined) {
        console.log(`checkAccessToken must be called with an Authorization header`)
        return undefined
    }
    if (authHeader.indexOf('Bearer ') !== 0) {
        console.log(`checkAccessToken Authorization header should be of type Bearer`)
        return undefined
    }
    const accessToken = authHeader.slice(7)
    if (accessToken.length === 0) {
        console.log(`checkAccessToken Authorization key is empty`)
        return undefined
    }
    return accessToken
}

async function isAccessTokenValid(accessToken: string) {
    const accessTokenDocRef = admin.firestore().collection('accessTokens').doc(accessToken)
    const accessTokenSnapshot = await accessTokenDocRef.get()
    if (!accessTokenSnapshot.exists) {
        return false
    }
    const accessTokenData = accessTokenSnapshot.data()!
    const currentDate = new Date()
    const currentTimeMs = currentDate.valueOf()
    const isValid = currentTimeMs <= accessTokenData.expirationTime
    console.log(`found 'accessTokens/${accessToken}' document, valid: ${isValid}`)
    return isValid
}

function invalidTokenResponseData() {
    return {
        error: {
            code: 1001,
            message: 'Invalid Credentials',
            description: 'Access failure for API - Invalid Credentials. Make sure you have given the correct access token'
        }
    }
}

function unavailableDataResponseData(endpoint: string) {
    return {
        error: {
            code: 1002,
            message: 'Data not available',
            description: `No data is available for the ${endpoint} endpoint`
        }
    }
}