import * as admin from 'firebase-admin'
import * as express from 'express'

export async function cases(res: express.Response) {
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

export async function casesSuspected(res: express.Response) {
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

export async function casesConfirmed(res: express.Response) {
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

export async function deaths(res: express.Response) {
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

export async function recovered(res: any) {
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

// async function send(valueKey: String, value: number, dateString: String, res: express.Response) {
//     res.send([{
//         valueKey: value,
//         date: dateString
//     }])
// }

async function getTotals() {

    const latestDoc = await admin.firestore().collection('latest').doc('totals').get()
    if (latestDoc == undefined) {
        return undefined
    }
    return latestDoc.data()
}