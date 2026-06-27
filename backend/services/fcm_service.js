const admin = require('firebase-admin');

// Initialize Firebase Admin using default credentials (from environment variable in Render)
// Or use service account JSON if provided in ENV
try {
    if (process.env.FIREBASE_SERVICE_ACCOUNT_JSON) {
        const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_JSON);
        admin.initializeApp({
            credential: admin.credential.cert(serviceAccount)
        });
    } else {
        admin.initializeApp();
    }
} catch (error) {
    console.error('Firebase admin initialization error:', error);
}

const sendPushNotification = async (token, title, body, data = {}) => {
    try {
        const message = {
            token: token,
            notification: {
                title: title,
                body: body
            },
            data: data,
            android: {
                priority: 'high'
            }
        };

        const response = await admin.messaging().send(message);
        return { success: true, response };
    } catch (error) {
        console.error('Error sending push notification:', error);
        return { success: false, error: error.message };
    }
};

const sendMulticastNotification = async (tokens, title, body, data = {}) => {
    try {
        const message = {
            tokens: tokens,
            notification: {
                title: title,
                body: body
            },
            data: data,
            android: {
                priority: 'high'
            }
        };

        const response = await admin.messaging().sendEachForMulticast(message);
        return { success: true, response };
    } catch (error) {
        console.error('Error sending multicast push notification:', error);
        return { success: false, error: error.message };
    }
};

module.exports = {
    sendPushNotification,
    sendMulticastNotification,
    admin // Export admin if firestore access is needed
};
