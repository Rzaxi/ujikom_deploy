import React, { useState, useEffect } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import { Clock, RefreshCw, CreditCard, AlertCircle } from 'lucide-react';
import { paymentAPI } from '../../services/api';
import { toast } from 'react-toastify';

const PaymentPending = () => {
    const [searchParams] = useSearchParams();
    const navigate = useNavigate();
    const [payment, setPayment] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [isChecking, setIsChecking] = useState(false);

    const orderId = searchParams.get('order_id');

    useEffect(() => {
        if (!orderId) {
            navigate('/');
            return;
        }

        fetchPaymentDetails();

        // Auto-check payment status every 30 seconds
        const interval = setInterval(fetchPaymentDetails, 30000);

        return () => clearInterval(interval);
    }, [orderId]);

    const fetchPaymentDetails = async () => {
        try {
            const response = await paymentAPI.checkStatus(orderId);
            setPayment(response.data.data);

            // If payment is completed, redirect to success page
            if (response.data.data.payment_status === 'paid') {
                toast.success('Pembayaran berhasil!');
                navigate(`/payment/success?order_id=${orderId}`);
            } else if (response.data.data.payment_status === 'failed' ||
                response.data.data.payment_status === 'expired') {
                toast.error('Pembayaran gagal atau expired');
                navigate(`/payment/error?order_id=${orderId}`);
            }
        } catch (error) {
            console.error('Error fetching payment details:', error);
            toast.error('Gagal memuat detail pembayaran');
        } finally {
            setIsLoading(false);
        }
    };

    const handleCheckStatus = async () => {
        setIsChecking(true);
        await fetchPaymentDetails();
        setIsChecking(false);
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
            <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
                {/* Pending Header */}
                <div className="text-center mb-8">
                    <div className="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-yellow-100 mb-4">
                        <Clock className="h-8 w-8 text-yellow-600" />
                    </div>
                    <h1 className="text-3xl font-bold text-gray-900 mb-2">Pembayaran Pending</h1>
                    <p className="text-gray-600">
                        Pembayaran Anda sedang diproses, silakan tunggu konfirmasi
                    </p>
                </div>

                {/* Payment Details Card */}
                <div className="bg-white rounded-2xl shadow-lg p-8 mb-6">
                    <h2 className="text-xl font-bold text-gray-900 mb-6">Detail Pembayaran</h2>

                    <div className="space-y-4">
                        <div className="flex justify-between items-center py-3 border-b border-gray-100">
                            <span className="text-gray-600">Order ID:</span>
                            <span className="font-mono text-sm">{payment.order_id}</span>
                        </div>

                        <div className="flex justify-between items-center py-3 border-b border-gray-100">
                            <span className="text-gray-600">Status:</span>
                            <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-yellow-100 text-yellow-800">
                                <Clock className="w-4 h-4 mr-1" />
                                PENDING
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

                {/* Instructions */}
                <div className="bg-blue-50 rounded-2xl p-6 mb-6">
                    <div className="flex items-start">
                        <AlertCircle className="w-5 h-5 text-blue-600 mt-0.5 mr-3" />
                        <div>
                            <h3 className="font-semibold text-blue-900 mb-2">Instruksi Pembayaran</h3>
                            <div className="text-blue-800 text-sm space-y-2">
                                <p>• Selesaikan pembayaran sesuai metode yang Anda pilih</p>
                                <p>• Pembayaran akan otomatis terkonfirmasi dalam beberapa menit</p>
                                <p>• Anda akan menerima notifikasi email setelah pembayaran berhasil</p>
                                <p>• Jika ada kendala, hubungi customer service kami</p>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Actions */}
                <div className="flex flex-col sm:flex-row gap-4">
                    <button
                        onClick={handleCheckStatus}
                        disabled={isChecking}
                        className="flex items-center justify-center px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50"
                    >
                        <RefreshCw className={`w-5 h-5 mr-2 ${isChecking ? 'animate-spin' : ''}`} />
                        {isChecking ? 'Mengecek...' : 'Cek Status Pembayaran'}
                    </button>

                    <button
                        onClick={() => navigate('/profile?tab=payments')}
                        className="flex items-center justify-center px-6 py-3 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors"
                    >
                        <CreditCard className="w-5 h-5 mr-2" />
                        Lihat Riwayat Pembayaran
                    </button>

                    <button
                        onClick={() => navigate('/')}
                        className="flex items-center justify-center px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
                    >
                        Kembali ke Beranda
                    </button>
                </div>

                {/* Auto Refresh Notice */}
                <div className="text-center mt-6">
                    <p className="text-sm text-gray-500">
                        Status pembayaran akan otomatis diperbarui setiap 30 detik
                    </p>
                </div>
            </div>
        </div>
    );
};

export default PaymentPending;
