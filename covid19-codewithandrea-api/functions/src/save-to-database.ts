import * as admin from 'firebase-admin';
import * as superagent from 'superagent';
import * as express from 'express'

const endpointUrl = 'https://covid2019-api.herokuapp.com/v2/total'

/* sample data from API:
{
    data: {
        confirmed: 3193886,
        deaths: 227638,
        recovered: 972719,
        active: 1993529
    },
    dt: '04-29-2020',
    ts: 1588118400
}
*/

export async function saveLatestTotalsToFirestore(res: express.Response) {
    const success = await runSaveLatestTotalsToFirestore()
    res.sendStatus(success ? 200 : 400)
}

export async function runSaveLatestTotalsToFirestore(): Promise<boolean> {
    try {
        const resp = await superagent.get(endpointUrl)
        const data = resp.body.data
        if (data === undefined) {
            console.log(`could not get data from ${endpointUrl}`)
            return false
        }
        const date = getDate(resp.body.ts)
        console.log(`date: ${date}`)

        console.log(`confirmed: ${data.confirmed}, deaths: ${data.deaths}, recovered: ${data.recovered}, active: ${data.active}`)

        const latestRef = admin.firestore().collection('latest').doc('totals')
        await latestRef.set({
            data: data,
            date: date,
            dateString: date.toISOString()
        })
        console.log(`confirmed: ${data.confirmed}, deaths: ${data.deaths}, recovered: ${data.recovered}, active: ${data.active}`)
        return true
    } catch (e) {
        console.log(e)
        return false
    }
}

function getDate(timestamp: number): Date {
    return new Date()
    // TODO: Find out why this doesn't work
    // console.log(`timestamp: ${timestamp}`)
    // if (timestamp === undefined) {
    //     return new Date()
    // }
    // return new Date(timestamp)
}