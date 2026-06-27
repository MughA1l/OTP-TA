const express = require('express');
const router = express.Router();
const { sendPushNotification, sendMulticastNotification } = require('../services/fcm_service');

// POST /api/notify/single
router.post('/single', async (req, res) => {
    const { token, title, body, data } = req.body;
    
    if (!token || !title || !body) {
        return res.status(400).json({ error: 'Missing required fields: token, title, body' });
    }

    const result = await sendPushNotification(token, title, body, data);
    
    if (result.success) {
        return res.status(200).json(result);
    } else {
        return res.status(500).json(result);
    }
});

// POST /api/notify/team
router.post('/team', async (req, res) => {
    const { tokens, title, body, data } = req.body;
    
    if (!tokens || !Array.isArray(tokens) || !title || !body) {
        return res.status(400).json({ error: 'Missing required fields: tokens (array), title, body' });
    }

    const result = await sendMulticastNotification(tokens, title, body, data);
    
    if (result.success) {
        return res.status(200).json(result);
    } else {
        return res.status(500).json(result);
    }
});

// POST /api/notify/emergency
router.post('/emergency', async (req, res) => {
    const { tokens, title, body, roomId } = req.body;
    
    if (!tokens || !Array.isArray(tokens) || !title || !body) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    const emergencyData = { isEmergency: "true", roomId: roomId || "" };
    const result = await sendMulticastNotification(tokens, title, body, emergencyData);
    
    if (result.success) {
        return res.status(200).json(result);
    } else {
        return res.status(500).json(result);
    }
});

module.exports = router;
