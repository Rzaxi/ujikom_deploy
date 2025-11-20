const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');
const invoiceController = require('../controllers/invoiceController');
const { authenticateToken } = require('../middleware/auth');

// Payment routes (protected)
router.use(authenticateToken);

// Create payment for paid event
router.post('/events/:eventId/payment', (req, res, next) => {
    console.log('=== PAYMENT ROUTE HIT ===');
    console.log('Method:', req.method);
    console.log('URL:', req.url);
    console.log('Params:', req.params);
    console.log('User:', req.user ? req.user.id : 'NO USER');
    next();
}, paymentController.createPayment);

// Process free event registration
router.post('/events/:eventId/register-free', paymentController.processFreeRegistration);

// Check payment status
router.get('/status/:orderId', paymentController.checkPaymentStatus);

// SANDBOX ONLY: Simulate payment completion
router.post('/simulate-payment/:orderId', paymentController.simulatePaymentCompletion);

// Get user payments
router.get('/my-payments', paymentController.getUserPayments);

// Invoice routes
router.get('/invoices', invoiceController.getUserInvoices);
router.get('/invoices/:invoiceId', invoiceController.getInvoiceById);
router.get('/invoices/:invoiceId/download', invoiceController.downloadInvoicePDF);

module.exports = router;
