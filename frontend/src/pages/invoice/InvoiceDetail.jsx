import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Download, Calendar, MapPin, User, CreditCard, FileText, CheckCircle, ArrowLeft } from 'lucide-react';
import { invoiceAPI } from '../../services/api';
import { toast } from 'react-toastify';

const InvoiceDetail = () => {
    const { invoiceNumber } = useParams();
    const navigate = useNavigate();
    const [invoice, setInvoice] = useState(null);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        if (!invoiceNumber) {
            navigate('/');
            return;
        }

        fetchInvoiceDetails();
    }, [invoiceNumber]);

    const fetchInvoiceDetails = async () => {
        try {
            // Get all user invoices and find by invoice number
            const response = await invoiceAPI.getUserInvoices();
            const userInvoice = response.data.data.find(inv =>
                inv.invoice_number === invoiceNumber
            );

            if (userInvoice) {
                // Get detailed invoice
                const detailResponse = await invoiceAPI.getById(userInvoice.id);
                setInvoice(detailResponse.data.data);
            } else {
                toast.error('Invoice tidak ditemukan');
                navigate('/');
            }
        } catch (error) {
            console.error('Error fetching invoice details:', error);
            toast.error('Gagal memuat detail invoice');
            navigate('/');
        } finally {
            setIsLoading(false);
        }
    };

    const handleDownloadInvoice = async () => {
        if (!invoice) return;

        try {
            const response = await invoiceAPI.downloadPDF(invoice.id);

            // Create blob link to download
            const url = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', `Invoice-${invoice.invoice_number}.pdf`);
            document.body.appendChild(link);
            link.click();
            link.remove();
            window.URL.revokeObjectURL(url);

            toast.success('Invoice berhasil didownload!');
        } catch (error) {
            console.error('Error downloading invoice:', error);
            toast.error('Gagal mendownload invoice');
        }
    };

    if (isLoading) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
            </div>
        );
    }

    if (!invoice) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="text-center">
                    <h2 className="text-2xl font-bold text-gray-900 mb-4">Invoice Tidak Ditemukan</h2>
                    <button
                        onClick={() => navigate('/')}
                        className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700"
                    >
                        Kembali ke Beranda
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-gray-50 py-12">
            <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
                {/* Header */}
                <div className="flex items-center justify-between mb-8">
                    <div className="flex items-center">
                        <button
                            onClick={() => navigate(-1)}
                            className="mr-4 p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg"
                        >
                            <ArrowLeft className="w-5 h-5" />
                        </button>
                        <div>
                            <h1 className="text-3xl font-bold text-gray-900">Invoice</h1>
                            <p className="text-gray-600">#{invoice.invoice_number}</p>
                        </div>
                    </div>

                    <div className="flex items-center space-x-3">
                        <span className={`inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${invoice.invoice_status === 'paid'
                                ? 'bg-green-100 text-green-800'
                                : 'bg-yellow-100 text-yellow-800'
                            }`}>
                            {invoice.invoice_status === 'paid' && <CheckCircle className="w-4 h-4 mr-1" />}
                            {invoice.invoice_status === 'paid' ? 'LUNAS' : invoice.invoice_status.toUpperCase()}
                        </span>

                        <button
                            onClick={handleDownloadInvoice}
                            className="flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                        >
                            <Download className="w-4 h-4 mr-2" />
                            Download PDF
                        </button>
                    </div>
                </div>

                {/* Invoice Card */}
                <div className="bg-white rounded-2xl shadow-lg overflow-hidden">
                    {/* Invoice Header */}
                    <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white p-8">
                        <div className="flex justify-between items-start">
                            <div>
                                <h2 className="text-2xl font-bold mb-2">EventHub</h2>
                                <p className="text-blue-100">Platform Event Management</p>
                                <p className="text-blue-100">Jakarta, Indonesia</p>
                            </div>
                            <div className="text-right">
                                <div className="text-3xl font-bold mb-2">INVOICE</div>
                                <div className="text-blue-100">
                                    Tanggal: {new Date(invoice.issued_date).toLocaleDateString('id-ID')}
                                </div>
                                {invoice.paid_date && (
                                    <div className="text-blue-100">
                                        Dibayar: {new Date(invoice.paid_date).toLocaleDateString('id-ID')}
                                    </div>
                                )}
                            </div>
                        </div>
                    </div>

                    {/* Invoice Body */}
                    <div className="p-8">
                        {/* Bill To & Event Info */}
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
                            {/* Bill To */}
                            <div>
                                <h3 className="text-lg font-semibold text-gray-900 mb-4">Bill To:</h3>
                                <div className="space-y-2">
                                    <div className="flex items-center">
                                        <User className="w-4 h-4 text-gray-400 mr-2" />
                                        <span className="font-medium">{invoice.user.nama_lengkap}</span>
                                    </div>
                                    <div className="text-gray-600">{invoice.user.email}</div>
                                    {invoice.user.no_handphone && (
                                        <div className="text-gray-600">{invoice.user.no_handphone}</div>
                                    )}
                                    {invoice.user.alamat && (
                                        <div className="text-gray-600">{invoice.user.alamat}</div>
                                    )}
                                </div>
                            </div>

                            {/* Event Details */}
                            <div>
                                <h3 className="text-lg font-semibold text-gray-900 mb-4">Event Details:</h3>
                                <div className="space-y-2">
                                    <div className="flex items-start">
                                        <Calendar className="w-4 h-4 text-gray-400 mt-0.5 mr-2" />
                                        <div>
                                            <div className="font-medium">{invoice.event.judul}</div>
                                            <div className="text-gray-600 text-sm">
                                                {new Date(invoice.event.tanggal).toLocaleDateString('id-ID', {
                                                    weekday: 'long',
                                                    year: 'numeric',
                                                    month: 'long',
                                                    day: 'numeric'
                                                })}
                                            </div>
                                        </div>
                                    </div>
                                    {invoice.event.lokasi && (
                                        <div className="flex items-center">
                                            <MapPin className="w-4 h-4 text-gray-400 mr-2" />
                                            <span className="text-gray-600">{invoice.event.lokasi}</span>
                                        </div>
                                    )}
                                    <div className="text-gray-600">
                                        Penyelenggara: {invoice.event.penyelenggara || 'EventHub'}
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Invoice Items */}
                        <div className="mb-8">
                            <h3 className="text-lg font-semibold text-gray-900 mb-4">Rincian:</h3>
                            <div className="overflow-x-auto">
                                <table className="w-full">
                                    <thead>
                                        <tr className="border-b border-gray-200">
                                            <th className="text-left py-3 px-4 font-semibold text-gray-900">Deskripsi</th>
                                            <th className="text-center py-3 px-4 font-semibold text-gray-900">Qty</th>
                                            <th className="text-right py-3 px-4 font-semibold text-gray-900">Harga</th>
                                            <th className="text-right py-3 px-4 font-semibold text-gray-900">Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr className="border-b border-gray-100">
                                            <td className="py-4 px-4">
                                                <div className="font-medium">Tiket {invoice.event.judul}</div>
                                                <div className="text-sm text-gray-600">
                                                    {invoice.invoice_type === 'free' ? 'Event Gratis' : 'Event Berbayar'}
                                                </div>
                                            </td>
                                            <td className="text-center py-4 px-4">1</td>
                                            <td className="text-right py-4 px-4">
                                                {invoice.invoice_type === 'free'
                                                    ? 'GRATIS'
                                                    : `Rp ${parseInt(invoice.amount).toLocaleString('id-ID')}`
                                                }
                                            </td>
                                            <td className="text-right py-4 px-4 font-medium">
                                                {invoice.invoice_type === 'free'
                                                    ? 'GRATIS'
                                                    : `Rp ${parseInt(invoice.amount).toLocaleString('id-ID')}`
                                                }
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        {/* Totals */}
                        <div className="flex justify-end mb-8">
                            <div className="w-64">
                                <div className="flex justify-between py-2">
                                    <span className="text-gray-600">Subtotal:</span>
                                    <span>
                                        {invoice.invoice_type === 'free'
                                            ? 'GRATIS'
                                            : `Rp ${parseInt(invoice.amount).toLocaleString('id-ID')}`
                                        }
                                    </span>
                                </div>
                                {invoice.tax_amount > 0 && (
                                    <div className="flex justify-between py-2">
                                        <span className="text-gray-600">Pajak:</span>
                                        <span>Rp {parseInt(invoice.tax_amount).toLocaleString('id-ID')}</span>
                                    </div>
                                )}
                                <div className="flex justify-between py-2 border-t border-gray-200 font-bold text-lg">
                                    <span>Total:</span>
                                    <span>
                                        {invoice.invoice_type === 'free'
                                            ? 'GRATIS'
                                            : `Rp ${parseInt(invoice.total_amount).toLocaleString('id-ID')}`
                                        }
                                    </span>
                                </div>
                            </div>
                        </div>

                        {/* Payment Info */}
                        {invoice.payment && (
                            <div className="bg-gray-50 rounded-lg p-6 mb-6">
                                <h3 className="font-semibold text-gray-900 mb-3">Informasi Pembayaran:</h3>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                                    <div>
                                        <span className="text-gray-600">Metode Pembayaran:</span>
                                        <div className="font-medium">{invoice.payment.payment_method || '-'}</div>
                                    </div>
                                    {invoice.payment.transaction_id && (
                                        <div>
                                            <span className="text-gray-600">ID Transaksi:</span>
                                            <div className="font-mono text-xs">{invoice.payment.transaction_id}</div>
                                        </div>
                                    )}
                                </div>
                            </div>
                        )}

                        {/* Registration Info */}
                        {invoice.registration && (
                            <div className="bg-blue-50 rounded-lg p-6">
                                <h3 className="font-semibold text-blue-900 mb-3">Informasi Registrasi:</h3>
                                <div className="text-blue-800">
                                    <p className="mb-2">Anda telah berhasil terdaftar untuk event ini.</p>
                                    <div className="bg-white rounded-lg p-3 inline-block">
                                        <div className="text-sm text-gray-600">Token Kehadiran:</div>
                                        <div className="font-mono font-bold text-blue-600">
                                            {invoice.registration.attendance_token}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        )}

                        {/* Footer */}
                        <div className="mt-8 pt-6 border-t border-gray-200 text-center text-sm text-gray-500">
                            <p>Terima kasih telah menggunakan EventHub!</p>
                            <p>Invoice ini dibuat secara otomatis dan sah tanpa tanda tangan.</p>
                        </div>
                    </div>
                </div>

                {/* Actions */}
                <div className="flex justify-center mt-8 space-x-4">
                    <button
                        onClick={() => navigate('/profile?tab=events')}
                        className="px-6 py-3 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors"
                    >
                        <FileText className="w-5 h-5 mr-2 inline" />
                        Lihat Event Saya
                    </button>

                    <button
                        onClick={() => navigate('/')}
                        className="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
                    >
                        Kembali ke Beranda
                    </button>
                </div>
            </div>
        </div>
    );
};

export default InvoiceDetail;
