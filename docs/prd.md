# MRT SmartFare MY – Product Requirement Document (PRD)

---

## 1. Product Overview

**Product Name (Working Title)**  
**MRT SmartFare MY**

**Ringkasan**

MRT SmartFare MY ialah web app untuk pengguna di Malaysia:

- Mengira tambang perjalanan **MRT / LRT / Monorel** antara dua stesen  
- Memberi anggaran **masa perjalanan**  
- Mengira **kos bulanan** dan **perbandingan dengan kos kereta**  
- Menyokong kategori pengguna:
  - **OKU – Percuma (100% diskaun)**
  - **Warga emas – 50% diskaun**
  - **Pelajar – 50% diskaun**
  - **Normal – tiada diskaun**
- Menyediakan **simulasi pembayaran (fake payment)**:
  - User klik **"Bayar sekarang"** dan sistem cipta **tiket pseudo** (tanpa payment gateway sebenar)
  - Tiket tersebut muncul di **User Dashboard** dan **Admin Dashboard**

Aplikasi menggunakan:

- **Frontend:** Next.js (React), Tailwind CSS, shadcn/ui  
- **Backend:** Next.js Route Handlers (API), boleh evolve ke Supabase Edge Functions  
- **Database & Auth:** Supabase (Postgres, Auth, Storage)  

UI bertema **floral** (corak bunga) yang lembut, mesra pengguna, tetapi masih clean dan senang dibaca.

---

## 2. Goals & Objectives

### 2.1 Product Goals

1. Membolehkan pengguna mengira tambang & masa perjalanan untuk **MRT, LRT, dan Monorel** dengan mudah.
2. Mengira kos bulanan perjalanan dan membandingkan dengan kos kereta secara ringkas.
3. Menyediakan **fake payment flow** supaya user rasa “macam beli tiket” walaupun tiada payment gateway sebenar.
4. Menyokong diskaun mengikut kategori:
   - OKU (free), warga emas (50%), pelajar (50%), normal (0%).
5. Menyediakan **Admin Dashboard** dengan:
   - Monitoring pengguna & tiket
   - Analytics (total RM pseudo, penggunaan MRT/LRT/Monorel, passenger type)
   - Data management (lines, stations, fare_rules, discount_rules)
6. Mempunyai **architecture & file structure yang solid** untuk senang scale ke production kemudian.

### 2.2 Success Metrics (High-level)

- ≥ 70% visitors buat sekurang-kurangnya **1 calculation** per session.
- ≥ 30% user yang active akan login dan buat sekurang-kurangnya **1 fake payment (tiket)**.
- Admin boleh melihat:
  - Total pseudo revenue (sum final_fare)
  - Breakdown usage by mode (MRT/LRT/Monorel)
  - Breakdown by passenger type (normal/oku/senior/student).

---

## 3. Target Users & Personas

### 3.1 Persona A – Daily Commuter

- Guna MRT/LRT/Monorel untuk ke tempat kerja atau belajar.
- Perlukan:
  - Tambang dan masa perjalanan
  - Kos bulanan dan jimat berbanding kereta
  - Simulasi “beli tiket” untuk aim bajet

### 3.2 Persona B – Student / Tourist / New User

- Student yang layak diskaun / pengguna baru / pelancong.
- Perlukan:
  - Calculator simple, mobile-friendly
  - Info tentang diskaun mereka (student/senior/OKU)
  - UI yang mudah difahami

### 3.3 Persona C – Admin / Owner Sistem

- Developer/owner yang maintain sistem.
- Perlukan:
  - Dashboard overview
  - Data usage: tickets, revenue pseudo, mode, passenger type
  - CRUD data base (lines, stations, fare_rules, discount_rules)
  - Audit log admin actions

---

## 4. Scope

### 4.1 In Scope

- Web app responsive (desktop + mobile)
- Multi-mode:
  - MRT
  - LRT
  - Monorel
- Fare & time calculator antara dua stesen
- Monthly cost estimator
- Simple car vs MRT comparison
- Supabase Auth (user login)
- User Dashboard (My Tickets dan profile ringkas)
- Admin Dashboard:
  - Overview metrics
  - Ticket monitoring
  - User monitoring
  - Data management
- Fake payment / pseudo ticket flow (tiada real payment)
- Diskaun:
  - OKU = 100%
  - Warga emas = 50%
  - Student = 50%
  - Normal = 0%

### 4.2 Out of Scope

- Payment gateway sebenar (FPX, card, e-wallet)
- Live train timing/delay
- Mobile native app
- Official integration API operator MRT/LRT/Monorel

---

## 5. Phase 0 – Localhost Only

**Objective:**  
Membangunkan **MVP** di localhost dengan:

- Supabase DB + Auth
- Fare calculator
- Fake payment (tiket pseudo)
- Minimum admin view (tickets list)

### 5.1 Environment (Phase 0)

- **Frontend:** Next.js (App Router), Tailwind, shadcn/ui  
  - URL: `http://localhost:3000`
- **Backend:** Next.js Route Handlers (`app/api/...`)
- **Database & Auth:** Supabase (hosted project)
- **Monitoring:** console log + Supabase dashboard

### 5.2 Deliverables (Phase 0)

- Supabase schema minimum:
  - `lines`, `stations`, `fare_rules`, `discount_rules`, `trip_calculations`, `tickets`, `user_profiles`, `admin_logs`
- Fare & time calculator berjalan:
  - UI form → `/api/calculate` → DB log → UI result
- Supabase Auth:
  - User boleh signup & login
- Fake payment:
  - Button “Bayar sekarang (Simulasi)”
  - Endpoint `/api/tickets/checkout` create tiket pseudo
- Simple Admin page:
  - List last 20 tickets + total pseudo RM simple

---

## 6. Core Features & Functional Requirements

### 6.1 Fare & Time Calculator (MRT/LRT/Monorel)

**Description**  
User pilih mode/line, stesen asal & destinasi, jenis masa, passenger type, dan dapat:

- tambang base
- diskaun
- tambang selepas diskaun
- anggaran masa perjalanan
- kos bulanan (jika freq diisi)

**Inputs:**

- `mode` (`MRT`, `LRT`, `MONORAIL`) – boleh derive dari line
- `from_station_id`
- `to_station_id`
- `time_type` (`peak`, `offpeak`)
- `passenger_type` (`normal`, `oku`, `senior`, `student`)
- (optional) `trips_per_day`
- (optional) `days_per_week`
- (optional) `car_petrol_month`, `car_toll_month`, `car_parking_month` (untuk comparison)

**Outputs:**

- `mode`
- `fare_base`
- `discount_percentage`
- `fare_after_discount`
- `estimated_duration_min`
- `number_of_interchanges` (jika multi-line)
- `estimated_monthly_cost` (jika freq diberi)
- (optional) `total_car_cost`, `monthly_saving_if_mrt`

**Functional Requirements:**

- FR-1: User pilih stesen daripada dropdown yang searchable.
- FR-2: Sistem validate `from_station_id` dan `to_station_id` wujud dan tidak sama.
- FR-3: Sistem kira `fare_base` menggunakan `fare_rules` (berdasarkan zon/distance/line simple v1).
- FR-4: Sistem dapatkan `discount_percentage` daripada `discount_rules` berdasarkan `passenger_type`.
- FR-5: Sistem kira `fare_after_discount = fare_base * (1 - discount_percentage/100)`.
- FR-6: Jika `trips_per_day` dan `days_per_week` wujud:
  - `monthly_trips ≈ trips_per_day * days_per_week * 4`
  - `estimated_monthly_cost = monthly_trips * fare_after_discount`.
- FR-7: Jika input car cost diberi, sistem kira:
  - `total_car_cost = petrol + toll + parking`
  - `monthly_saving_if_mrt = total_car_cost - estimated_monthly_cost`.
- FR-8: Sistem log hasil ke `trip_calculations`:
  - termasuk `fare_base`, `discount_percentage`, `fare_after_discount`, `mode`, `passenger_type`.
- FR-9: Endpoint `/api/calculate` return semua data di atas dalam JSON.

---

### 6.2 Supabase Auth & User Profile

**Description**  
User perlu login untuk akses fungsi tertentu (fake payment, dashboard).

**Functional Requirements:**

- FR-10: User boleh signup & login menggunakan Supabase Auth.
- FR-11: `user_profiles` menyimpan:
  - `full_name`
  - `role` (`user`, `admin`)
  - `default_passenger_type` (`normal`, `oku`, `senior`, `student`)
- FR-12: Pada calculator, jika user login, `passenger_type` default diambil daripada `user_profiles.default_passenger_type`.
- FR-13: RLS:
  - User hanya boleh lihat `trip_calculations` dan `tickets` yang `user_id` sama dengan `auth.uid()`.
  - Admin (role `admin`) boleh lihat semua data.

---

### 6.3 Fake Payment & Ticketing (Pseudo)

**Description**  
Flow simulasi pembayaran tanpa payment gateway sebenar.

**Flow:**

1. User buat calculation.
2. Pada result page, jika login, ada button **“Bayar sekarang (Simulasi)”**.
3. Bila klik, frontend panggil `POST /api/tickets/checkout`.

**Functional Requirements:**

- FR-14: Endpoint `POST /api/tickets/checkout`:
  - Input body:
    - `trip_calculation_id`
  - Proses backend:
    - Dapatkan user dari Supabase Auth token.
    - Tarik row `trip_calculations` yang berkaitan.
    - Pastikan `trip_calculations.user_id` = `auth.uid()` (untuk security).
    - Jika `user_id` null atau tak match → return error 403.
    - Ambil `fare_base`, `discount_percentage`, `fare_after_discount`, `mode`, `passenger_type`.
    - Insert ke `tickets`:
      - `user_id`
      - `trip_calculation_id`
      - `mode`
      - `passenger_type`
      - `base_fare` = `fare_base`
      - `discount_percentage`
      - `final_fare` = `fare_after_discount`
      - `status` = `'PAID'`
  - Return JSON ticket info (id, final_fare, etc.).
- FR-15: Jika user belum login dan klik “Bayar sekarang”, sistem redirect ke login page dahulu.
- FR-16: Tiada panggilan ke payment gateway sebenar (100% simulated).
- FR-17: Tiket yang berjaya akan muncul:
  - Di User Dashboard → “My Tickets”
  - Di Admin Dashboard → “All Tickets”

---

### 6.4 Diskaun / Passenger Types

**Passenger Types:**

- `normal`
- `oku`
- `senior`
- `student`

**Default Rules:**

- OKU → 100% diskaun
- Senior → 50% diskaun
- Student → 50% diskaun
- Normal → 0% diskaun

**Functional Requirements:**

- FR-18: `discount_rules` table mesti menyimpan peraturan ini.
- FR-19: Fare calculation dan ticket checkout mesti rujuk `discount_rules` (bukan hard-code) supaya admin boleh update jika perlu.
- FR-20: Admin boleh manage `discount_rules` melalui Admin Dashboard (optional future).

---

### 6.5 User Dashboard

**Description**  
Dashboard ringkas untuk user yang login.

**Content:**

- “My Tickets” – senarai tiket pseudo
- Info user profile + default passenger type

**Functional Requirements:**

- FR-21: Page `/dashboard` hanya boleh diakses user login.
- FR-22: List “My Tickets” memaparkan:
  - Tarikh
  - From station → To station
  - Mode
  - Passenger type
  - Final fare
  - Status (PAID)
- FR-23: User boleh update `default_passenger_type` di profile (normal/oku/senior/student).

---

### 6.6 Admin Dashboard

#### 6.6.1 Admin Authentication

- FR-24: Role admin ditentukan melalui `user_profiles.role = 'admin'`.
- FR-25: Admin routes (UI & API) mesti check role `admin`.

#### 6.6.2 Admin Overview & Analytics

**Functional Requirements:**

- FR-26: Admin Overview page mesti paparkan:
  - `total_users`
  - `total_tickets` (status `PAID`)
  - `total_revenue` (sum `tickets.final_fare`)
  - Breakdown by mode (MRT, LRT, Monorel):
    - `tickets_count` + `revenue`
  - Breakdown by passenger type (normal, oku, senior, student):
    - `tickets_count` + `revenue`
- FR-27: Admin boleh pilih **date range** (start_date, end_date) untuk filter analytics.
- FR-28: Admin boleh filter analytics ikut:
  - mode (MRT/LRT/MONORAIL/ALL)
  - passenger_type (normal/oku/senior/student/ALL)

---

#### 6.6.3 Admin Analytics Endpoint

- FR-29: Endpoint `GET /api/admin/analytics`:
  - Query params:
    - `start_date`, `end_date`
    - `mode` (optional)
    - `passenger_type` (optional)
  - Return JSON:

    ```json
    {
      "filters": {
        "start_date": "2026-01-01",
        "end_date": "2026-01-31",
        "mode": "ALL",
        "passenger_type": "ALL"
      },
      "summary": {
        "total_revenue": 1234.50,
        "total_tickets": 320,
        "total_unique_users": 85
      },
      "by_mode": [
        { "mode": "MRT", "tickets": 200, "revenue": 900.0 },
        { "mode": "LRT", "tickets": 80,  "revenue": 250.0 },
        { "mode": "MONORAIL", "tickets": 40, "revenue": 84.5 }
      ],
      "by_passenger_type": [
        { "type": "normal", "tickets": 150, "revenue": 800.0 },
        { "type": "oku",    "tickets": 20,  "revenue": 0.0 },
        { "type": "senior", "tickets": 80,  "revenue": 200.0 },
        { "type": "student","tickets": 70,  "revenue": 234.5 }
      ],
      "daily_trend": [
        { "date": "2026-01-01", "tickets": 20, "revenue": 80.0 },
        { "date": "2026-01-02", "tickets": 15, "revenue": 70.0 }
      ]
    }
    ```

- FR-30: Endpoint ini hanya boleh diakses oleh admin.

---

#### 6.6.4 Admin – User & Ticket Monitoring

- FR-31: Admin User page:
  - List user (email, full_name, role, total_tickets, total_calculations, last_activity).
- FR-32: Admin Tickets page:
  - List semua tickets dengan filter:
    - mode
    - passenger_type
    - date range

---

#### 6.6.5 Admin – Data Management

- FR-33: Admin boleh **CREATE/UPDATE/DELETE**:
  - `lines` (MRT/LRT/Monorel)
  - `stations`
  - `fare_rules`
  - (optional future) `discount_rules`
- FR-34: Setiap perubahan disimpan dalam `admin_logs` dengan:
  - `admin_id`, `action`, `details`, `created_at`.

---

### 6.7 Floral UI Theme

**Functional Requirements:**

- FR-35: Background UI menggunakan corak bunga (SVG/CSS) yang subtle.
- FR-36: Colour palette pastel (contoh hijau lembut, lavender, pink) tetapi contrast cukup.
- FR-37: Component utama (card, button) dengan rounded corners dan floral accent.
- FR-38: (Future) Toggle untuk tukar antara “Floral” dan “Minimal”.

---

## 7. Non-Functional Requirements (NFR)

- NFR-1: API `/api/calculate` P95 < 1s.
- NFR-2: API `/api/tickets/checkout` P95 < 1.5s.
- NFR-3: UI utama load dalam < 3s pada mobile 4G biasa (production).
- NFR-4: Semua secret (Supabase key, service role) diletakkan dalam `.env`, bukan code.
- NFR-5: RLS diaktifkan untuk `trip_calculations`, `tickets`, `user_profiles`.
- NFR-6: Admin API hanya boleh diakses oleh user dengan `role = 'admin'`.
- NFR-7: UI responsive dan readable (minimum WCAG AA).

---

## 8. Architecture & Ecosystem

### 8.1 Tech Stack

- **Frontend:** Next.js (App Router), React, Tailwind CSS, shadcn/ui, Recharts/Chart.js
- **Backend:** Next.js Route Handlers (`app/api/...`)
- **Database & Auth:** Supabase (Postgres, Auth, Storage)
- **Future:** Supabase Edge Functions untuk offload heavy logic

### 8.2 Flow – Fare Calculation

1. User buka homepage `/`.
2. UI call Supabase / API untuk fetch list `lines` dan `stations`.
3. User isi form (mode/line, from, to, passenger_type, time_type, freq).
4. Submit → `POST /api/calculate`.
5. Backend:
   - Validate input.
   - Query `stations`, `lines`, `fare_rules`, `discount_rules`.
   - Kira `fare_base`, `discount_percentage`, `fare_after_discount`, `estimated_duration_min`, `estimated_monthly_cost`.
   - Insert ke `trip_calculations`.
6. API return JSON result.
7. UI render result dalam card floral + button “Bayar sekarang (Simulasi)” jika user login.

### 8.3 Flow – Fake Payment / Ticket Checkout

1. User klik **"Bayar sekarang (Simulasi)"**.
2. Frontend `POST /api/tickets/checkout` dengan `trip_calculation_id`.
3. Backend:
   - Dapatkan auth user.
   - Validate calculation milik user.
   - Re-apply discount (safety).
   - Insert `tickets` dengan status `PAID`.
4. Return JSON ticket.
5. UI redirect / tunjuk success + link ke `/dashboard`.

### 8.4 Flow – Admin Analytics

1. Admin login.
2. Admin buka `/admin`.
3. Frontend panggil `GET /api/admin/analytics` dengan filter (date range, mode, passenger type).
4. Backend (menggunakan Supabase service role):
   - Aggregate data daripada `tickets`, `trip_calculations`, `user_profiles`.
   - Return `summary`, `by_mode`, `by_passenger_type`, `daily_trend`.
5. UI tunjuk card & chart.

---

## 9. Data Model (Supabase)

### 9.1 `user_profiles`

- `id` (uuid, PK, FK → auth.users.id)
- `full_name` (text)
- `role` (text: 'user' | 'admin')
- `default_passenger_type` (text: 'normal' | 'oku' | 'senior' | 'student')
- `home_station_id` (uuid, FK → stations.id, nullable)
- `work_station_id` (uuid, FK → stations.id, nullable)
- `created_at` (timestamptz)
- `updated_at` (timestamptz)

### 9.2 `lines`

- `id` (uuid, PK)
- `name` (text)
- `code` (text)
- `mode` (text: 'MRT' | 'LRT' | 'MONORAIL')
- `color` (text) – hex
- `created_at` (timestamptz)

### 9.3 `stations`

- `id` (uuid, PK)
- `line_id` (uuid, FK → lines.id)
- `name` (text)
- `code` (text)
- `sequence` (int)
- `zone` (text)
- `latitude` (float8, nullable)
- `longitude` (float8, nullable)
- `created_at` (timestamptz)

### 9.4 `fare_rules`

- `id` (uuid, PK)
- `line_id` (uuid, FK → lines.id, nullable jika global)
- `min_zones` (int)
- `max_zones` (int)
- `peak_fare` (numeric)
- `offpeak_fare` (numeric)
- `created_at` (timestamptz)

### 9.5 `discount_rules`

- `id` (uuid, PK)
- `code` (text: 'normal' | 'oku' | 'senior' | 'student')
- `description` (text)
- `discount_percentage` (numeric)
- `created_at` (timestamptz)

### 9.6 `trip_calculations`

- `id` (uuid, PK)
- `user_id` (uuid, FK → auth.users.id, nullable)
- `from_station_id` (uuid, FK → stations.id)
- `to_station_id` (uuid, FK → stations.id)
- `mode` (text: 'MRT' | 'LRT' | 'MONORAIL')
- `time_type` (text: 'peak' | 'offpeak')
- `passenger_type` (text: 'normal' | 'oku' | 'senior' | 'student')
- `fare_base` (numeric)
- `discount_percentage` (numeric)
- `fare_after_discount` (numeric)
- `estimated_duration_min` (int)
- `trips_per_day` (int, nullable)
- `days_per_week` (int, nullable)
- `estimated_monthly_cost` (numeric, nullable)
- `created_at` (timestamptz)

### 9.7 `tickets`

- `id` (uuid, PK)
- `user_id` (uuid, FK → auth.users.id)
- `trip_calculation_id` (uuid, FK → trip_calculations.id)
- `mode` (text: 'MRT' | 'LRT' | 'MONORAIL')
- `passenger_type` (text: 'normal' | 'oku' | 'senior' | 'student')
- `base_fare` (numeric)
- `discount_percentage` (numeric)
- `final_fare` (numeric)
- `status` (text: 'PAID' | 'CANCELLED' – Phase 0 hanya 'PAID')
- `created_at` (timestamptz)

### 9.8 `admin_logs`

- `id` (uuid, PK)
- `admin_id` (uuid, FK → auth.users.id)
- `action` (text)
- `details` (jsonb)
- `created_at` (timestamptz)

---

## 10. File Structure (Frontend + Backend)

### 10.1 Next.js Project

```txt
app/
  layout.tsx
  page.tsx                       # Landing + calculator

  (auth)/
    login/page.tsx
    callback/page.tsx

  dashboard/
    page.tsx                     # User dashboard (My Tickets)

  admin/
    page.tsx                     # Admin overview & analytics
    users/page.tsx               # User monitoring
    tickets/page.tsx             # Ticket monitoring
    data/
      lines/page.tsx
      stations/page.tsx
      fares/page.tsx
      discounts/page.tsx         # optional

  api/
    calculate/route.ts           # POST /api/calculate
    tickets/
      checkout/route.ts          # POST /api/tickets/checkout
    admin/
      analytics/route.ts         # GET /api/admin/analytics
      users/route.ts             # GET /api/admin/users
      tickets/route.ts           # GET /api/admin/tickets

components/
  ui/                            # shadcn components
  layout/
    Navbar.tsx
    Sidebar.tsx
  calculator/
    FareForm.tsx
    FareResult.tsx
  dashboard/
    TicketList.tsx
    ProfileCard.tsx
  admin/
    AnalyticsCards.tsx
    AnalyticsChart.tsx
    UserTable.tsx
    TicketTable.tsx

lib/
  supabaseClient.ts
  fareCalculator.ts
  discount.ts
  auth.ts
  analytics.ts

styles/
  globals.css
  theme.css                      # Floral theme styles

types/
  db.ts
  api.ts

11. Analytics & Reporting (Admin)

Metrics utama yang diukur:

Total pseudo revenue (SUM(tickets.final_fare))

Total tickets (bilangan tickets)

Total unique buyers (COUNT(DISTINCT tickets.user_id))

Breakdown mengikut:

Mode (MRT/LRT/MONORAIL) – tickets & revenue

Passenger type (normal/oku/senior/student) – tickets & revenue

Conversion:

conversion_rate = tickets / trip_calculations

Top stations & routes

Daily trend:

Tickets per day

Revenue per day

Filters:

Date range (start_date, end_date)

Mode (MRT, LRT, MONORAIL, atau ALL)

Passenger type (normal, oku, senior, student, atau ALL)

Admin Analytics page guna data dari endpoint /api/admin/analytics dan visualkan dengan card + chart.

12. Roadmap Ringkas

Phase 0 (localhost)

Setup Supabase schema

Fare calculator + fake payment + simple admin tickets view

Phase 1 (dev/staging)

Full User Dashboard

Full Admin Dashboard + Analytics

CRUD data (lines, stations, fare rules, discounts)

Phase 2 (production)

Deploy ke Vercel + Supabase prod

RLS & security hardened

Monitoring (Sentry, Vercel Analytics)

Extra features (export report, map, etc.)