# 🚀 Railway Deployment Guide

Panduan lengkap deploy aplikasi Event Management ke Railway dengan MySQL database.

## � Monorepo Structure

Aplikasi ini menggunakan **monorepo** (1 repository untuk backend & frontend):

```
event-management/
├── backend/          ← Node.js/Express API
│   ├── package.json
│   ├── bin/www
│   └── ...
├── frontend/         ← React/Vite App
│   ├── package.json
│   ├── index.html
│   └── ...
└── .gitignore
```

**Deployment Strategy:**
- 1 GitHub repository
- 2 Railway services (dari repo yang sama)
- Setiap service punya **Root Directory** berbeda

**Railway Project Structure:**
```
Railway Project "Event Management"
│
├── MySQL Service          (Database)
├── Backend Service        (Root: /backend)
└── Frontend Service       (Root: /frontend)
```

**Key Point untuk Monorepo:**
⚠️ **Saat deploy, Railway akan deploy dari repo yang sama 2x. Bedanya hanya di `Root Directory` setting!**

---

## �� Prerequisites

- Akun Railway (gratis): https://railway.app/
- Akun GitHub (untuk push code)
- Git installed di komputer Anda
- MySQL local untuk backup database

---

## 🔧 Langkah 1: Persiapan Database MySQL di Railway

### 1.1 Buat Project Baru di Railway
1. Login ke https://railway.app/
2. Klik **"New Project"**
3. Pilih **"Deploy MySQL"**
4. Railway akan otomatis membuat MySQL database

### 1.2 Copy Database Credentials
Setelah MySQL terbuat, klik database tersebut dan copy credentials:
- `MYSQLHOST` → DB_HOST
- `MYSQLUSER` → DB_USER  
- `MYSQLPASSWORD` → DB_PASSWORD
- `MYSQLDATABASE` → DB_NAME
- `MYSQLPORT` → DB_PORT

**Atau gunakan MySQL URL langsung:**
Railway menyediakan `DATABASE_URL` dalam format:
```
mysql://user:password@host:port/database
```

---

## 🎯 Langkah 2: Push Code ke GitHub (Monorepo)

### 2.1 Push Code ke GitHub
**Karena frontend dan backend dalam 1 repository:**

```bash
# Di root project (ujikom_event)
git init
git add .
git commit -m "Initial commit - Event Management System"
git branch -M main
git remote add origin https://github.com/username/event-management.git
git push -u origin main
```

**Struktur repository:**
```
event-management/
├── backend/
│   ├── package.json
│   ├── bin/www
│   └── ...
├── frontend/
│   ├── package.json
│   ├── index.html
│   └── ...
├── .gitignore
└── README.md
```

---

## 🎯 Langkah 3: Deploy Backend ke Railway

### 3.1 Deploy dari Railway
1. Kembali ke Railway dashboard
2. Klik **"New"** → **"GitHub Repo"**
3. Pilih repository **event-management** Anda
4. Railway akan detect Node.js

### 3.2 Configure Settings - Backend
**PENTING untuk Monorepo!**

1. Di **"Settings"** tab:
   - **Service Name**: Ganti jadi "Backend" atau "API"
   - **Root Directory**: `backend` ⚠️ **WAJIB diisi!**
   - **Start Command**: `npm start`
   - **Build Command**: Leave empty (Railway auto-detect)

2. Klik **"Save Config"**

### 3.3 Set Environment Variables
Klik tab **"Variables"**, tambahkan:

```env
# Database (Copy dari MySQL service Railway)
DB_HOST=containers-us-west-xxx.railway.app
DB_USER=root
DB_PASSWORD=xxxxx
DB_NAME=railway
DB_PORT=xxxx

# JWT & Session (Copy dari .env lokal)
JWT_SECRET=8f2a9b7c6d5e4f3a2b1c9d8e7f6a5b4c3d2e1f9a8b7c6d5e4f3a2b1c9d8e7f6a5b4c3d2e1f
SESSION_SECRET=x9m4n7b2v8c5z1a6s3d9f4g7h2j5k8l1p6q3r9t2u5w8x1y4z7a3b6c9d2e5f8g1h4i7j2k5l8m

# Email
EMAIL_USER=razz15890@gmail.com
EMAIL_PASS=efzu cnzb mcab glum

# Frontend URL (akan diupdate setelah frontend deploy)
FRONTEND_URL=https://your-frontend-domain.up.railway.app

# Server
PORT=3000

# App URL (gunakan Railway domain yang digenerate)
APP_URL=https://your-backend-domain.up.railway.app

# Node Environment
NODE_ENV=production

# Xendit (gunakan sandbox keys untuk demo/development)
XENDIT_SECRET_KEY=xnd_development_xEgN9T7ffWwX1g3fWyfvx3T3OnFMTgirrQ4OwtGogg85Z2c1L6JPohc3T6I5OC
XENDIT_PUBLIC_KEY=xnd_public_development_q6gZKtyT3hRraRSPK0WfbSiTdK61or0KwhjppuRVYdJo98ttf1KGCzKc0k4BrHlR
XENDIT_WEBHOOK_TOKEN=your_webhook_token
```

### 3.4 Deploy Backend
Railway akan otomatis start build. Tunggu sampai status **"Success"**.

### 3.5 Copy Backend URL
Setelah deploy berhasil, copy URL backend:
- Klik service → **"Settings"** → bagian **"Domains"**
- Copy URL (misal: `https://backend-production-xxxx.up.railway.app`)

---

## 🎨 Langkah 4: Deploy Frontend ke Railway

### 4.1 Create New Service dari Same Repo
**Karena menggunakan monorepo, kita deploy dari repo yang sama:**

1. Di Railway dashboard (project yang sama dengan backend)
2. Klik **"New"** → **"GitHub Repo"**
3. Pilih repository **event-management** yang sama
4. Railway akan create service baru

### 4.2 Configure Settings - Frontend
**PENTING untuk Monorepo!**

1. Di **"Settings"** tab:
   - **Service Name**: Ganti jadi "Frontend" atau "Web"
   - **Root Directory**: `frontend` ⚠️ **WAJIB diisi!**
   - **Build Command**: `npm run build`
   - **Start Command**: Leave empty (Railway auto-detect Vite)

2. Klik **"Save Config"**

### 4.3 Set Environment Variables
Klik tab **"Variables"**:

```env
# API URL (gunakan backend Railway URL yang sudah di-copy sebelumnya)
VITE_API_URL=https://backend-production-xxxx.up.railway.app/api
```

⚠️ **Ganti URL dengan URL backend Railway yang sebenarnya!**

### 4.4 Deploy Frontend
Railway akan otomatis start build. Tunggu sampai status **"Success"**.

### 4.5 Copy Frontend URL
Setelah deploy berhasil:
- Klik service → **"Settings"** → bagian **"Domains"**
- Copy URL (misal: `https://frontend-production-xxxx.up.railway.app`)

---

## 🔄 Langkah 5: Update Environment Variables

### 5.1 Update Backend Environment
Kembali ke backend service di Railway → **"Variables"**, update:
```env
FRONTEND_URL=https://frontend-production-xxxx.up.railway.app
```
⚠️ **Ganti dengan URL frontend Railway yang sebenarnya!**

### 5.2 Update Backend APP_URL (Jika Perlu)
Pastikan `APP_URL` di backend juga benar:
```env
APP_URL=https://backend-production-xxxx.up.railway.app
```

### 5.3 Restart Services
Klik **"Restart"** pada kedua services (backend dan frontend)

---

## 🗄️ Langkah 6: Setup Database Schema

### 6.1 Connect ke Railway MySQL
Gunakan MySQL client atau Railway CLI:

```bash
# Install Railway CLI (jika belum)
npm install -g @railway/cli

# Login
railway login

# Link ke project
railway link
```

### 6.2 Export Database Lokal
```bash
# Di Windows PowerShell
mysqldump -u root event_db > backup.sql

# Atau dengan password
mysqldump -u root -p event_db > backup.sql
```

### 6.3 Import ke Railway MySQL
**Method 1: Menggunakan MySQL Client**
```bash
# Gunakan credentials dari Railway MySQL Variables
mysql -h [DB_HOST] -P [DB_PORT] -u [DB_USER] -p[DB_PASSWORD] [DB_NAME] < backup.sql
```

**Method 2: Menggunakan MySQL Workbench**
1. Buat koneksi baru dengan Railway MySQL credentials
2. Import file `backup.sql`

### 6.4 Verify Database
```bash
# Connect ke Railway MySQL
mysql -h [DB_HOST] -P [DB_PORT] -u [DB_USER] -p

# Check tables
SHOW TABLES;

# Check data
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM events;
```

---

## ✅ Langkah 7: Testing

### 7.1 Test Backend API
Buka di browser: `https://backend-production-xxxx.up.railway.app/`

**Expected response:** Express welcome page atau JSON response

### 7.2 Test Frontend
Buka di browser: `https://frontend-production-xxxx.up.railway.app/`

**Expected:** Homepage event management muncul

### 7.3 Test API Connection
1. Di frontend, buka browser console (F12)
2. Coba login/register
3. Check console untuk errors
4. Check Network tab untuk API calls
5. Jika ada error, check Railway logs di dashboard

### 7.4 Test Complete Flow (Demo)
1. **Register** akun baru
2. **Verify email** (check email)
3. **Login** dengan akun verified
4. **Browse events**
5. **Register event berbayar**
6. **Payment** dengan Xendit sandbox
7. **Complete payment** (klik button sandbox)
8. **Check registration** & download invoice

---

## 🛠️ Troubleshooting

### Error: Database Connection Failed
**Solusi:**
- Pastikan DB credentials benar
- Check Railway MySQL service status
- Verify DB_HOST includes port (e.g., `host:6058`)

### Error: CORS Policy
**Solusi:**
- Update `FRONTEND_URL` di backend environment variables
- Restart backend service
- Clear browser cache

### Error: 502 Bad Gateway
**Solusi:**
- Check backend logs di Railway
- Verify `PORT` environment variable = 3000
- Check start command di Settings

### Error: Static Files Not Loading
**Solusi:**
- Verify build output directory
- Check Vite config `base` path
- Ensure uploads folder is persistent

---

## 📊 Monitoring

### Logs
- Klik service → **"Logs"** tab untuk real-time logs
- Monitor errors dan requests

### Metrics
- Railway dashboard menampilkan CPU, Memory usage
- Set up alerts untuk downtime

---

## 💰 Pricing

**Railway Free Tier:**
- $5 free credit per month
- Cukup untuk development/testing
- Upgrade ke Hobby ($5/month) untuk production

**Tips Hemat:**
- Gunakan 1 project untuk backend + frontend + database
- Monitor usage di dashboard
- Pause services saat tidak digunakan (development)

---

## 🔒 Security Checklist

- [ ] JWT_SECRET dan SESSION_SECRET menggunakan random string yang kuat
- [ ] NODE_ENV = production
- [ ] Database credentials aman (tidak di commit ke Git)
- [ ] CORS hanya allow frontend domain
- [ ] Email credentials aman
- [ ] Xendit sandbox keys untuk demo (atau production keys untuk real transactions)

---

## 💳 Xendit Payment untuk Demo

### Menggunakan Sandbox Mode

**Untuk demo/ujian, gunakan Xendit sandbox keys:**

✅ **Sudah benar di environment variables:**
```env
XENDIT_SECRET_KEY=xnd_development_xxx
XENDIT_PUBLIC_KEY=xnd_public_development_xxx
```

### Demo Flow dengan Sandbox:

1. User checkout event berbayar ✅
2. Redirect ke Xendit sandbox payment page ✅
3. "Bayar" dengan dummy payment methods (no real money) ✅
4. Redirect ke success page ✅
5. **Klik button "Complete Payment (Sandbox)"** untuk finalisasi ✅
6. Registration created & invoice generated ✅

### Kenapa Perlu Button "Complete Payment"?

Di sandbox mode, Xendit webhook **tidak otomatis jalan**. Button ini untuk simulate payment completion secara manual. Sudah ada di `PaymentSuccess.jsx`.

**Saat presentasi/demo, jelaskan:**
> "Ini menggunakan Xendit sandbox mode untuk demo yang aman. Di production nanti, webhook akan otomatis update payment status tanpa perlu button ini."

---

## 📝 Post-Deployment

### Update Xendit Settings
Jika menggunakan webhook untuk payment:
1. Login ke Xendit Dashboard
2. Settings → Webhooks
3. Set webhook URL: `https://your-backend-domain.up.railway.app/api/webhook/xendit`

### Custom Domain (Optional)
1. Di Railway Settings → **Domains**
2. Klik **"Add Domain"**
3. Input custom domain Anda
4. Update DNS records sesuai instruksi Railway

---

## 🎉 Selesai!

Aplikasi Anda sekarang sudah live di:
- **Backend API**: `https://your-backend.up.railway.app`
- **Frontend**: `https://your-frontend.up.railway.app`
- **Database**: Railway MySQL (managed)

### Next Steps:
- Test semua fitur secara menyeluruh
- Setup monitoring/alerts
- Backup database secara berkala
- Update Xendit ke production mode untuk real payments

---

## 📊 Quick Reference - Monorepo Deployment

### Railway Services Configuration

| Service | Root Directory | Build Command | Start Command | Environment Variables |
|---------|---------------|---------------|---------------|----------------------|
| **MySQL** | - | - | - | Auto-generated |
| **Backend** | `backend` | Auto | `npm start` | DB_*, JWT_*, EMAIL_*, APP_URL, FRONTEND_URL, XENDIT_* |
| **Frontend** | `frontend` | `npm run build` | Auto | VITE_API_URL |

### Environment Variables Summary

**Backend (Production):**
```env
DB_HOST=railway-mysql-host
DB_USER=root
DB_PASSWORD=xxx
DB_NAME=railway
DB_PORT=xxx
JWT_SECRET=xxx
SESSION_SECRET=xxx
EMAIL_USER=xxx
EMAIL_PASS=xxx
FRONTEND_URL=https://frontend-xxx.up.railway.app
APP_URL=https://backend-xxx.up.railway.app
PORT=3000
NODE_ENV=production
XENDIT_SECRET_KEY=xnd_development_xxx  # Sandbox untuk demo
XENDIT_PUBLIC_KEY=xnd_public_development_xxx
```

**Frontend (Production):**
```env
VITE_API_URL=https://backend-xxx.up.railway.app/api
```

### Deployment Checklist

1. ✅ Push ke GitHub (1x, root folder)
2. ✅ Deploy MySQL di Railway
3. ✅ Deploy Backend (set Root Directory: `backend`)
4. ✅ Deploy Frontend (set Root Directory: `frontend`)
5. ✅ Update FRONTEND_URL di backend
6. ✅ Import database
7. ✅ Test semua fitur

---

## 📞 Support

Jika ada masalah:
1. Check Railway documentation: https://docs.railway.app/
2. Railway Discord: https://discord.gg/railway
3. Check application logs di Railway dashboard

---

**Good luck dengan deployment! 🚀**
