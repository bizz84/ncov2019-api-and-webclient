// Import the Firebase SDK for Google Cloud Functions.
// Import and initialize the Firebase Admin SDK.
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp();


// ===========================================================
// Chat message create notifications
// ===========================================================

import { saveLatestTotalsToFirestore } from './save-to-database';

exports.saveLatestTotalsToFirestore = functions.https.onRequest(saveLatestTotalsToFirestore)