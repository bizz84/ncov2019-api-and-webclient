import * as admin from 'firebase-admin';
import * as superagent from 'superagent';

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

export async function saveLatestTotalsToFirestore() {
    try {
        const resp = await superagent.get(endpointUrl)
        const data = resp.body.data
        if (data === undefined) {
            console.log(`could not get data from ${endpointUrl}`)
            return
        }
        const date = getDate(resp.body.ts)
        console.log(`date: ${date}`)

        console.log(`confirmed: ${data.confirmed}, deaths: ${data.deaths}, recovered: ${data.recovered}, active: ${data.active}`)

        const latestRef = admin.firestore().collection('totals').doc('latest')
        await latestRef.set({
            data: data,
            date: date,
            dateString: date.toISOString()
        })
        console.log(`confirmed: ${data.confirmed}, deaths: ${data.deaths}, recovered: ${data.recovered}, active: ${data.active}`)
        //res.send(`confirmed: ${data.confirmed}, deaths: ${data.deaths}, recovered: ${data.recovered}, active: ${data.active}`);
    } catch (e) {
        console.log(e)
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