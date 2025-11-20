# ✅ Railway Deployment Checklist

Gunakan checklist ini sebelum dan saat deploy ke Railway.

## 📋 Pre-Deployment

### Backend
- [ ] File `.env` sudah benar (JANGAN di-commit!)
- [ ] File `.env.example` sudah update
- [ ] `railway.json` sudah ada
- [ ] `package.json` scripts sudah benar
- [ ] Database migrations ready
- [ ] Hardcoded URLs sudah diganti dengan environment variables
- [ ] CORS configuration sudah support production domain
- [ ] Session configuration sudah set untuk HTTPS

### Frontend
- [ ] File `.env` sudah ada dengan `VITE_API_URL`
- [ ] API base URL menggunakan environment variable
- [ ] Build command works: `npm run build`
- [ ] Preview works: `npm run preview`

### Database
- [ ] Export database lokal: `mysqldump -u root event_db > backup.sql`
- [ ] Backup file disimpan aman
- [ ] SQL migrations/seeds siap

---

## 🚀 Deployment Steps

### 1. Setup Railway MySQL
- [ ] Create new project di Railway
- [ ] Deploy MySQL service
- [ ] Copy database credentials (host, user, password, database, port)
- [ ] Test connection dari lokal (optional)

### 2. Deploy Backend
- [ ] Push code ke GitHub (pastikan .env TIDAK ikut)
- [ ] Connect repository ke Railway
- [ ] Set semua environment variables:
  - [ ] DB_HOST
  - [ ] DB_USER
  - [ ] DB_PASSWORD
  - [ ] DB_NAME
  - [ ] DB_PORT
  - [ ] JWT_SECRET
  - [ ] SESSION_SECRET
  - [ ] EMAIL_USER
  - [ ] EMAIL_PASS
  - [ ] NODE_ENV=production
  - [ ] PORT=3000
  - [ ] APP_URL (Railway URL backend)
  - [ ] FRONTEND_URL (Railway URL frontend - update nanti)
  - [ ] XENDIT_SECRET_KEY
  - [ ] XENDIT_PUBLIC_KEY
- [ ] Verify build berhasil
- [ ] Copy backend Railway URL

### 3. Deploy Frontend
- [ ] Push code ke GitHub
- [ ] Connect repository ke Railway  
- [ ] Set environment variable:
  - [ ] VITE_API_URL (Railway URL backend + /api)
- [ ] Verify build berhasil
- [ ] Copy frontend Railway URL

### 4. Update Cross-References
- [ ] Update backend `FRONTEND_URL` dengan frontend Railway URL
- [ ] Restart backend service
- [ ] Restart frontend service (jika perlu)

### 5. Database Setup
- [ ] Import database ke Railway MySQL
- [ ] Run migrations (jika ada)
- [ ] Verify tables created
- [ ] Check data integrity

---

## ✅ Post-Deployment Testing

### Backend API
- [ ] Base URL accessible: `https://backend-url.up.railway.app/`
- [ ] API endpoint works: `/api/events`
- [ ] Authentication works: `/api/auth/login`
- [ ] File uploads work
- [ ] Email sending works

### Frontend
- [ ] Homepage loads
- [ ] Login/Register works
- [ ] Event list displays
- [ ] Event detail page works
- [ ] Registration flow works
- [ ] Payment flow works (sandbox)
- [ ] Certificate generation works
- [ ] Profile page works
- [ ] Admin dashboard accessible

### Database
- [ ] Connections stable
- [ ] Queries executing
- [ ] Data persists after restart
- [ ] No connection errors in logs

### Integration
- [ ] Frontend dapat connect ke backend API
- [ ] CORS tidak ada error
- [ ] Authentication/Session works
- [ ] File uploads persist
- [ ] Email notifications terkirim

---

## 🐛 Troubleshooting Checks

### If Backend Fails to Start
- [ ] Check Railway logs
- [ ] Verify all env variables set
- [ ] Check start command: `npm start`
- [ ] Verify `bin/www` file exists
- [ ] Check database connection

### If Frontend Shows Blank
- [ ] Check build output di Railway logs
- [ ] Verify `VITE_API_URL` correct
- [ ] Check browser console untuk errors
- [ ] Verify build command: `npm run build`

### If API Calls Fail (CORS)
- [ ] Check `FRONTEND_URL` di backend env
- [ ] Verify frontend URL exact match (dengan/tanpa trailing slash)
- [ ] Check CORS configuration di `app.js`
- [ ] Restart backend after changing env vars

### If Database Connection Fails
- [ ] Verify all DB_* variables correct
- [ ] Check Railway MySQL service running
- [ ] Test connection manually
- [ ] Check firewall/network settings

---

## 📊 Monitoring Setup

### Railway Dashboard
- [ ] Enable deploy notifications
- [ ] Monitor usage metrics
- [ ] Set up alerts untuk errors
- [ ] Check logs regularly

### Application Monitoring
- [ ] Test all critical paths
- [ ] Monitor error rates
- [ ] Check response times
- [ ] Verify uptime

---

## 🔒 Security Checklist

### Credentials
- [ ] `.env` TIDAK di-commit ke Git
- [ ] JWT_SECRET strong & random
- [ ] SESSION_SECRET strong & random
- [ ] Database password strong
- [ ] Email password aman (use app password)

### Configuration
- [ ] NODE_ENV=production
- [ ] CORS hanya allow specific domain
- [ ] Session cookies secure=true
- [ ] HTTPS enforced
- [ ] Rate limiting enabled (jika ada)

### Xendit Payment
- [ ] Sandbox mode untuk testing
- [ ] Production keys untuk real payments
- [ ] Webhook URL configured
- [ ] Test payment flow end-to-end

---

## 💾 Backup Strategy

### Before Deployment
- [ ] Backup local database
- [ ] Backup uploaded files
- [ ] Save current .env file
- [ ] Document current working URLs

### Regular Backups
- [ ] Setup automated Railway MySQL backups
- [ ] Export database weekly
- [ ] Backup uploads folder
- [ ] Keep .env.example updated

---

## 📝 Documentation Updates

- [ ] Update README.md dengan production URLs
- [ ] Document deployment process
- [ ] Update API documentation
- [ ] Create runbook untuk common issues

---

## 🎉 Launch Ready!

Jika semua checklist ✅, aplikasi siap untuk production!

### Final Steps:
1. Announce ke users
2. Monitor closely untuk 24-48 jam pertama
3. Prepare untuk scaling jika perlu
4. Setup customer support channel

---

**Catatan:** Simpan checklist ini dan review setiap kali deploy update!
