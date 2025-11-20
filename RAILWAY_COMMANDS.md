# ⚡ Railway Quick Commands Reference

Copy-paste commands untuk Railway deployment.

---

## 📦 Installation

### Install Railway CLI
```bash
npm install -g @railway/cli

# Verify
railway --version
```

### Login
```bash
railway login
```

---

## 🗄️ Database Commands

### Export Local Database
```bash
# Windows (PowerShell)
mysqldump -u root event_db > backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql

# Linux/Mac
mysqldump -u root event_db > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Connect to Railway MySQL
```bash
# Login first
railway login

# Link to project
railway link

# Get connection string
railway variables

# Connect via MySQL CLI
mysql -h [HOST] -P [PORT] -u [USER] -p[PASSWORD] [DATABASE]
```

### Import to Railway MySQL
```bash
# Method 1: Direct import
mysql -h [HOST] -P [PORT] -u [USER] -p[PASSWORD] [DATABASE] < backup.sql

# Method 2: Via Railway CLI (jika tersedia)
railway run mysql -u [USER] -p[PASSWORD] [DATABASE] < backup.sql
```

---

## 🚀 Deployment Commands

### Initial Setup
```bash
# Backend
cd backend
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/your-backend-repo.git
git push -u origin main

# Frontend
cd ../frontend
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/your-frontend-repo.git
git push -u origin main
```

### Update Deployment
```bash
# After making changes
git add .
git commit -m "Update: your changes"
git push

# Railway will auto-deploy
```

### Manual Redeploy (Railway Dashboard)
```bash
# Via CLI
railway up

# Or use Railway dashboard
# Project → Service → Deployments → "Redeploy"
```

---

## 🔧 Environment Variables

### Set via CLI
```bash
# Link to project first
railway link [PROJECT_ID]

# Set variable
railway variables set DB_HOST=your-mysql-host
railway variables set NODE_ENV=production

# Set multiple
railway variables set \
  DB_HOST=your-host \
  DB_USER=root \
  DB_PASSWORD=your-password \
  NODE_ENV=production
```

### Get all variables
```bash
railway variables
```

### Delete variable
```bash
railway variables delete VARIABLE_NAME
```

---

## 📊 Logs & Monitoring

### View Logs
```bash
# Real-time logs
railway logs

# Follow logs (like tail -f)
railway logs -f

# Last 100 lines
railway logs --tail 100
```

### Service Status
```bash
# Check service health
railway status

# List all deployments
railway deployments
```

---

## 🔍 Database Queries

### Check Tables
```sql
-- Connect first via mysql command
SHOW TABLES;
```

### Check Data
```sql
-- Count users
SELECT COUNT(*) FROM users;

-- Count events
SELECT COUNT(*) FROM events;

-- Check recent registrations
SELECT * FROM eventregistrations ORDER BY createdAt DESC LIMIT 10;
```

### Fix Common Issues
```sql
-- Reset auto-increment
ALTER TABLE users AUTO_INCREMENT = 1;

-- Check foreign keys
SELECT * FROM information_schema.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = 'your_database_name';
```

---

## 🛠️ Troubleshooting Commands

### Backend Not Starting
```bash
# Check logs
railway logs --tail 200

# Restart service
railway restart

# Check environment variables
railway variables | grep -i node_env
railway variables | grep -i db_
```

### Database Connection Issues
```bash
# Test connection from local
mysql -h [HOST] -P [PORT] -u [USER] -p

# Check Railway MySQL service status
railway status

# Get MySQL connection details
railway variables | grep -i mysql
```

### CORS Issues
```bash
# Check frontend URL in backend
railway variables | grep FRONTEND_URL

# Update if wrong
railway variables set FRONTEND_URL=https://your-correct-frontend.up.railway.app

# Restart backend
railway restart
```

---

## 💾 Backup Commands

### Create Backup
```bash
# Export Railway database
mysqldump -h [HOST] -P [PORT] -u [USER] -p[PASSWORD] [DATABASE] > railway_backup_$(date +%Y%m%d).sql

# Compress backup
gzip railway_backup_$(date +%Y%m%d).sql
```

### Restore Backup
```bash
# Decompress if needed
gunzip backup.sql.gz

# Import
mysql -h [HOST] -P [PORT] -u [USER] -p[PASSWORD] [DATABASE] < backup.sql
```

### Automated Backup Script
```bash
#!/bin/bash
# save as: railway_backup.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./backups"

# Create backup directory
mkdir -p $BACKUP_DIR

# Get Railway credentials (set these as environment variables)
mysqldump -h $RAILWAY_HOST -P $RAILWAY_PORT \
  -u $RAILWAY_USER -p$RAILWAY_PASSWORD \
  $RAILWAY_DATABASE > $BACKUP_DIR/backup_$DATE.sql

# Compress
gzip $BACKUP_DIR/backup_$DATE.sql

# Keep only last 7 days
find $BACKUP_DIR -name "backup_*.sql.gz" -mtime +7 -delete

echo "Backup completed: backup_$DATE.sql.gz"
```

---

## 🔄 Migration Commands

### Run Migrations
```bash
# If using Sequelize
cd backend
railway run npm run migrate

# Rollback last migration
railway run npm run migrate:undo
```

### Create New Migration
```bash
# Local development
npx sequelize-cli migration:generate --name migration-name

# Edit migration file
# Then push and run on Railway
```

---

## 📱 Mobile Testing

### Expose Local Backend to Mobile
```bash
# Using ngrok (for local testing before Railway)
ngrok http 3000

# Update frontend VITE_API_URL to ngrok URL
```

---

## 🎯 One-Click Deploy (Future)

### Save Railway Configuration
```bash
# In project root, create railway.toml
railway init

# Add to git
git add railway.toml
git commit -m "Add Railway config"
```

---

## 🚨 Emergency Commands

### Rollback to Previous Deployment
```bash
# List deployments
railway deployments

# Rollback
railway rollback [DEPLOYMENT_ID]
```

### Stop Service
```bash
railway down
```

### Restart Service
```bash
railway restart
```

### Clear Cache (if needed)
```bash
# Railway doesn't have explicit cache clear
# But you can force rebuild by making a small change
echo "" >> README.md
git add .
git commit -m "Force rebuild"
git push
```

---

## 📋 Useful Checks

### Before Deploying
```bash
# Check for .env files
find . -name ".env" -not -path "./node_modules/*"

# Check for secrets in code
git secrets --scan

# Test build locally
npm run build
```

### After Deploying
```bash
# Test endpoints
curl https://your-backend.up.railway.app/

# Test API
curl https://your-backend.up.railway.app/api/events

# Check SSL certificate
curl -vI https://your-backend.up.railway.app/
```

---

## 🆘 Get Help

```bash
# Railway CLI help
railway help

# Specific command help
railway logs --help
railway variables --help
```

---

## 📞 Support Resources

- **Railway Docs**: https://docs.railway.app/
- **Railway Discord**: https://discord.gg/railway
- **Railway Status**: https://status.railway.app/

---

**Tip:** Bookmark this page untuk quick reference! 🔖
