-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- 1. Lines Table
create table lines (
  id text primary key,
  name text not null,
  mode text not null check (mode in ('MRT', 'LRT', 'MONORAIL')),
  color text
);

-- 2. Stations Table
create table stations (
  id text primary key,
  name text not null,
  line_id text references lines(id),
  sequence integer,
  latitude float,
  longitude float
);

-- 3. Trip Calculations Table (Stores search history/calculations)
create table trip_calculations (
  id uuid default uuid_generate_v4() primary key,
  from_station_id text references stations(id),
  to_station_id text references stations(id),
  mode text,
  passenger_type text,
  base_fare float,
  discount_percentage integer,
  fare_amount float,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 4. Tickets Table (Stores "purchased" tickets)
create table tickets (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users(id),
  trip_calculation_id uuid references trip_calculations(id),
  status text check (status in ('active', 'used', 'expired')),
  purchase_date timestamp with time zone default timezone('utc'::text, now()),
  expiry_date timestamp with time zone
);

-- Enable RLS (Row Level Security)
alter table lines enable row level security;
alter table stations enable row level security;
alter table trip_calculations enable row level security;
alter table tickets enable row level security;

-- Policies
-- Public read access for lines and stations
create policy "Public lines are viewable by everyone" on lines for select using (true);
create policy "Public stations are viewable by everyone" on stations for select using (true);

-- Trip calculations: Public insert (for calculator), Public read (for results)
create policy "Anyone can insert calculations" on trip_calculations for insert with check (true);
create policy "Anyone can view calculations" on trip_calculations for select using (true);

-- Tickets: Users can only view their own tickets
create policy "Users can view own tickets" on tickets for select using (auth.uid() = user_id);
create policy "Users can insert own tickets" on tickets for insert with check (auth.uid() = user_id);

-- SEED DATA
insert into lines (id, name, mode, color) values
('kajang-line', 'MRT Kajang Line', 'MRT', '#00793e'),
('putrajaya-line', 'MRT Putrajaya Line', 'MRT', '#ffcd00'),
('kelana-jaya-line', 'LRT Kelana Jaya Line', 'LRT', '#e0004d'),
('ampang-line', 'LRT Ampang Line', 'LRT', '#ff8200'),
('kl-monorail', 'KL Monorail', 'MONORAIL', '#78be20');

insert into stations (id, name, line_id, sequence) values
-- MRT Kajang Line
('sbk01', 'Kwasa Damansara', 'kajang-line', 1),
('sbk02', 'Sungai Buloh', 'kajang-line', 2),
('sbk09', 'Bandar Utama', 'kajang-line', 9),
('sbk13', 'Pusat Bandar Damansara', 'kajang-line', 13),
('sbk14', 'Semantan', 'kajang-line', 14),
('sbk15', 'Muzium Negara', 'kajang-line', 15),
('sbk16', 'Pasar Seni', 'kajang-line', 16),
('sbk18', 'Bukit Bintang', 'kajang-line', 18),
('sbk20', 'Tun Razak Exchange', 'kajang-line', 20),
('sbk22', 'Maluri', 'kajang-line', 22),
('sbk35', 'Kajang', 'kajang-line', 35),

-- LRT Kelana Jaya Line
('kj01', 'Gombak', 'kelana-jaya-line', 1),
('kj10', 'KLCC', 'kelana-jaya-line', 10),
('kj14', 'Pasar Seni', 'kelana-jaya-line', 14),
('kj15', 'KL Sentral', 'kelana-jaya-line', 15),
('kj24', 'Kelana Jaya', 'kelana-jaya-line', 24),

-- Monorail
('mr1', 'KL Sentral', 'kl-monorail', 1),
('mr6', 'Bukit Bintang', 'kl-monorail', 6),
('mr11', 'Titiwangsa', 'kl-monorail', 11);
