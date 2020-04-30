// Import the Firebase SDK for Google Cloud Functions.
// Import and initialize the Firebase Admin SDK.
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp();

import { saveLatestTotalsToFirestore, runSaveLatestTotalsToFirestore } from './save-to-database';

exports.saveLatestTotalsToFirestore = functions.https.onRequest((req, res) => saveLatestTotalsToFirestore(res))

exports.scheduleFirestoreUpdate =
    functions.pubsub.schedule('0,30 * * * *').onRun((context) => runSaveLatestTotalsToFirestore())
