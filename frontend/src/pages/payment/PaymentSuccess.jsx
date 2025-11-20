import React, { useState, useEffect } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import { CheckCircle, Download, Calendar, MapPin, User, CreditCard, FileText } from 'lucide-react';
import { paymentAPI, invoiceAPI } from '../../services/api';
import { toast } from 'react-toastify';

const PaymentSuccess = () => {
    const [searchParams] = useSearchParams();
    const navigate = useNavigate();
    const [payment, setPayment] = useState(null);
    const [invoice, setInvoice] = useState(null);
    const [isLoading, setIsLoading] = useState(true);

    const orderId = searchParams.get('order_id');

    useEffect(() => {
        if (!orderId) {
            navigate('/');
            return;
        }

        fetchPaymentDetails();
    }, [orderId]);

    const fetchPaymentDetails = async () => {
        try {
            console.log('Checking payment status for order:', orderId);
            const response = await paymentAPI.checkStatus(orderId);
            console.log('Payment status response:', response.data);
            setPayment(response.data.data);

            // If payment is successful, fetch invoice
            if (response.data.data.payment_status === 'paid' && response.data.data.registration) {
                // Find invoice by registration
                const invoicesResponse = await invoiceAPI.getUserInvoices();
                const userInvoice = invoicesResponse.data.data.find(inv =>
                    inv.registration_id === response.data.data.registration.id
                );
                if (userInvoice) {
                    setInvoice(userInvoice);
                }
                toast.success('Registrasi berhasil!');
            } else if (response.data.data.payment_status === 'pending') {
                toast.info('Menunggu konfirmasi pembayaran dari Xendit...');
                // Retry after 3 seconds
                setTimeout(() => {
                    fetchPaymentDetails();
                }, 3000);
            }
        } catch (error) {
            console.error('Error fetching payment details:', error);
            toast.error('Gagal memuat detail pembayaran');
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

    const handleCompletePayment = async () => {
        try {
            setIsLoading(true);
            toast.info('Memproses pembayaran...');

            // Call simulate endpoint
            const response = await paymentAPI.simulatePayment(orderId);

            if (response.data.success) {
                toast.success('Pembayaran berhasil dikonfirmasi!');
                // Refresh payment details
                await fetchPaymentDetails();
            }
        } catch (error) {
            console.error('Error completing payment:', error);
            toast.error('Gagal mengkonfirmasi pembayaran');
        } finally {
            setIsLoading(false);
        }
    };

    if (isLoading) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
            </div>
        );
    }

    if (!payment) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="text-center">
                    <h2 className="text-2xl font-bold text-gray-900 mb-4">Pembayaran Tidak Ditemukan</h2>
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
            <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
                {/* Success Header */}
                <div className="text-center mb-8">
                    <div className="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-green-100 mb-4">
                        <CheckCircle className="h-8 w-8 text-green-600" />
                    </div>
                    <h1 className="text-3xl font-bold text-gray-900 mb-2">Pembayaran Berhasil!</h1>
                    <p className="text-gray-600">
                        Terima kasih, pembayaran Anda telah berhasil diproses
                    </p>
                </div>

                {/* Payment Details Card */}
                <div className="bg-white rounded-2xl shadow-lg p-8 mb-6">
                    <h2 className="text-xl font-bold text-gray-900 mb-6">Detail Pembayaran</h2>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        {/* Order Info */}
                        <div>
                            <h3 className="font-semibold text-gray-900 mb-3">Informasi Pesanan</h3>
                            <div className="space-y-2 text-sm">
                                <div className="flex justify-between">
                                    <span className="text-gray-600">Order ID:</span>
                                    <span className="font-mono">{payment.order_id}</span>
                                </div>
                                <div className="flex justify-between">
                                    <span className="text-gray-600">Status:</span>
                                    <span className="text-green-600 font-semibold">LUNAS</span>
                                </div>
                                <div className="flex justify-between">
                                    <span className="text-gray-600">Total:</span>
                                    <span className="font-bold">Rp {parseInt(payment.amount).toLocaleString('id-ID')}</span>
                                </div>
                                {payment.paid_at && (
                                    <div className="flex justify-between">
                                        <span className="text-gray-600">Dibayar:</span>
                                        <span>{new Date(payment.paid_at).toLocaleString('id-ID')}</span>
                                    </div>
                                )}
                            </div>
                        </div>

                        {/* Event Info */}
                        {payment.event && (
                            <div>
                                <h3 className="font-semibold text-gray-900 mb-3">Detail Event</h3>
                                <div className="space-y-2 text-sm">
                                    <div className="flex items-start">
                                        <Calendar className="w-4 h-4 text-gray-400 mt-0.5 mr-2" />
                                        <div>
                                            <div className="font-medium">{payment.event.judul}</div>
                                            <div className="text-gray-600">
                                                {new Date(payment.event.tanggal).toLocaleDateString('id-ID', {
                                                    weekday: 'long',
                                                    year: 'numeric',
                                                    month: 'long',
                                                    day: 'numeric'
                                                })}
                                            </div>
                                        </div>
                                    </div>
                                    {payment.event.lokasi && (
                                        <div className="flex items-center">
                                            <MapPin className="w-4 h-4 text-gray-400 mr-2" />
                                            <span className="text-gray-600">{payment.event.lokasi}</span>
                                        </div>
                                    )}
                                </div>
                            </div>
                        )}
                    </div>
                </div>

                {/* Registration Info */}
                {payment.registration && (
                    <div className="bg-blue-50 rounded-2xl p-6 mb-6">
                        <div className="flex items-center mb-4">
                            <User className="w-5 h-5 text-blue-600 mr-2" />
                            <h3 className="font-semibold text-blue-900">Registrasi Berhasil</h3>
                        </div>
                        <p className="text-blue-800 mb-3">
                            Anda telah berhasil terdaftar untuk event ini. Simpan token kehadiran berikut:
                        </p>
                        <div className="bg-white rounded-lg p-4">
                            <div className="text-center">
                                <div className="text-sm text-gray-600 mb-1">Token Kehadiran</div>
                                <div className="text-2xl font-mono font-bold text-blue-600">
                                    {payment.registration.attendance_token}
                                </div>
                            </div>
                        </div>
                    </div>
                )}

                {/* Actions */}
                <div className="flex flex-col sm:flex-row gap-4">
                    {/* Sandbox Only: Complete Payment Button */}
                    {payment.payment_status === 'pending' && (
                        <button
                            onClick={handleCompletePayment}
                            disabled={isLoading}
                            className="flex items-center justify-center px-6 py-3 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            <CheckCircle className="w-5 h-5 mr-2" />
                            Complete Payment (Sandbox)
                        </button>
                    )}

                    {invoice && (
                        <button
                            onClick={handleDownloadInvoice}
                            className="flex items-center justify-center px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                        >
                            <Download className="w-5 h-5 mr-2" />
                            Download Invoice
                        </button>
                    )}

                    <button
                        onClick={() => navigate('/profile?tab=events')}
                        className="flex items-center justify-center px-6 py-3 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors"
                    >
                        <FileText className="w-5 h-5 mr-2" />
                        Lihat Event Saya
                    </button>

                    <button
                        onClick={() => navigate('/')}
                        className="flex items-center justify-center px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
                    >
                        Kembali ke Beranda
                    </button>
                </div>
            </div>
        </div>
    );
};

export default PaymentSuccess;
