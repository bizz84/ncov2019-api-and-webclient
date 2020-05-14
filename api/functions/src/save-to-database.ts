import * as admin from 'firebase-admin';
import * as superagent from 'superagent';
import * as express from 'express'

export async function saveLatestTotalsToFirestore(res: express.Response) {
    const success = await runSaveLatestTotalsToFirestore()
    res.sendStatus(success ? 200 : 400)
}

export async function runSaveLatestTotalsToFirestore(): Promise<boolean> {
    try {
        const data = await getDataFromAPI(DataSource.covid19MathdroApi)
        if (data === undefined) {
            console.error('could not parse data from remote endpoint')
            return false
        }

        const latestRef = admin.firestore().collection('latest').doc('totals')
        await latestRef.set(data)
        console.log(`SAVED: confirmed: ${data.data.confirmed}, deaths: ${data.data.deaths}, recovered: ${data.data.recovered}, active: ${data.data.active}, date: ${data.date}`)
        return true
    } catch (e) {
        console.log(e)
        return false
    }
}

// List of supported APIs
enum DataSource {
    covid2019Api,
    covid19MathdroApi
}

async function getDataFromAPI(dataSource: DataSource): Promise<{ data: { confirmed: number, deaths: number, recovered: number, active: number }, date: string } | undefined> {
    switch (dataSource) {
        case DataSource.covid2019Api:
            return getDataFromCovid2019Api()
        case DataSource.covid19MathdroApi:
            return getDataFromCovid19MathdroApi()
    }
}

async function getDataFromCovid19MathdroApi(): Promise<{ data: { confirmed: number, deaths: number, recovered: number, active: number }, date: string } | undefined> {
    const endpointUrl = 'https://covid19.mathdro.id/api'

    const resp = await superagent.get(endpointUrl)
    const data = resp.text
    if (data === undefined) {
        console.error(`could not get data from ${endpointUrl}`)
        return undefined
    }
    const confirmed = resp.body.confirmed.value
    const deaths = resp.body.deaths.value
    const recovered = resp.body.recovered.value
    const date = resp.body.lastUpdate
    return {
        data: {
            confirmed: confirmed,
            active: confirmed,
            deaths: deaths,
            recovered: recovered
        },
        date: date
    }
    /* Sample response data
    {
      "confirmed": {
        "value": 3680376,
        "detail": "https://covid19.mathdro.id/api/confirmed"
      },
      "recovered": {
        "value": 1206218,
        "detail": "https://covid19.mathdro.id/api/recovered"
      },
      "deaths": {
        "value": 257818,
        "detail": "https://covid19.mathdro.id/api/deaths"
      },
      "dailySummary": "https://covid19.mathdro.id/api/daily",
      "dailyTimeSeries": {
        "pattern": "https://covid19.mathdro.id/api/daily/[dateString]",
        "example": "https://covid19.mathdro.id/api/daily/2-14-2020"
      },
      "image": "https://covid19.mathdro.id/api/og",
      "source": "https://github.com/mathdroid/covid19",
      "countries": "https://covid19.mathdro.id/api/countries",
      "countryDetail": {
        "pattern": "https://covid19.mathdro.id/api/countries/[country]",
        "example": "https://covid19.mathdro.id/api/countries/USA"
      },
      "lastUpdate": "2020-05-06T10:32:27.000Z"
    }
    */
}

async function getDataFromCovid2019Api(): Promise<{ data: { confirmed: number, deaths: number, recovered: number, active: number }, date: string } | undefined> {
    const endpointUrl = 'https://covid2019-api.herokuapp.com/v2/total'

    const resp = await superagent.get(endpointUrl)
    const data = resp.body.data
    if (data === undefined) {
        return undefined
    }

    const confirmed = resp.body.data.confirmed
    const deaths = resp.body.data.deaths
    const recovered = resp.body.data.recovered
    const active = resp.body.data.active
    // TODO: Parse to iso string
    const date = getDate(resp.body.ts).toISOString()
    return {
        data: {
            confirmed: confirmed,
            active: active,
            deaths: deaths,
            recovered: recovered
        },
        date: date
    }
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