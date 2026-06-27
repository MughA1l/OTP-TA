require('dotenv').config();
const express = require('express');
const cors = require('cors');

const notificationRoutes = require('./routes/notifications');
const emailRoutes = require('./routes/email');
const reminderRoutes = require('./routes/reminders');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// API Secret verification middleware
const verifyApiSecret = (req, res, next) => {
    const secret = req.headers['x-api-secret'];
    if (secret !== process.env.API_SECRET) {
        return res.status(401).json({ error: 'Unauthorized: Invalid API Secret' });
    }
    next();
};

// Health Check
app.get('/', (req, res) => {
    res.send('OTPTA Backend is running');
});

// Routes
app.use('/api/notify', verifyApiSecret, notificationRoutes);
app.use('/api/email', verifyApiSecret, emailRoutes);
app.use('/api/reminders', verifyApiSecret, reminderRoutes);

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
