const {onCall, HttpsError} = require("firebase-functions/v2/https");
const sgMail = require("@sendgrid/mail");

// Default sender, kept as a fallback when the client does not specify one.
const DEFAULT_SENDER_EMAIL = "bear.uk@bearsnacks.com";
const DEFAULT_SENDER_NAME = "Bear Snacks UK";

// Allow-list of sender mailboxes the client may select. This guards against
// arbitrary `from` addresses being injected via the callable payload.
const ALLOWED_SENDERS = {
  "bear.uk@bearsnacks.com": "Bear Snacks UK",
  "bear.us@bearsnacks.com": "Bear Snacks US",
};

exports.sendUserEmail = onCall(
    {region: "europe-west1"},
    async (request) => {
      if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "Login is required to send email.",
        );
      }

      const apiKey = process.env.SENDGRID_API_KEY;
      if (!apiKey) {
        throw new HttpsError("internal", "SendGrid API key not configured.");
      }
      sgMail.setApiKey(apiKey);

      // Data sent from your app
      const {
        to,
        toName,
        replyTo,
        replyToName,
        subject,
        content,
        htmlContent,
        senderEmail,
        senderName,
      } = request.data;

      // Resolve the sender against the allow-list. Unknown values fall back
      // to the default sender to prevent spoofing.
      let resolvedSenderEmail = DEFAULT_SENDER_EMAIL;
      let resolvedSenderName = DEFAULT_SENDER_NAME;
      if (senderEmail && Object.prototype.hasOwnProperty.call(
          ALLOWED_SENDERS, senderEmail)) {
        resolvedSenderEmail = senderEmail;
        resolvedSenderName = senderName || ALLOWED_SENDERS[senderEmail];
      }

      const msg = {
        to: toName ? {email: to, name: toName} : to,
        from: {email: resolvedSenderEmail, name: resolvedSenderName},
        replyTo: replyToName ? {email: replyTo, name: replyToName} : replyTo,
        subject: subject,
        text: content,
        html: htmlContent,
      };

      try {
        await sgMail.send(msg);
        return {success: true, message: "Email successfully sent!"};
      } catch (error) {
        console.error(error);
        if (error.response) {
          console.error(error.response.body);
        }
        throw new HttpsError("internal", "Could not send email.");
      }
    },
);
