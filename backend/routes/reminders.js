const express = require('express');
const router = express.Router();
const { sendPushNotification, admin } = require('../services/fcm_service');

// GET /api/reminders/check
// Triggered by cron-job.org every 30 minutes
router.get('/check', async (req, res) => {
    try {
        const db = admin.firestore();
        const now = new Date();
        
        // Example: logic to find appointments due in exactly 2 hours or 24 hours
        // This is a placeholder for the actual Firestore query
        // const snapshot = await db.collection('appointments').where('date', '>=', start).where('date', '<=', end).get();
        
        // Process snapshot and send reminders...
        // For each appointment:
        // await sendPushNotification(userToken, 'Upcoming Appointment', 'Your surgery is scheduled in 2 hours.');

        return res.status(200).json({ success: true, message: 'Reminders checked and sent successfully' });
    } catch (error) {
        console.error('Error checking reminders:', error);
        return res.status(500).json({ error: error.message });
    }
});

module.exports = router;
