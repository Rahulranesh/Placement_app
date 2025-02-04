const express = require('express');
const admin = require('firebase-admin');
const bodyParser = require('body-parser');

// Initialize Firebase Admin with your service account credentials
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const app = express();
app.use(bodyParser.json());

// Endpoint to send notification to a topic ("students" in this example)
app.post('/sendNotification', async (req, res) => {
  const { title, body } = req.body;

  // Create a message as defined by the Firebase Admin SDK
  const message = {
    topic: 'students',
    notification: {
      title: title,
      body: body,
    },
    android: {
      priority: 'high',
    },
    apns: {
      payload: {
        aps: {
          sound: 'default',
        },
      },
    },
    webpush: {
      headers: {
        Urgency: 'high',
      },
    },
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    res.status(200).send({ success: true, messageId: response });
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).send({ success: false, error: error.toString() });
  }
});

// Start the server on port 3000 (or any port you prefer)
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Notification backend running on port ${PORT}`);
});
