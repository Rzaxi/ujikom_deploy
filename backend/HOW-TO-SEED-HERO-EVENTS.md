# How to Seed 5 Hero Events

## 📋 Overview
Script untuk membuat 5 event berbeda yang akan ditampilkan di Hero section homepage.

**Created by**: `sari.pro@gmail.com`

## 🎯 5 Events yang Dibuat:

1. **Web Development Bootcamp** - Full Stack JavaScript (7 hari)
2. **UI/UX Design Workshop** - Figma & Design Thinking (3 hari)
3. **Digital Marketing Webinar** - Strategy 2025 (FREE, online)
4. **Indonesia Tech Summit** - Conference (2 hari)
5. **Python Programming Bootcamp** - Data Science & AI (5 hari)

## 🚀 Cara Menggunakan

### Option 1: Menggunakan Placeholder Images (Recommended untuk testing)

**File**: `seed-hero-events-with-placeholders.sql`

Langkah:
```bash
# 1. Masuk ke backend directory
cd backend

# 2. Login ke MySQL
mysql -u root -p

# 3. Pilih database
USE event_management;

# 4. Run script
SOURCE seed-hero-events-with-placeholders.sql;

# 5. Verify
SELECT judul, kategori, flyer_url FROM Events ORDER BY createdAt DESC LIMIT 5;
```

**Keuntungan**:
- ✅ Langsung bisa dipakai
- ✅ Tidak perlu upload flyer
- ✅ Menggunakan Unsplash images (high quality)

### Option 2: Menggunakan Local Flyer Images

**File**: `seed-hero-events.sql`

Langkah:
```bash
# 1. Upload flyer images ke folder
backend/uploads/flyers/

# 2. Flyer images yang dibutuhkan:
- bootcamp-web-development.jpg
- workshop-uiux-design.jpg
- webinar-digital-marketing.jpg
- conference-tech-summit.jpg
- bootcamp-python-datascience.jpg

# 3. Run SQL script seperti Option 1
```

## 📊 Event Details

| Event | Kategori | Durasi | Harga | Lokasi |
|-------|----------|--------|-------|--------|
| Web Development Bootcamp | bootcamp | 7 hari | Rp 3.500.000 | Jakarta |
| UI/UX Design Workshop | pelatihan | 3 hari | Rp 2.500.000 | Jakarta |
| Digital Marketing Webinar | webinar | 1 hari | GRATIS | Online |
| Tech Summit | kompetisi | 2 hari | Rp 1.500.000 | JCC Jakarta |
| Python Bootcamp | bootcamp | 5 hari | Rp 4.000.000 | Bali |

## 🎨 Hero Section Result

Setelah data di-insert, Hero section akan menampilkan:
- ✅ 5 cards berbeda dengan flyer berbeda
- ✅ Auto-rotate carousel
- ✅ Background dynamic sesuai event
- ✅ Kategori dan harga berbeda-beda

## 🔍 Verify Data

```sql
-- Check if events created successfully
SELECT 
  id,
  judul,
  kategori,
  tanggal,
  lokasi,
  FORMAT(biaya, 0) as harga,
  created_by,
  flyer_url
FROM Events 
WHERE created_by = (SELECT id FROM Users WHERE email = 'sari.pro@gmail.com')
ORDER BY createdAt DESC
LIMIT 5;
```

## 🛠️ Troubleshooting

### Error: User not found
```sql
-- Check if user exists
SELECT id, nama, email FROM Users WHERE email = 'sari.pro@gmail.com';

-- If not exist, create user first or change email in script
```

### Error: Foreign key constraint
```sql
-- Make sure user exists and is an organizer
UPDATE Users SET role = 'organizer' WHERE email = 'sari.pro@gmail.com';
```

### Flyer images not showing
- **Placeholder images**: Check internet connection
- **Local images**: Check file path and permissions
- **URL format**: Make sure starts with `http://` or `https://`

## 📱 Frontend Check

After seeding, check frontend:
```bash
# 1. Refresh homepage
http://localhost:3001

# 2. Hero section should show 5 different events
# 3. Cards should have different images
# 4. Auto-rotate should work

# 3. Check browser console for errors
F12 → Console
```

## 🎉 Done!

Hero section sekarang menampilkan 5 event berbeda dengan:
- ✅ Flyer images berbeda
- ✅ Judul dan kategori berbeda
- ✅ Harga dan lokasi berbeda
- ✅ Deskripsi lengkap
- ✅ Professional look

**Happy coding!** 🚀
