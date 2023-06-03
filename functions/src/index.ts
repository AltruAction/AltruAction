import * as functions from 'firebase-functions';
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import { HttpsError } from 'firebase-functions/v1/https';

initializeApp();

exports.helloWorld = functions.region('asia-southeast1').https.onRequest(async (req, res) => {
  res.set('Access-Control-Allow-Origin', "*")
  res.set('Access-Control-Allow-Methods', 'GET, POST');
  res.set('Access-Control-Allow-Headers', "*")

  if (req.method === "OPTIONS") {
    // stop preflight requests here
    res.status(204).send('');
    return;
  }
  // Send back a message that we've successfully written the message
  res.json({result: "Hello world"});
});

exports.createTransaction = functions.region('asia-southeast1').https.onCall(async (req, context) => {

  const giverId = req.giverId;
  const receiverId = req.receiverId;
  const itemId = req.itemId;

  if (receiverId != context.auth?.uid && giverId != context.auth?.uid) {
    throw new HttpsError('unauthenticated', "Unauthorised");
  }

  if (giverId == receiverId) {
    throw new HttpsError("invalid-argument", "Cannot transact with self");
  }

  await getFirestore().runTransaction(async (transaction) => {
    const item = await getFirestore().collection('items').doc(itemId).get();
    if (!item.exists) {
      throw new HttpsError("not-found", "Item does not exist");
    }

    const itemData = item.data()!;

    const itemCredits: number = itemData.credits ?? 0;
    const status: String = itemData.status ?? "";

    if (status === "GIVEN") {
      throw new HttpsError("invalid-argument", "Item has already been given");
    }

    const giver = await getFirestore().collection('users').doc(giverId).get();
    if (!giver.exists) {
      throw new HttpsError("not-found", "Giver does not exist");
    }

    const receiver = await getFirestore().collection('users').doc(receiverId).get();
    if (!receiver.exists) {
      throw new HttpsError("not-found", "Receiver does not exist");
    }

    const giverData = giver.data()!;
    const receiverData = receiver.data()!;

    const receiverCredits: number = receiverData.credits ?? 0;
    if (receiverCredits < itemCredits) {
      throw new HttpsError("invalid-argument", "Receiver does not have enough credits");
    }

    const giverCredits: number = giverData.credits ?? 0;
    transaction.update(getFirestore().collection('users').doc(giverId), {
      'credits': giverCredits + itemCredits
    })
    transaction.update(getFirestore().collection('users').doc(receiverId), {
      'credits': receiverCredits - itemCredits
    })

    transaction.set(getFirestore().collection('transactions').doc(), {
      'giverId': giverId,
      'itemId': itemId,
      'receiverId': receiverId,
      'status': "COMPLETED"
    })

    // Update the item status to 'GIVEN'
    transaction.update(getFirestore().collection('items').doc(itemId), {'status': 'GIVEN'});
  })

  // Send back a message that we've successfully written the message
  return {}
});
