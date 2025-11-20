const { Invoice, User, Event, Payment, EventRegistration } = require('../models');
const PDFDocument = require('pdfkit');
const path = require('path');
const fs = require('fs').promises;

// Get user invoices
const getUserInvoices = async (req, res) => {
    try {
        const userId = req.user.id;

        const invoices = await Invoice.findAll({
            where: { user_id: userId },
            include: [
                {
                    model: Event,
                    as: 'event',
                    attributes: ['id', 'judul', 'tanggal', 'lokasi', 'penyelenggara']
                },
                {
                    model: Payment,
                    as: 'payment',
                    attributes: ['payment_method', 'paid_at']
                }
            ],
            order: [['createdAt', 'DESC']]
        });

        res.json({
            success: true,
            data: invoices
        });

    } catch (error) {
        console.error('Get user invoices error:', error);
        res.status(500).json({
            success: false,
            message: 'Error getting invoices',
            error: error.message
        });
    }
};

// Get invoice by ID
const getInvoiceById = async (req, res) => {
    try {
        const { invoiceId } = req.params;
        const userId = req.user.id;

        const invoice = await Invoice.findOne({
            where: {
                id: invoiceId,
                user_id: userId
            },
            include: [
                {
                    model: User,
                    as: 'user',
                    attributes: ['nama_lengkap', 'email', 'no_handphone', 'alamat']
                },
                {
                    model: Event,
                    as: 'event',
                    attributes: ['id', 'judul', 'tanggal', 'lokasi', 'penyelenggara', 'biaya']
                },
                {
                    model: Payment,
                    as: 'payment',
                    attributes: ['payment_method', 'paid_at', 'transaction_id']
                },
                {
                    model: EventRegistration,
                    as: 'registration',
                    attributes: ['attendance_token', 'status']
                }
            ]
        });

        if (!invoice) {
            return res.status(404).json({
                success: false,
                message: 'Invoice tidak ditemukan'
            });
        }

        res.json({
            success: true,
            data: invoice
        });

    } catch (error) {
        console.error('Get invoice by ID error:', error);
        res.status(500).json({
            success: false,
            message: 'Error getting invoice',
            error: error.message
        });
    }
};

// Download invoice PDF
const downloadInvoicePDF = async (req, res) => {
    try {
        const { invoiceId } = req.params;
        const userId = req.user.id;

        const invoice = await Invoice.findOne({
            where: {
                id: invoiceId,
                user_id: userId
            },
            include: [
                {
                    model: User,
                    as: 'user',
                    attributes: ['nama_lengkap', 'email', 'no_handphone', 'alamat']
                },
                {
                    model: Event,
                    as: 'event',
                    attributes: ['id', 'judul', 'tanggal', 'lokasi', 'penyelenggara', 'biaya']
                },
                {
                    model: Payment,
                    as: 'payment',
                    attributes: ['payment_method', 'paid_at', 'transaction_id']
                }
            ]
        });

        if (!invoice) {
            return res.status(404).json({
                success: false,
                message: 'Invoice tidak ditemukan'
            });
        }

        // Create PDF
        const doc = new PDFDocument({ size: 'A4', margin: 50 });

        // Set response headers
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', `attachment; filename="Invoice-${invoice.invoice_number}.pdf"`);

        // Pipe PDF to response
        doc.pipe(res);

        // Header
        doc.fontSize(20).font('Helvetica-Bold').text('INVOICE', 50, 50);
        doc.fontSize(12).font('Helvetica').text(`Invoice #: ${invoice.invoice_number}`, 50, 80);
        doc.text(`Tanggal: ${new Date(invoice.issued_date).toLocaleDateString('id-ID')}`, 50, 100);

        if (invoice.invoice_status === 'paid') {
            doc.text(`Status: LUNAS`, 50, 120);
            if (invoice.paid_date) {
                doc.text(`Dibayar: ${new Date(invoice.paid_date).toLocaleDateString('id-ID')}`, 50, 140);
            }
        } else {
            doc.text(`Status: ${invoice.invoice_status.toUpperCase()}`, 50, 120);
        }

        // Company Info (right side)
        doc.text('EventHub', 400, 50);
        doc.text('Platform Event Management', 400, 70);
        doc.text('Jakarta, Indonesia', 400, 90);

        // Line separator
        doc.moveTo(50, 180).lineTo(550, 180).stroke();

        // Bill To
        doc.fontSize(14).font('Helvetica-Bold').text('Bill To:', 50, 200);
        doc.fontSize(12).font('Helvetica')
            .text(invoice.user.nama_lengkap, 50, 220)
            .text(invoice.user.email, 50, 240)
            .text(invoice.user.no_handphone || '-', 50, 260);

        if (invoice.user.alamat) {
            doc.text(invoice.user.alamat, 50, 280);
        }

        // Event Details
        doc.fontSize(14).font('Helvetica-Bold').text('Detail Event:', 50, 320);
        doc.fontSize(12).font('Helvetica')
            .text(`Event: ${invoice.event.judul}`, 50, 340)
            .text(`Tanggal: ${new Date(invoice.event.tanggal).toLocaleDateString('id-ID')}`, 50, 360)
            .text(`Lokasi: ${invoice.event.lokasi || '-'}`, 50, 380)
            .text(`Penyelenggara: ${invoice.event.penyelenggara || 'EventHub'}`, 50, 400);

        // Payment Details Table
        doc.fontSize(14).font('Helvetica-Bold').text('Rincian Pembayaran:', 50, 440);

        // Table header
        const tableTop = 470;
        doc.fontSize(12).font('Helvetica-Bold');
        doc.text('Deskripsi', 50, tableTop);
        doc.text('Jumlah', 350, tableTop);
        doc.text('Harga', 450, tableTop);

        // Table line
        doc.moveTo(50, tableTop + 20).lineTo(550, tableTop + 20).stroke();

        // Table content
        doc.fontSize(12).font('Helvetica');
        const itemY = tableTop + 30;
        doc.text(`Tiket ${invoice.event.judul}`, 50, itemY);
        doc.text('1', 350, itemY);

        const amount = invoice.invoice_type === 'free' ? 'GRATIS' : `Rp ${parseInt(invoice.amount).toLocaleString('id-ID')}`;
        doc.text(amount, 450, itemY);

        // Total
        doc.moveTo(300, itemY + 30).lineTo(550, itemY + 30).stroke();
        doc.fontSize(12).font('Helvetica-Bold');
        doc.text('Total:', 400, itemY + 40);
        const totalAmount = invoice.invoice_type === 'free' ? 'GRATIS' : `Rp ${parseInt(invoice.total_amount).toLocaleString('id-ID')}`;
        doc.text(totalAmount, 450, itemY + 40);

        // Payment Method (if paid)
        if (invoice.payment && invoice.payment.payment_method) {
            doc.fontSize(12).font('Helvetica');
            doc.text(`Metode Pembayaran: ${invoice.payment.payment_method}`, 50, itemY + 80);
            if (invoice.payment.transaction_id) {
                doc.text(`ID Transaksi: ${invoice.payment.transaction_id}`, 50, itemY + 100);
            }
        }

        // Footer
        doc.fontSize(10).font('Helvetica').fillColor('#666666');
        doc.text('Terima kasih telah menggunakan EventHub!', 50, 700);
        doc.text('Invoice ini dibuat secara otomatis dan sah tanpa tanda tangan.', 50, 720);

        // Finalize PDF
        doc.end();

    } catch (error) {
        console.error('Download invoice PDF error:', error);
        res.status(500).json({
            success: false,
            message: 'Error generating invoice PDF',
            error: error.message
        });
    }
};

// Get organizer payment summary
const getOrganizerPaymentSummary = async (req, res) => {
    try {
        const organizerId = req.user.id;

        // Get events created by organizer
        const { Event } = require('../models');
        const events = await Event.findAll({
            where: { created_by: organizerId },
            attributes: ['id']
        });

        const eventIds = events.map(event => event.id);

        if (eventIds.length === 0) {
            return res.json({
                success: true,
                data: {
                    total_revenue: 0,
                    total_transactions: 0,
                    paid_transactions: 0,
                    pending_transactions: 0,
                    events: []
                }
            });
        }

        // Get payment summary
        const { Sequelize } = require('sequelize');
        const payments = await Payment.findAll({
            where: { event_id: eventIds },
            include: [
                {
                    model: Event,
                    as: 'event',
                    attributes: ['id', 'judul', 'biaya']
                }
            ],
            attributes: [
                'event_id',
                [Sequelize.fn('COUNT', Sequelize.col('Payment.id')), 'total_count'],
                [Sequelize.fn('SUM', Sequelize.literal('CASE WHEN payment_status = "paid" THEN amount ELSE 0 END')), 'total_revenue'],
                [Sequelize.fn('COUNT', Sequelize.literal('CASE WHEN payment_status = "paid" THEN 1 END')), 'paid_count'],
                [Sequelize.fn('COUNT', Sequelize.literal('CASE WHEN payment_status = "pending" THEN 1 END')), 'pending_count']
            ],
            group: ['event_id'],
            raw: true
        });

        // Calculate totals
        let totalRevenue = 0;
        let totalTransactions = 0;
        let paidTransactions = 0;
        let pendingTransactions = 0;

        payments.forEach(payment => {
            totalRevenue += parseFloat(payment.total_revenue || 0);
            totalTransactions += parseInt(payment.total_count || 0);
            paidTransactions += parseInt(payment.paid_count || 0);
            pendingTransactions += parseInt(payment.pending_count || 0);
        });

        res.json({
            success: true,
            data: {
                total_revenue: totalRevenue,
                total_transactions: totalTransactions,
                paid_transactions: paidTransactions,
                pending_transactions: pendingTransactions,
                events: payments
            }
        });

    } catch (error) {
        console.error('Get organizer payment summary error:', error);
        res.status(500).json({
            success: false,
            message: 'Error getting payment summary',
            error: error.message
        });
    }
};

module.exports = {
    getUserInvoices,
    getInvoiceById,
    downloadInvoicePDF,
    getOrganizerPaymentSummary
};
