const { default: Xendit } = require('xendit-node');
const { Payment, Event, User, EventRegistration, Invoice } = require('../models');
const crypto = require('crypto');

// Initialize Xendit
console.log('Initializing Xendit with:', {
    secretKey: process.env.XENDIT_SECRET_KEY ? 'SET' : 'NOT SET'
});

const xenditClient = new Xendit({
    secretKey: process.env.XENDIT_SECRET_KEY
});

const { Invoice: XenditInvoice } = xenditClient;

// Generate unique external ID for Xendit
const generateExternalId = () => {
    const timestamp = Date.now();
    const random = Math.random().toString(36).substring(2, 8);
    return `ORDER-${timestamp}-${random}`.toUpperCase();
};

// Generate unique invoice number
const generateInvoiceNumber = () => {
    const timestamp = Date.now();
    const random = Math.random().toString(36).substring(2, 6);
    return `INV-${timestamp}-${random}`.toUpperCase();
};

// Create payment for paid event
const createPayment = async (req, res) => {
    try {
        const { eventId } = req.params;
        const userId = req.user.id;

        console.log('=== CREATE PAYMENT START ===');
        console.log('Creating payment for event:', eventId, 'user:', userId);

        // Get event details
        console.log('Step 1: Getting event details...');
        const event = await Event.findByPk(eventId);
        if (!event) {
            console.log('Event not found:', eventId);
            return res.status(404).json({
                success: false,
                message: 'Event tidak ditemukan'
            });
        }
        console.log('Event found:', { id: event.id, judul: event.judul, biaya: event.biaya });

        // Check if event is paid
        console.log('Step 2: Checking if event is paid...');
        if (!event.biaya || event.biaya <= 0) {
            console.log('Event is free, biaya:', event.biaya);
            return res.status(400).json({
                success: false,
                message: 'Event ini gratis, tidak memerlukan pembayaran'
            });
        }
        console.log('Event is paid, biaya:', event.biaya);

        // Check if user already registered
        console.log('Step 3: Checking existing registration...');
        const existingRegistration = await EventRegistration.findOne({
            where: { user_id: userId, event_id: eventId }
        });

        if (existingRegistration) {
            console.log('User already registered');
            return res.status(400).json({
                success: false,
                message: 'Anda sudah terdaftar untuk event ini'
            });
        }
        console.log('No existing registration found');

        // Get user details
        console.log('Step 4: Getting user details...');
        const user = await User.findByPk(userId);
        if (!user) {
            console.log('User not found:', userId);
            return res.status(404).json({
                success: false,
                message: 'User tidak ditemukan'
            });
        }
        console.log('User found:', { id: user.id, nama: user.nama_lengkap });

        // Generate external ID for Xendit
        const externalId = generateExternalId();

        // Create payment record
        console.log('Creating payment with data:', {
            user_id: userId,
            event_id: eventId,
            order_id: externalId,
            amount: event.biaya,
            payment_status: 'pending'
        });

        const payment = await Payment.create({
            user_id: userId,
            event_id: eventId,
            order_id: externalId,
            amount: event.biaya,
            payment_status: 'pending',
            expired_at: new Date(Date.now() + 24 * 60 * 60 * 1000) // 24 hours
        });

        console.log('Payment created with ID:', payment.id);

        // Prepare Xendit invoice details
        const invoiceData = {
            externalId: externalId,
            amount: parseInt(event.biaya),
            payerEmail: user.email,
            description: `Pembayaran untuk ${event.judul}`,
            customer: {
                given_names: user.nama_lengkap,
                email: user.email,
                mobile_number: user.no_handphone || ''
            },
            customerNotificationPreference: {
                invoice_created: ['email'],
                invoice_reminder: ['email'],
                invoice_paid: ['email']
            },
            successRedirectUrl: `${process.env.FRONTEND_URL}/payment/success?order_id=${externalId}`,
            failureRedirectUrl: `${process.env.FRONTEND_URL}/payment/error?order_id=${externalId}`,
            currency: 'IDR',
            items: [{
                name: event.judul,
                quantity: 1,
                price: parseInt(event.biaya),
                category: event.kategori || 'Event'
            }]
        };

        console.log('Xendit invoice data:', JSON.stringify(invoiceData, null, 2));

        // Create invoice with Xendit (SDK expects data wrapper)
        console.log('Calling Xendit createInvoice...');
        const xenditInvoice = await XenditInvoice.createInvoice({
            data: invoiceData
        });

        console.log('Xendit response received:', JSON.stringify(xenditInvoice, null, 2));

        // Update payment with Xendit invoice data
        await payment.update({
            xendit_invoice_id: xenditInvoice.id,
            xendit_response: JSON.stringify(xenditInvoice)
        });

        console.log('Payment created successfully:', payment.id);
        console.log('Invoice URL:', xenditInvoice.invoiceUrl);

        res.json({
            success: true,
            message: 'Payment berhasil dibuat',
            data: {
                payment_id: payment.id,
                order_id: externalId,
                invoice_url: xenditInvoice.invoiceUrl,
                invoice_id: xenditInvoice.id,
                amount: event.biaya,
                event: {
                    id: event.id,
                    judul: event.judul,
                    biaya: event.biaya
                }
            }
        });

    } catch (error) {
        console.error('Create payment error:', error);
        console.error('Error stack:', error.stack);
        console.error('Error details:', {
            name: error.name,
            message: error.message,
            sql: error.sql,
            parameters: error.parameters
        });
        res.status(500).json({
            success: false,
            message: 'Gagal membuat pembayaran',
            error: error.message,
            details: error.name
        });
    }
};

// Handle Xendit webhook notification
const handleNotification = async (req, res) => {
    try {
        console.log('Xendit notification received:', req.body);

        const notification = req.body;
        const externalId = notification.external_id;
        const invoiceStatus = notification.status;

        // Find payment
        const payment = await Payment.findOne({
            where: { order_id: externalId },
            include: [
                { model: User, as: 'user' },
                { model: Event, as: 'event' }
            ]
        });

        if (!payment) {
            console.log('Payment not found for external_id:', externalId);
            return res.status(404).json({
                success: false,
                message: 'Payment not found'
            });
        }

        // Update payment status based on Xendit notification
        let paymentStatus = 'pending';
        let shouldCreateRegistration = false;

        // Xendit invoice statuses: PENDING, PAID, EXPIRED, SETTLED
        if (invoiceStatus === 'PAID' || invoiceStatus === 'SETTLED') {
            paymentStatus = 'paid';
            shouldCreateRegistration = true;
        } else if (invoiceStatus === 'EXPIRED') {
            paymentStatus = 'expired';
        } else if (invoiceStatus === 'PENDING') {
            paymentStatus = 'pending';
        }

        // Update payment
        await payment.update({
            transaction_id: notification.id,
            payment_method: notification.payment_channel || 'xendit',
            payment_status: paymentStatus,
            paid_at: paymentStatus === 'paid' ? new Date() : null,
            xendit_response: JSON.stringify(notification)
        });

        // Create registration and invoice if payment is successful
        if (shouldCreateRegistration && paymentStatus === 'paid') {
            // Check if registration already exists
            const existingRegistration = await EventRegistration.findOne({
                where: { user_id: payment.user_id, event_id: payment.event_id }
            });

            if (!existingRegistration) {
                // Generate attendance token
                const attendanceToken = Math.random().toString().substr(2, 10);

                // Create registration
                const registration = await EventRegistration.create({
                    user_id: payment.user_id,
                    event_id: payment.event_id,
                    payment_id: payment.id,
                    status: 'confirmed',
                    attendance_token: attendanceToken
                });

                // Create invoice
                const invoiceNumber = generateInvoiceNumber();
                await Invoice.create({
                    invoice_number: invoiceNumber,
                    user_id: payment.user_id,
                    event_id: payment.event_id,
                    payment_id: payment.id,
                    registration_id: registration.id,
                    invoice_type: 'paid',
                    amount: payment.amount,
                    total_amount: payment.amount,
                    invoice_status: 'paid',
                    paid_date: new Date()
                });

                console.log('Registration and invoice created for payment:', payment.id);
            }
        }

        console.log('Payment status updated:', paymentStatus);

        res.json({
            success: true,
            message: 'Notification processed'
        });

    } catch (error) {
        console.error('Handle notification error:', error);
        res.status(500).json({
            success: false,
            message: 'Error processing notification',
            error: error.message
        });
    }
};

// Check payment status (Manual check from Xendit - for sandbox development)
const checkPaymentStatus = async (req, res) => {
    try {
        const { orderId } = req.params;
        const userId = req.user.id;

        console.log('Checking payment status for order:', orderId);

        const payment = await Payment.findOne({
            where: {
                order_id: orderId,
                user_id: userId
            },
            include: [
                { model: Event, as: 'event' },
                { model: User, as: 'user' },
                { model: EventRegistration, as: 'registration' }
            ]
        });

        if (!payment) {
            return res.status(404).json({
                success: false,
                message: 'Payment tidak ditemukan'
            });
        }

        // If payment already completed, just return the status
        if (payment.payment_status === 'paid') {
            return res.json({
                success: true,
                data: {
                    order_id: payment.order_id,
                    payment_status: payment.payment_status,
                    amount: payment.amount,
                    paid_at: payment.paid_at,
                    event: payment.event,
                    registration: payment.registration
                }
            });
        }

        // Check status from Xendit if still pending
        if (payment.xendit_invoice_id) {
            try {
                console.log('Fetching invoice status from Xendit:', payment.xendit_invoice_id);

                const invoice = await XenditInvoice.getInvoice({
                    invoiceId: payment.xendit_invoice_id
                });

                console.log('Xendit invoice status:', invoice.status);

                let shouldCreateRegistration = false;
                let newPaymentStatus = payment.payment_status;

                // Update based on Xendit status
                if (invoice.status === 'PAID' || invoice.status === 'SETTLED') {
                    newPaymentStatus = 'paid';
                    shouldCreateRegistration = true;
                } else if (invoice.status === 'EXPIRED') {
                    newPaymentStatus = 'expired';
                } else if (invoice.status === 'PENDING') {
                    newPaymentStatus = 'pending';
                }

                // Update payment if status changed
                if (newPaymentStatus !== payment.payment_status) {
                    await payment.update({
                        payment_status: newPaymentStatus,
                        paid_at: newPaymentStatus === 'paid' ? new Date() : null,
                        payment_method: invoice.payment_channel || 'xendit',
                        xendit_response: JSON.stringify(invoice)
                    });

                    // Create registration and invoice if payment successful
                    if (shouldCreateRegistration && newPaymentStatus === 'paid') {
                        const existingRegistration = await EventRegistration.findOne({
                            where: { user_id: payment.user_id, event_id: payment.event_id }
                        });

                        if (!existingRegistration) {
                            const attendanceToken = Math.random().toString().substr(2, 10);

                            const registration = await EventRegistration.create({
                                user_id: payment.user_id,
                                event_id: payment.event_id,
                                payment_id: payment.id,
                                status: 'confirmed',
                                attendance_token: attendanceToken
                            });

                            // Create invoice
                            const invoiceNumber = generateInvoiceNumber();
                            await Invoice.create({
                                invoice_number: invoiceNumber,
                                user_id: payment.user_id,
                                event_id: payment.event_id,
                                payment_id: payment.id,
                                registration_id: registration.id,
                                amount: payment.amount,
                                invoice_type: 'paid',
                                status: 'issued'
                            });

                            // Reload payment with registration
                            await payment.reload({
                                include: [
                                    { model: Event, as: 'event' },
                                    { model: EventRegistration, as: 'registration' }
                                ]
                            });
                        }
                    }
                }
            } catch (xenditError) {
                console.error('Error checking Xendit invoice:', xenditError);
                // Continue with local payment status if Xendit check fails
            }
        }

        res.json({
            success: true,
            data: {
                order_id: payment.order_id,
                payment_status: payment.payment_status,
                amount: payment.amount,
                paid_at: payment.paid_at,
                event: payment.event,
                registration: payment.registration
            }
        });

    } catch (error) {
        console.error('Check payment status error:', error);
        res.status(500).json({
            success: false,
            message: 'Error checking payment status',
            error: error.message
        });
    }
};

// Get user payments
const getUserPayments = async (req, res) => {
    try {
        const userId = req.user.id;

        const payments = await Payment.findAll({
            where: { user_id: userId },
            include: [
                {
                    model: Event,
                    as: 'event',
                    attributes: ['id', 'judul', 'tanggal', 'harga', 'flyer_url']
                }
            ],
            order: [['createdAt', 'DESC']]
        });

        res.json({
            success: true,
            data: payments
        });

    } catch (error) {
        console.error('Get user payments error:', error);
        res.status(500).json({
            success: false,
            message: 'Error getting payments',
            error: error.message
        });
    }
};

// Process free event registration (no payment needed)
const processFreeRegistration = async (req, res) => {
    try {
        const { eventId } = req.params;
        const userId = req.user.id;

        console.log('Processing free registration for event:', eventId, 'user:', userId);

        // Get event details
        const event = await Event.findByPk(eventId);
        if (!event) {
            return res.status(404).json({
                success: false,
                message: 'Event tidak ditemukan'
            });
        }

        // Check if event is free
        if (event.biaya && event.biaya > 0) {
            return res.status(400).json({
                success: false,
                message: 'Event ini berbayar, silakan lakukan pembayaran'
            });
        }

        // Check if user already registered
        const existingRegistration = await EventRegistration.findOne({
            where: { user_id: userId, event_id: eventId }
        });

        if (existingRegistration) {
            return res.status(400).json({
                success: false,
                message: 'Anda sudah terdaftar untuk event ini'
            });
        }

        // Generate attendance token
        const attendanceToken = Math.random().toString().substr(2, 10);

        // Create registration
        const registration = await EventRegistration.create({
            user_id: userId,
            event_id: eventId,
            status: 'confirmed',
            attendance_token: attendanceToken
        });

        // Create free invoice
        const invoiceNumber = generateInvoiceNumber();
        const invoice = await Invoice.create({
            invoice_number: invoiceNumber,
            user_id: userId,
            event_id: eventId,
            registration_id: registration.id,
            invoice_type: 'free',
            amount: 0,
            total_amount: 0,
            invoice_status: 'paid',
            paid_date: new Date()
        });

        console.log('Free registration completed:', registration.id);

        res.json({
            success: true,
            message: 'Registrasi berhasil',
            data: {
                registration_id: registration.id,
                invoice_number: invoice.invoice_number,
                attendance_token: attendanceToken,
                event: {
                    id: event.id,
                    judul: event.judul
                }
            }
        });

    } catch (error) {
        console.error('Process free registration error:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal melakukan registrasi',
            error: error.message
        });
    }
};

// SANDBOX ONLY: Simulate payment completion for testing
const simulatePaymentCompletion = async (req, res) => {
    try {
        const { orderId } = req.params;
        const userId = req.user.id;

        console.log('=== SIMULATING PAYMENT COMPLETION ===');
        console.log('Order ID:', orderId);
        console.log('User ID:', userId);

        // Find payment
        const payment = await Payment.findOne({
            where: {
                order_id: orderId,
                user_id: userId
            },
            include: [
                { model: Event, as: 'event' },
                { model: User, as: 'user' }
            ]
        });

        if (!payment) {
            return res.status(404).json({
                success: false,
                message: 'Payment tidak ditemukan'
            });
        }

        if (payment.payment_status === 'paid') {
            return res.json({
                success: true,
                message: 'Payment sudah lunas',
                data: payment
            });
        }

        // Update payment to paid
        await payment.update({
            payment_status: 'paid',
            paid_at: new Date(),
            payment_method: 'xendit_sandbox_simulation'
        });

        console.log('Payment marked as paid');

        // Check if registration already exists
        const existingRegistration = await EventRegistration.findOne({
            where: { user_id: payment.user_id, event_id: payment.event_id }
        });

        if (!existingRegistration) {
            // Generate attendance token
            const attendanceToken = Math.random().toString().substr(2, 10);

            // Create registration
            const registration = await EventRegistration.create({
                user_id: payment.user_id,
                event_id: payment.event_id,
                payment_id: payment.id,
                status: 'confirmed',
                attendance_token: attendanceToken
            });

            console.log('Registration created:', registration.id);

            // Create invoice
            const invoiceNumber = generateInvoiceNumber();
            const invoice = await Invoice.create({
                invoice_number: invoiceNumber,
                user_id: payment.user_id,
                event_id: payment.event_id,
                payment_id: payment.id,
                registration_id: registration.id,
                amount: payment.amount,
                invoice_type: 'paid',
                status: 'issued'
            });

            console.log('Invoice created:', invoice.invoice_number);
        }

        // Reload payment with registration
        await payment.reload({
            include: [
                { model: Event, as: 'event' },
                { model: EventRegistration, as: 'registration' }
            ]
        });

        console.log('=== SIMULATION COMPLETE ===');

        res.json({
            success: true,
            message: 'Payment berhasil disimulasikan sebagai lunas',
            data: payment
        });

    } catch (error) {
        console.error('Simulate payment error:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal mensimulasikan pembayaran',
            error: error.message
        });
    }
};

module.exports = {
    createPayment,
    handleNotification,
    checkPaymentStatus,
    getUserPayments,
    processFreeRegistration,
    simulatePaymentCompletion
};
