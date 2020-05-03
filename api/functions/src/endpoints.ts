import * as admin from 'firebase-admin'
import { Request, Response } from 'express';

export async function cases(req: Request, res: Response) {
    const validAccessToken = await readAndValidateAccessToken(req)
    if (!validAccessToken) {
        res.sendStatus(401)
        return
    }
    // TODO: access token checks
    const totalsData = await getTotals()
    if (totalsData === undefined) {
        res.sendStatus(404)
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
        res.sendStatus(401)
        return
    }
    const totalsData = await getTotals()
    if (totalsData === undefined) {
        res.sendStatus(404)
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
        res.sendStatus(401)
        return
    }
    const totalsData = await getTotals()
    if (totalsData === undefined) {
        res.sendStatus(404)
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
        res.sendStatus(401)
        return
    }
    const totalsData = await getTotals()
    if (totalsData === undefined) {
        res.sendStatus(404)
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
        res.sendStatus(401)
        return
    }
    const totalsData = await getTotals()
    if (totalsData === undefined) {
        res.sendStatus(404)
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
    if (!isAccessTokenValid(accessToken)) {
        return false
    }
    return true
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
    if (currentTimeMs > accessTokenData.expirationTime) {
        return false
    }
    return true
}