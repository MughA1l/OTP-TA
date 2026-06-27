const express = require('express');
const router = express.Router();
const { sendCredentialsEmail } = require('../services/email_service');

// POST /api/email/credentials
router.post('/credentials', async (req, res) => {
    const { email, patientName, tempPassword } = req.body;

    if (!email || !patientName || !tempPassword) {
        return res.status(400).json({ error: 'Missing required fields: email, patientName, tempPassword' });
    }

    const result = await sendCredentialsEmail(email, patientName, tempPassword);

    if (result.success) {
        return res.status(200).json(result);
    } else {
        return res.status(500).json(result);
    }
});

module.exports = router;
