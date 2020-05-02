// Import the Firebase SDK for Google Cloud Functions.
// Import and initialize the Firebase Admin SDK.
import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

admin.initializeApp();

// Internal API (for updating the data)
import { saveLatestTotalsToFirestore, runSaveLatestTotalsToFirestore } from './save-to-database'

exports.saveLatestTotalsToFirestore = functions.https.onRequest((_, res) => saveLatestTotalsToFirestore(res))

exports.scheduleFirestoreUpdate =
    functions.pubsub.schedule('0 2,14 * * *').onRun((_) => runSaveLatestTotalsToFirestore())

//////////////////////////
// Public API
//////////////////////////

// Authorization keys
import { generateAuthorizationKeys } from './authorization-keys'

exports.generateAuthorizationKeys = functions.auth.user().onCreate(generateAuthorizationKeys);

// Endpoints

import { cases, casesSuspected, casesConfirmed, deaths, recovered } from './endpoints'

exports.cases = functions.https.onRequest((_, res) => cases(res))
exports.casesSuspected = functions.https.onRequest((_, res) => casesSuspected(res))
exports.casesConfirmed = functions.https.onRequest((_, res) => casesConfirmed(res))
exports.deaths = functions.https.onRequest((_, res) => deaths(res))
exports.recovered = functions.https.onRequest((_, res) => recovered(res))
