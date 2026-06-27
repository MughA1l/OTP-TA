const { Resend } = require('resend');

const resend = new Resend(process.env.RESEND_API_KEY);

const sendCredentialsEmail = async (toEmail, patientName, tempPassword) => {
    try {
        const { data, error } = await resend.emails.send({
            from: 'OTPTA App <onboarding@resend.dev>', // Update with your verified domain
            to: [toEmail],
            subject: 'Your OTPTA Login Credentials',
            html: `
                <h2>Welcome to OTPTA, ${patientName}!</h2>
                <p>Your operation has been scheduled. You can now log into the patient portal to track your status, view medications, and communicate with your surgical team.</p>
                <p><strong>Email:</strong> ${toEmail}</p>
                <p><strong>Temporary Password:</strong> ${tempPassword}</p>
                <br/>
                <p>Please log in and change your password within 24 hours.</p>
            `
        });

        if (error) {
            console.error('Resend API Error:', error);
            return { success: false, error };
        }

        return { success: true, data };
    } catch (error) {
        console.error('Error sending email:', error);
        return { success: false, error: error.message };
    }
};

module.exports = {
    sendCredentialsEmail
};
