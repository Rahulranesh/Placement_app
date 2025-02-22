const express = require('express');
const admin = require('firebase-admin');
const bodyParser = require('body-parser');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const app = express();
app.use(bodyParser.json());

app.post('/sendNotification', async (req, res) => {
  const { title, body } = req.body;
  const message = {
    topic: 'students',
    notification: {
      title: title,
      body: body,
    },
    android: { priority: 'high' },
    apns: {
      payload: {
        aps: {
          sound: 'default',
        },
      },
    },
    webpush: {
      headers: { Urgency: 'high' },
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

const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0';
app.listen(PORT, HOST, () => {
  console.log(`Notification backend running on http://${HOST}:${PORT}`);
});
