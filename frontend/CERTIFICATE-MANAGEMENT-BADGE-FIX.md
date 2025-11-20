# 🏷️ Certificate Management Badge Fix

## 🔧 Problem
Badge status di halaman "Manajemen Sertifikat" tidak sesuai dengan tanggal event. Badge hanya menampilkan progress sertifikat (Selesai/Berlangsung/Belum Mulai) bukan status event berdasarkan tanggal.

## ✅ Solution
Menambahkan badge status event berdasarkan tanggal yang sama seperti di bagian peserta:

### **Badge Status Berdasarkan Tanggal:**

#### **🔵 Akan Datang** 
- **Kondisi**: Tanggal hari ini < tanggal mulai event
- **Style**: `bg-blue-100 text-blue-700`

#### **🟢 Berlangsung**
- **Kondisi**: Tanggal hari ini berada di antara tanggal mulai dan selesai event
- **Style**: `bg-green-100 text-green-700`

#### **⚫ Selesai**
- **Kondisi**: Tanggal hari ini > tanggal selesai event
- **Style**: `bg-gray-100 text-gray-700`

## 📁 Files Modified

### `frontend/src/pages/organizer/CertificateManagement.jsx`

#### ✅ **Added Function:**
```javascript
const getEventStatus = (event) => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  const eventStart = new Date(event.tanggal);
  eventStart.setHours(0, 0, 0, 0);
  
  const eventEnd = new Date(event.tanggal_selesai || event.tanggal);
  eventEnd.setHours(23, 59, 59, 999);
  
  if (today < eventStart) {
    return {
      status: 'Akan Datang',
      className: 'bg-blue-100 text-blue-700'
    };
  } else if (today > eventEnd) {
    return {
      status: 'Selesai',
      className: 'bg-gray-100 text-gray-700'
    };
  } else {
    return {
      status: 'Berlangsung',
      className: 'bg-green-100 text-green-700'
    };
  }
};
```

#### ✅ **Updated Event List:**
- Badge dipindah ke sebelah judul event
- Menggunakan `getEventStatus(event)` untuk menentukan status
- Menghapus badge progress sertifikat yang duplikat

#### ✅ **Layout Changes:**
```javascript
<div className="flex items-center justify-between mb-2">
  <h3 className="text-lg font-bold text-gray-900">{event.judul}</h3>
  <div className={`px-3 py-1 rounded-full text-xs font-medium ${eventStatus.className}`}>
    {eventStatus.status}
  </div>
</div>
```

## 📊 Expected Results

### **Event dengan Tanggal Berbeda:**

#### **Python Programming Bootcamp** (10 Jan 2026)
- ✅ Badge: **"Akan Datang"** (biru)

#### **Indonesia Tech Summit** (21 Des 2025)  
- ✅ Badge: **"Selesai"** (abu-abu)

#### **Web Development Bootcamp** (15 Des 2025)
- ✅ Badge: **"Selesai"** (abu-abu)

#### **UI/UX Design Workshop** (10 Des 2025)
- ✅ Badge: **"Selesai"** (abu-abu)

## 🎯 Consistency

Sekarang badge status di **Manajemen Sertifikat** konsisten dengan badge di:
- ✅ **Dashboard Organizer**
- ✅ **Event Management**  
- ✅ **Participants Management**

## 🚀 How to Test

1. **Go to Organizer Dashboard**
2. **Click "Manajemen Sertifikat"**
3. **Check badge status untuk setiap event**
4. **Verify badge sesuai dengan tanggal event**

### **Expected Badge Colors:**
- 🔵 **Biru** = Akan Datang (event belum dimulai)
- 🟢 **Hijau** = Berlangsung (event sedang berjalan)
- ⚫ **Abu-abu** = Selesai (event sudah selesai)

## 📝 Notes

- Badge sekarang berdasarkan tanggal event, bukan progress sertifikat
- Progress sertifikat tetap ditampilkan di progress bar
- Layout lebih konsisten dengan halaman lain
- Badge otomatis update berdasarkan tanggal sistem

**Badge status sekarang sesuai dengan tanggal event!** 🎉
