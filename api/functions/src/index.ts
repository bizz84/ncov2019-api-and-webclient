// Import the Firebase SDK for Google Cloud Functions.
// Import and initialize the Firebase Admin SDK.
import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

admin.initializeApp();

// Internal API (for updating the data)
import { /*saveLatestTotalsToFirestore, */runSaveLatestTotalsToFirestore } from './save-to-database'

//exports.saveLatestTotalsToFirestore = functions.https.onRequest((_, res) => saveLatestTotalsToFirestore(res))

exports.scheduleFirestoreUpdate =
    functions.pubsub.schedule('0 2,14 * * *').onRun((_) => runSaveLatestTotalsToFirestore())

//////////////////////////
// Public API
//////////////////////////

// Authorization keys
import { generateAuthorizationKeys, regenerateAuthorizationKey } from './authorization-keys'

// called when a new firebase user is created
exports.generateAuthorizationKeys = functions.auth.user().onCreate(generateAuthorizationKeys)
// callable function to regenerate an authorization key (sandbox or production)
exports.regenerateAuthorizationKey = functions.https.onCall(regenerateAuthorizationKey)

// Access tokens
import { token } from './access-tokens'
exports.token = functions.https.onRequest(token)

// Endpoints
import { cases, casesSuspected, casesConfirmed, deaths, recovered } from './endpoints'

exports.cases = functions.https.onRequest(cases)
exports.casesSuspected = functions.https.onRequest(casesSuspected)
exports.casesConfirmed = functions.https.onRequest(casesConfirmed)
exports.deaths = functions.https.onRequest(deaths)
exports.recovered = functions.https.onRequest(recovered)
