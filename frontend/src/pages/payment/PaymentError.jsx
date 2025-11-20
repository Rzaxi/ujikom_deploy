import React, { useState, useEffect } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import { XCircle, RefreshCw, ArrowLeft, CreditCard } from 'lucide-react';
import { paymentAPI } from '../../services/api';
import { toast } from 'react-toastify';

const PaymentError = () => {
    const [searchParams] = useSearchParams();
    const navigate = useNavigate();
    const [payment, setPayment] = useState(null);
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
            const response = await paymentAPI.checkStatus(orderId);
            setPayment(response.data.data);

            // If payment is actually successful, redirect to success page
            if (response.data.data.payment_status === 'paid') {
                navigate(`/payment/success?order_id=${orderId}`);
            }
        } catch (error) {
            console.error('Error fetching payment details:', error);
            // Continue to show error page even if we can't fetch details
        } finally {
            setIsLoading(false);
        }
    };

    const handleRetryPayment = () => {
        if (payment?.event?.id) {
            navigate(`/events/${payment.event.id}/confirm`);
        } else {
            navigate('/events');
        }
    };

    const getErrorMessage = () => {
        if (!payment) return 'Pembayaran tidak dapat diproses';

        switch (payment.payment_status) {
            case 'failed':
                return 'Pembayaran gagal diproses';
            case 'expired':
                return 'Pembayaran telah kedaluwarsa';
            case 'cancelled':
                return 'Pembayaran dibatalkan';
            default:
                return 'Terjadi kesalahan pada pembayaran';
        }
    };

    const getErrorDescription = () => {
        if (!payment) return 'Silakan coba lagi atau hubungi customer service';

        switch (payment.payment_status) {
            case 'failed':
                return 'Pembayaran tidak dapat diproses. Pastikan saldo mencukupi dan coba lagi.';
            case 'expired':
                return 'Waktu pembayaran telah habis. Silakan buat pesanan baru.';
            case 'cancelled':
                return 'Pembayaran dibatalkan oleh pengguna.';
            default:
                return 'Terjadi kesalahan teknis. Silakan coba lagi atau hubungi customer service.';
        }
    };

    if (isLoading) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-gray-50 py-12">
            <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
                {/* Error Header */}
                <div className="text-center mb-8">
                    <div className="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-red-100 mb-4">
                        <XCircle className="h-8 w-8 text-red-600" />
                    </div>
                    <h1 className="text-3xl font-bold text-gray-900 mb-2">{getErrorMessage()}</h1>
                    <p className="text-gray-600">
                        {getErrorDescription()}
                    </p>
                </div>

                {/* Payment Details Card */}
                {payment && (
                    <div className="bg-white rounded-2xl shadow-lg p-8 mb-6">
                        <h2 className="text-xl font-bold text-gray-900 mb-6">Detail Pembayaran</h2>

                        <div className="space-y-4">
                            <div className="flex justify-between items-center py-3 border-b border-gray-100">
                                <span className="text-gray-600">Order ID:</span>
                                <span className="font-mono text-sm">{payment.order_id}</span>
                            </div>

                            <div className="flex justify-between items-center py-3 border-b border-gray-100">
                                <span className="text-gray-600">Status:</span>
                                <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-800">
                                    <XCircle className="w-4 h-4 mr-1" />
                                    {payment.payment_status?.toUpperCase() || 'GAGAL'}
                                </span>
                            </div>

                            <div className="flex justify-between items-center py-3 border-b border-gray-100">
                                <span className="text-gray-600">Total:</span>
                                <span className="font-bold text-lg">Rp {parseInt(payment.amount).toLocaleString('id-ID')}</span>
                            </div>

                            {payment.event && (
                                <div className="py-3">
                                    <span className="text-gray-600 block mb-2">Event:</span>
                                    <div className="bg-gray-50 rounded-lg p-4">
                                        <h3 className="font-semibold text-gray-900">{payment.event.judul}</h3>
                                        <p className="text-gray-600 text-sm mt-1">
                                            {new Date(payment.event.tanggal).toLocaleDateString('id-ID', {
                                                weekday: 'long',
                                                year: 'numeric',
                                                month: 'long',
                                                day: 'numeric'
                                            })}
                                        </p>
                                    </div>
                                </div>
                            )}
                        </div>
                    </div>
                )}

                {/* Error Details */}
                <div className="bg-red-50 rounded-2xl p-6 mb-6">
                    <h3 className="font-semibold text-red-900 mb-3">Kemungkinan Penyebab:</h3>
                    <div className="text-red-800 text-sm space-y-2">
                        <p>• Saldo tidak mencukupi</p>
                        <p>• Koneksi internet terputus</p>
                        <p>• Kartu kredit/debit bermasalah</p>
                        <p>• Pembayaran dibatalkan</p>
                        <p>• Waktu pembayaran habis</p>
                    </div>
                </div>

                {/* Actions */}
                <div className="flex flex-col sm:flex-row gap-4">
                    <button
                        onClick={handleRetryPayment}
                        className="flex items-center justify-center px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                    >
                        <RefreshCw className="w-5 h-5 mr-2" />
                        Coba Lagi
                    </button>

                    <button
                        onClick={() => navigate('/profile?tab=payments')}
                        className="flex items-center justify-center px-6 py-3 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors"
                    >
                        <CreditCard className="w-5 h-5 mr-2" />
                        Riwayat Pembayaran
                    </button>

                    <button
                        onClick={() => navigate('/events')}
                        className="flex items-center justify-center px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
                    >
                        <ArrowLeft className="w-5 h-5 mr-2" />
                        Kembali ke Events
                    </button>
                </div>

                {/* Support Info */}
                <div className="text-center mt-8 p-6 bg-white rounded-2xl shadow-lg">
                    <h3 className="font-semibold text-gray-900 mb-2">Butuh Bantuan?</h3>
                    <p className="text-gray-600 text-sm mb-4">
                        Jika masalah berlanjut, silakan hubungi customer service kami
                    </p>
                    <div className="flex justify-center space-x-4 text-sm">
                        <span className="text-blue-600">Email: support@eventhub.com</span>
                        <span className="text-gray-400">|</span>
                        <span className="text-blue-600">WhatsApp: +62 812-3456-7890</span>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default PaymentError;
