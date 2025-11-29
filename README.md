# 🚇 MRT SmartFare Malaysia

> ⚠️ **AMARAN: INI PROJEK TESTING/DEMO SAHAJA**  
> Projek ini dibuat untuk tujuan pembelajaran dan demo. **BUKAN** aplikasi sebenar dan **TIADA** kaitan dengan RapidKL atau Prasarana Malaysia.

---

## 📋 Tentang Projek

Aplikasi kalkulator tambang MRT/LRT/Monorail Malaysia. Dibina menggunakan:
- **Next.js 16** - Frontend framework
- **Supabase** - Backend & Database
- **Tailwind CSS** - Styling

## ✨ Ciri-Ciri (Demo)

- 🧮 Kira tambang antara stesen
- 🚉 Sokongan pelbagai mod pengangkutan (MRT, LRT, Monorail)
- 👥 Diskaun untuk pelajar, warga emas & OKU
- 🎫 Simulasi pembelian tiket
- 📊 Dashboard admin

## 🚀 Cara Jalankan

```bash
# Install dependencies
npm install

# Jalankan development server
npm run dev
```

Buka [http://localhost:3000](http://localhost:3000)

## ⚙️ Setup Supabase

1. Buat akaun di [supabase.com](https://supabase.com)
2. Buat projek baru
3. Jalankan SQL dari `docs/complete_setup.sql`
4. Salin URL dan Anon Key ke `.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=your_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_key
```

## 📁 Struktur Fail

```
├── app/
│   ├── (auth)/          # Login & Signup
│   ├── admin/           # Admin Dashboard
│   ├── api/             # API Routes
│   └── dashboard/       # User Dashboard
├── components/          # UI Components
├── docs/                # SQL Scripts
└── lib/                 # Utilities
```

## ⚠️ PENAFIAN PENTING

**INI BUKAN APLIKASI RASMI**

- ❌ Harga tambang adalah **ANGGARAN** dan mungkin **TIDAK TEPAT**
- ❌ Data stesen mungkin **TIDAK LENGKAP** atau **TIDAK TERKINI**
- ❌ **BUKAN** aplikasi rasmi RapidKL/Prasarana Malaysia
- ❌ Tiket yang "dibeli" adalah **SIMULASI SAHAJA**
- ✅ Untuk **RUJUKAN DAN PEMBELAJARAN** sahaja

---

*Dibina untuk tujuan pembelajaran* 🎓
