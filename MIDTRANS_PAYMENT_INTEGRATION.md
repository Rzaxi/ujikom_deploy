# Midtrans Payment Gateway Integration

## Overview
Sistem EventHub sekarang telah terintegrasi dengan Midtrans Payment Gateway untuk menangani pembayaran event berbayar. Sistem ini mendukung:

- **Event Gratis**: Registrasi langsung tanpa pembayaran
- **Event Berbayar**: Pembayaran melalui Midtrans Sandbox
- **Invoice System**: Otomatis generate invoice untuk semua registrasi
- **Payment Tracking**: Dashboard organizer untuk tracking pembayaran

## Setup Configuration

### 1. Environment Variables (.env)
Tambahkan konfigurasi Midtrans ke file `.env`:

```bash
# Midtrans Configuration (Sandbox)
MIDTRANS_SERVER_KEY=your-sandbox-server-key
MIDTRANS_CLIENT_KEY=your-sandbox-client-key
MIDTRANS_MERCHANT_ID=your-merchant-id
MIDTRANS_IS_PRODUCTION=false
```

**PENTING**: Salin konfigurasi dari `.env.example` ke file `.env` Anda.

### 2. Database Migration
Migration sudah dijalankan dan membuat tabel:
- `payments` - Menyimpan data pembayaran
- `invoices` - Menyimpan data invoice
- `eventregistrations.payment_id` - Foreign key ke tabel payments

### 3. Dependencies
SDK Midtrans sudah terinstall:
```bash
npm install midtrans-client
```

## API Endpoints

### Payment Endpoints
- `POST /api/payment/events/:eventId/payment` - Buat pembayaran untuk event berbayar
- `POST /api/payment/events/:eventId/register-free` - Registrasi event gratis
- `GET /api/payment/status/:orderId` - Cek status pembayaran
- `GET /api/payment/my-payments` - Riwayat pembayaran user

### Invoice Endpoints
- `GET /api/payment/invoices` - Daftar invoice user
- `GET /api/payment/invoices/:invoiceId` - Detail invoice
- `GET /api/payment/invoices/:invoiceId/download` - Download PDF invoice

### Webhook Endpoint
- `POST /webhook/midtrans` - Webhook untuk notifikasi Midtrans

### Organizer Endpoints
- `GET /api/organizer/payments/summary` - Summary pembayaran untuk organizer

## Flow Pembayaran

### Event Gratis
1. User klik "Daftar" di halaman event
2. Sistem cek harga event (0 atau null)
3. Langsung buat registrasi dan invoice
4. Redirect ke halaman invoice

### Event Berbayar
1. User klik "Daftar" di halaman event
2. Sistem cek harga event (> 0)
3. Buat payment record di database
4. Generate Midtrans Snap token
5. Tampilkan popup pembayaran Midtrans
6. User melakukan pembayaran
7. Midtrans kirim notifikasi ke webhook
8. Sistem update status pembayaran
9. Jika berhasil, buat registrasi dan invoice
10. Redirect ke halaman success

## Frontend Integration

### Midtrans Snap Script
Script Midtrans sudah ditambahkan ke `index.html`:
```html
<script type="text/javascript" 
        src="https://app.sandbox.midtrans.com/snap/snap.js" 
        data-client-key="YOUR_CLIENT_KEY_HERE">
</script>
```

### Payment Pages
- `/payment/success` - Halaman sukses pembayaran
- `/payment/pending` - Halaman pending pembayaran
- `/payment/error` - Halaman error pembayaran
- `/invoice/:invoiceNumber` - Halaman detail invoice

## Database Schema

### Tabel Payments
```sql
CREATE TABLE payments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  event_id INT NOT NULL,
  order_id VARCHAR(255) UNIQUE NOT NULL,
  transaction_id VARCHAR(255),
  amount DECIMAL(15,2) NOT NULL,
  payment_method VARCHAR(255),
  payment_status ENUM('pending','paid','failed','cancelled','expired') DEFAULT 'pending',
  midtrans_response TEXT,
  snap_token TEXT,
  paid_at DATETIME,
  expired_at DATETIME,
  createdAt DATETIME NOT NULL,
  updatedAt DATETIME NOT NULL
);
```

### Tabel Invoices
```sql
CREATE TABLE invoices (
  id INT PRIMARY KEY AUTO_INCREMENT,
  invoice_number VARCHAR(255) UNIQUE NOT NULL,
  user_id INT NOT NULL,
  event_id INT NOT NULL,
  payment_id INT NULL,
  registration_id INT NOT NULL,
  invoice_type ENUM('free','paid') NOT NULL,
  amount DECIMAL(15,2) DEFAULT 0.00,
  tax_amount DECIMAL(15,2) DEFAULT 0.00,
  total_amount DECIMAL(15,2) DEFAULT 0.00,
  invoice_status ENUM('draft','issued','paid','cancelled') DEFAULT 'issued',
  issued_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  due_date DATETIME,
  paid_date DATETIME,
  notes TEXT,
  createdAt DATETIME NOT NULL,
  updatedAt DATETIME NOT NULL
);
```

## Testing

### Test Credentials (Sandbox)
- **Server Key**: Lihat di file `.env` (jangan commit!)
- **Client Key**: Lihat di file `.env` (jangan commit!)
- **Merchant ID**: Lihat di file `.env` (jangan commit!)

**Note**: Dapatkan credentials dari [Midtrans Dashboard](https://dashboard.midtrans.com/) dan simpan di `.env`

### Test Cards (Sandbox)
- **Visa**: 4811 1111 1111 1114
- **Mastercard**: 5573 3811 1111 1115
- **CVV**: 123
- **Expiry**: 12/25

### Test Flow
1. Buat event berbayar dengan harga > 0
2. Login sebagai user
3. Daftar ke event tersebut
4. Lakukan pembayaran dengan test card
5. Verifikasi status pembayaran
6. Cek invoice yang terbuat

## Troubleshooting

### Common Issues
1. **Foreign Key Error**: Pastikan migration dijalankan dengan urutan yang benar
2. **Midtrans Error**: Cek konfigurasi API key di .env
3. **CORS Error**: Pastikan frontend URL sudah dikonfigurasi dengan benar

### Logs
- Payment logs tersimpan di console backend
- Midtrans response tersimpan di field `midtrans_response`
- Error handling sudah diimplementasi di semua endpoint

## Security Notes
- Semua endpoint payment memerlukan authentication
- Webhook endpoint tidak memerlukan auth (sesuai standar Midtrans)
- Sensitive data seperti API key disimpan di environment variables
- Payment validation dilakukan di server side

## Production Deployment
Untuk production, ubah konfigurasi berikut:
1. Set `MIDTRANS_IS_PRODUCTION=true`
2. Ganti dengan production API keys dari Midtrans
3. Update Snap script URL ke production
4. Konfigurasi webhook URL di Midtrans dashboard
