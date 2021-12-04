const functions = require("firebase-functions");

// Take the text parameter passed to this HTTP endpoint and insert it into
// Firestore under the path /messages/:documentId/original
exports.receiveCallback = functions.https.onRequest(async (req, res) => {
  // Grab the text parameter.
  const original = req.body.Body;

  console.log(`Transaction: ${original}`);
  // Push the new message into Firestore using the Firebase Admin SDK.
  //const writeResult = await admin.firestore().collection('messages').add({original: original});
  // Send back a message that we've successfully written the message
  res.json({ result: `Mpesa Transaction Success ${original}` });
});
