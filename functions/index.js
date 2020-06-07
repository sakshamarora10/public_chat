const functions = require('firebase-functions');
const admin=require('firebase-admin'); 

admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.createUser = functions.firestore
    .document('chats/{chatId}/messages/{messageId}')
    .onCreate((snap, context) => {
      return admin.messaging().sendToTopic('chat',{notification:{
          title:snap.data().username,
          body:snap.data().text,
          clickAction:'FLUTTER_NOTIFICATION_CLICK',
      }})
    });
