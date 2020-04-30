import * as admin from 'firebase-admin';
import * as superagent from 'superagent';

/* sample data
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

export async function saveLatestTotalsToFirestore(req, res) {
    const endpointUrl = 'https://covid2019-api.herokuapp.com/v2/total'
    const resp = await superagent.get(endpointUrl)
    const data = resp.body.data
    if (data === undefined) {
        console.log(`could not get data from ${endpointUrl}`)
        return
    }
    console.log(`confirmed: ${data.confirmed}, deaths: ${data.deaths}, recovered: ${data.recovered}, active: ${data.active}`)

    const latestRef = admin.firestore().collection('totals').doc('latest')
    await latestRef.set({
        data: data,
    })
    res.sendStatus(200);
}
const resp = await superagent.get('https://covid2019-api.herokuapp.com/v2/total')
const data = resp.body.data
console.log(`confirmed: ${data.confirmed}, deaths: ${data.deaths}, recovered: ${data.recovered}, active: ${data.active}`)
res.send(`confirmed: ${data.confirmed}, deaths: ${data.deaths}, recovered: ${data.recovered}, active: ${data.active}`);
