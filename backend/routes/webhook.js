const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');

// WEBHOOK DISABLED FOR SANDBOX DEVELOPMENT
// Use manual payment status check instead via GET /api/payment/status/:orderId
// 
// Uncomment for production with Xendit webhook:
// router.post('/xendit', paymentController.handleNotification);

module.exports = router;
