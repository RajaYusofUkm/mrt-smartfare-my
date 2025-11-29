-- ============================================
-- COMPLETE SETUP: MRT SmartFare Malaysia
-- Jalankan SEMUA kod ini di Supabase SQL Editor
-- ============================================

-- ============================================
-- PART 1: LINES (Laluan)
-- ============================================
INSERT INTO lines (id, name, mode, color) VALUES
('kajang-line', 'MRT Kajang Line', 'MRT', '#00793e'),
('putrajaya-line', 'MRT Putrajaya Line', 'MRT', '#ffcd00'),
('kelana-jaya-line', 'LRT Kelana Jaya Line', 'LRT', '#e0004d'),
('ampang-line', 'LRT Ampang Line', 'LRT', '#ff8200'),
('sri-petaling-line', 'LRT Sri Petaling Line', 'LRT', '#6e0e28'),
('kl-monorail', 'KL Monorail', 'MONORAIL', '#78be20')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- PART 2: STATIONS (Stesen)
-- ============================================
INSERT INTO stations (id, name, line_id, sequence) VALUES
-- MRT KAJANG LINE (SBK)
('sbk01', 'Kwasa Damansara', 'kajang-line', 1),
('sbk02', 'Sungai Buloh', 'kajang-line', 2),
('sbk03', 'Kampung Selamat', 'kajang-line', 3),
('sbk04', 'Kwasa Sentral', 'kajang-line', 4),
('sbk05', 'Kota Damansara', 'kajang-line', 5),
('sbk06', 'Surian', 'kajang-line', 6),
('sbk07', 'Mutiara Damansara', 'kajang-line', 7),
('sbk08', 'Bandar Utama', 'kajang-line', 8),
('sbk09', 'Taman Tun Dr Ismail', 'kajang-line', 9),
('sbk10', 'Phileo Damansara', 'kajang-line', 10),
('sbk12', 'Pusat Bandar Damansara', 'kajang-line', 12),
('sbk13', 'Semantan', 'kajang-line', 13),
('sbk14', 'Muzium Negara', 'kajang-line', 14),
('sbk15', 'Pasar Seni', 'kajang-line', 15),
('sbk16', 'Merdeka', 'kajang-line', 16),
('sbk17', 'Bukit Bintang', 'kajang-line', 17),
('sbk18', 'Tun Razak Exchange', 'kajang-line', 18),
('sbk19', 'Cochrane', 'kajang-line', 19),
('sbk20', 'Maluri', 'kajang-line', 20),
('sbk21', 'Taman Midah', 'kajang-line', 21),
('sbk22', 'Taman Mutiara', 'kajang-line', 22),
('sbk23', 'Taman Connaught', 'kajang-line', 23),
('sbk24', 'Taman Suntex', 'kajang-line', 24),
('sbk25', 'Sri Raya', 'kajang-line', 25),
('sbk26', 'Bandar Tun Hussein Onn', 'kajang-line', 26),
('sbk27', 'Batu 11 Cheras', 'kajang-line', 27),
('sbk28', 'Bukit Dukung', 'kajang-line', 28),
('sbk29', 'Sungai Jernih', 'kajang-line', 29),
('sbk30', 'Stadium Kajang', 'kajang-line', 30),
('sbk31', 'Kajang', 'kajang-line', 31),

-- MRT PUTRAJAYA LINE (PY)
('py01', 'Kwasa Damansara', 'putrajaya-line', 1),
('py03', 'Sungai Buloh', 'putrajaya-line', 3),
('py04', 'Damansara Damai', 'putrajaya-line', 4),
('py05', 'Sri Damansara Barat', 'putrajaya-line', 5),
('py06', 'Sri Damansara Sentral', 'putrajaya-line', 6),
('py07', 'Sri Damansara Timur', 'putrajaya-line', 7),
('py08', 'Metro Prima', 'putrajaya-line', 8),
('py09', 'Kepong Baru', 'putrajaya-line', 9),
('py10', 'Jinjang', 'putrajaya-line', 10),
('py11', 'Sri Delima', 'putrajaya-line', 11),
('py12', 'Kampung Batu', 'putrajaya-line', 12),
('py13', 'Kentonmen', 'putrajaya-line', 13),
('py14', 'Jalan Ipoh', 'putrajaya-line', 14),
('py15', 'Sentul Barat', 'putrajaya-line', 15),
('py16', 'Titiwangsa', 'putrajaya-line', 16),
('py17', 'Hospital Kuala Lumpur', 'putrajaya-line', 17),
('py18', 'Raja Uda', 'putrajaya-line', 18),
('py19', 'Ampang Park', 'putrajaya-line', 19),
('py20', 'Persiaran KLCC', 'putrajaya-line', 20),
('py21', 'Conlay', 'putrajaya-line', 21),
('py22', 'Tun Razak Exchange', 'putrajaya-line', 22),
('py23', 'Chan Sow Lin', 'putrajaya-line', 23),
('py24', 'Bandar Malaysia Utara', 'putrajaya-line', 24),
('py25', 'Bandar Malaysia Selatan', 'putrajaya-line', 25),
('py26', 'Kuchai', 'putrajaya-line', 26),
('py27', 'Taman Naga Emas', 'putrajaya-line', 27),
('py28', 'Sungai Besi', 'putrajaya-line', 28),
('py29', 'Serdang Raya Utara', 'putrajaya-line', 29),
('py30', 'Serdang Raya Selatan', 'putrajaya-line', 30),
('py31', 'Serdang Jaya', 'putrajaya-line', 31),
('py32', 'UPM', 'putrajaya-line', 32),
('py33', 'Taman Equine', 'putrajaya-line', 33),
('py34', 'Putra Permai', 'putrajaya-line', 34),
('py35', '16 Sierra', 'putrajaya-line', 35),
('py36', 'Cyberjaya Utara', 'putrajaya-line', 36),
('py37', 'Cyberjaya City Centre', 'putrajaya-line', 37),
('py38', 'Putrajaya Sentral', 'putrajaya-line', 38),

-- LRT KELANA JAYA LINE (KJ)
('kj01', 'Gombak', 'kelana-jaya-line', 1),
('kj02', 'Taman Melati', 'kelana-jaya-line', 2),
('kj03', 'Wangsa Maju', 'kelana-jaya-line', 3),
('kj04', 'Sri Rampai', 'kelana-jaya-line', 4),
('kj05', 'Setiawangsa', 'kelana-jaya-line', 5),
('kj06', 'Jelatek', 'kelana-jaya-line', 6),
('kj07', 'Dato Keramat', 'kelana-jaya-line', 7),
('kj08', 'Damai', 'kelana-jaya-line', 8),
('kj09', 'Ampang Park', 'kelana-jaya-line', 9),
('kj10', 'KLCC', 'kelana-jaya-line', 10),
('kj11', 'Kampung Baru', 'kelana-jaya-line', 11),
('kj12', 'Dang Wangi', 'kelana-jaya-line', 12),
('kj13', 'Masjid Jamek', 'kelana-jaya-line', 13),
('kj14', 'Pasar Seni', 'kelana-jaya-line', 14),
('kj15', 'KL Sentral', 'kelana-jaya-line', 15),
('kj16', 'Bangsar', 'kelana-jaya-line', 16),
('kj17', 'Abdullah Hukum', 'kelana-jaya-line', 17),
('kj18', 'Kerinchi', 'kelana-jaya-line', 18),
('kj19', 'Universiti', 'kelana-jaya-line', 19),
('kj20', 'Taman Jaya', 'kelana-jaya-line', 20),
('kj21', 'Asia Jaya', 'kelana-jaya-line', 21),
('kj22', 'Taman Paramount', 'kelana-jaya-line', 22),
('kj23', 'Taman Bahagia', 'kelana-jaya-line', 23),
('kj24', 'Kelana Jaya', 'kelana-jaya-line', 24),
('kj25', 'Lembah Subang', 'kelana-jaya-line', 25),
('kj26', 'Ara Damansara', 'kelana-jaya-line', 26),
('kj27', 'Glenmarie', 'kelana-jaya-line', 27),
('kj28', 'Subang Jaya', 'kelana-jaya-line', 28),
('kj29', 'SS15', 'kelana-jaya-line', 29),
('kj30', 'SS18', 'kelana-jaya-line', 30),
('kj31', 'USJ 7', 'kelana-jaya-line', 31),
('kj32', 'Taipan', 'kelana-jaya-line', 32),
('kj33', 'Wawasan', 'kelana-jaya-line', 33),
('kj34', 'USJ 21', 'kelana-jaya-line', 34),
('kj35', 'Alam Megah', 'kelana-jaya-line', 35),
('kj36', 'Subang Alam', 'kelana-jaya-line', 36),
('kj37', 'Putra Heights', 'kelana-jaya-line', 37),

-- LRT AMPANG LINE (AG)
('ag01', 'Sentul Timur', 'ampang-line', 1),
('ag02', 'Sentul', 'ampang-line', 2),
('ag03', 'Titiwangsa', 'ampang-line', 3),
('ag04', 'PWTC', 'ampang-line', 4),
('ag05', 'Sultan Ismail', 'ampang-line', 5),
('ag06', 'Bandaraya', 'ampang-line', 6),
('ag07', 'Masjid Jamek', 'ampang-line', 7),
('ag08', 'Plaza Rakyat', 'ampang-line', 8),
('ag09', 'Hang Tuah', 'ampang-line', 9),
('ag10', 'Pudu', 'ampang-line', 10),
('ag11', 'Chan Sow Lin', 'ampang-line', 11),
('ag12', 'Miharja', 'ampang-line', 12),
('ag13', 'Maluri', 'ampang-line', 13),
('ag14', 'Pandan Jaya', 'ampang-line', 14),
('ag15', 'Pandan Indah', 'ampang-line', 15),
('ag16', 'Cempaka', 'ampang-line', 16),
('ag17', 'Cahaya', 'ampang-line', 17),
('ag18', 'Ampang', 'ampang-line', 18),

-- LRT SRI PETALING LINE (SP)
('sp01', 'Sentul Timur', 'sri-petaling-line', 1),
('sp02', 'Sentul', 'sri-petaling-line', 2),
('sp03', 'Titiwangsa', 'sri-petaling-line', 3),
('sp04', 'PWTC', 'sri-petaling-line', 4),
('sp05', 'Sultan Ismail', 'sri-petaling-line', 5),
('sp06', 'Bandaraya', 'sri-petaling-line', 6),
('sp07', 'Masjid Jamek', 'sri-petaling-line', 7),
('sp08', 'Plaza Rakyat', 'sri-petaling-line', 8),
('sp09', 'Hang Tuah', 'sri-petaling-line', 9),
('sp10', 'Pudu', 'sri-petaling-line', 10),
('sp11', 'Chan Sow Lin', 'sri-petaling-line', 11),
('sp12', 'Cheras', 'sri-petaling-line', 12),
('sp13', 'Salak Selatan', 'sri-petaling-line', 13),
('sp14', 'Bandar Tun Razak', 'sri-petaling-line', 14),
('sp15', 'Bandar Tasik Selatan', 'sri-petaling-line', 15),
('sp16', 'Sungai Besi', 'sri-petaling-line', 16),
('sp17', 'Bukit Jalil', 'sri-petaling-line', 17),
('sp18', 'Sri Petaling', 'sri-petaling-line', 18),
('sp19', 'Awan Besar', 'sri-petaling-line', 19),
('sp20', 'Muhibbah', 'sri-petaling-line', 20),
('sp21', 'Alam Sutera', 'sri-petaling-line', 21),
('sp22', 'Kinrara BK5', 'sri-petaling-line', 22),
('sp23', 'IOI Puchong Jaya', 'sri-petaling-line', 23),
('sp24', 'Pusat Bandar Puchong', 'sri-petaling-line', 24),
('sp25', 'Taman Perindustrian Puchong', 'sri-petaling-line', 25),
('sp26', 'Bandar Puteri', 'sri-petaling-line', 26),
('sp27', 'Puchong Perdana', 'sri-petaling-line', 27),
('sp28', 'Puchong Prima', 'sri-petaling-line', 28),
('sp29', 'Putra Heights', 'sri-petaling-line', 29),

-- KL MONORAIL (MR)
('mr1', 'KL Sentral', 'kl-monorail', 1),
('mr2', 'Tun Sambanthan', 'kl-monorail', 2),
('mr3', 'Maharajalela', 'kl-monorail', 3),
('mr4', 'Hang Tuah', 'kl-monorail', 4),
('mr5', 'Imbi', 'kl-monorail', 5),
('mr6', 'Bukit Bintang', 'kl-monorail', 6),
('mr7', 'Raja Chulan', 'kl-monorail', 7),
('mr8', 'Bukit Nanas', 'kl-monorail', 8),
('mr9', 'Medan Tuanku', 'kl-monorail', 9),
('mr10', 'Chow Kit', 'kl-monorail', 10),
('mr11', 'Titiwangsa', 'kl-monorail', 11)

ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  line_id = EXCLUDED.line_id,
  sequence = EXCLUDED.sequence;

-- ============================================
-- PART 3: COORDINATES (Koordinat Stesen)
-- ============================================
UPDATE stations SET latitude = 3.1764, longitude = 101.5723 WHERE id IN ('sbk01', 'py01');
UPDATE stations SET latitude = 3.2064, longitude = 101.5814 WHERE id IN ('sbk02', 'py03');
UPDATE stations SET latitude = 2.9934, longitude = 101.7902 WHERE id = 'sbk31';
UPDATE stations SET latitude = 3.1341, longitude = 101.6861 WHERE id IN ('kj15', 'mr1');
UPDATE stations SET latitude = 3.1422, longitude = 101.6964 WHERE id IN ('sbk15', 'kj14');
UPDATE stations SET latitude = 3.1495, longitude = 101.6965 WHERE id IN ('kj13', 'ag07', 'sp07');
UPDATE stations SET latitude = 3.1583, longitude = 101.7116 WHERE id = 'kj10';
UPDATE stations SET latitude = 3.1427, longitude = 101.7197 WHERE id IN ('sbk18', 'py22');
UPDATE stations SET latitude = 3.1735, longitude = 101.6963 WHERE id IN ('py16', 'ag03', 'sp03', 'mr11');
UPDATE stations SET latitude = 3.0013, longitude = 101.5734 WHERE id IN ('kj37', 'sp29');
UPDATE stations SET latitude = 3.2313, longitude = 101.7244 WHERE id = 'kj01';
UPDATE stations SET latitude = 3.1503, longitude = 101.7600 WHERE id = 'ag18';
UPDATE stations SET latitude = 3.1475, longitude = 101.7089 WHERE id IN ('sbk17', 'mr6');
UPDATE stations SET latitude = 3.1205, longitude = 101.7286 WHERE id IN ('sbk20', 'ag13');
UPDATE stations SET latitude = 3.0763, longitude = 101.7113 WHERE id = 'sp15';
UPDATE stations SET latitude = 3.0499, longitude = 101.7060 WHERE id IN ('py28', 'sp16');
UPDATE stations SET latitude = 3.1390, longitude = 101.7103 WHERE id = 'sbk19';
UPDATE stations SET latitude = 3.1416, longitude = 101.7022 WHERE id IN ('sbk16', 'ag08', 'sp08');
UPDATE stations SET latitude = 3.1396, longitude = 101.7064 WHERE id IN ('ag09', 'sp09', 'mr4');
UPDATE stations SET latitude = 3.1279, longitude = 101.7143 WHERE id IN ('py23', 'ag11', 'sp11');
UPDATE stations SET latitude = 3.1366, longitude = 101.6870 WHERE id = 'sbk14';
UPDATE stations SET latitude = 3.1550, longitude = 101.7120 WHERE id = 'kj11';
UPDATE stations SET latitude = 3.1489, longitude = 101.6986 WHERE id = 'kj12';
UPDATE stations SET latitude = 3.1383, longitude = 101.6840 WHERE id = 'kj16';
UPDATE stations SET latitude = 3.1190, longitude = 101.6670 WHERE id = 'kj19';
UPDATE stations SET latitude = 3.1070, longitude = 101.6560 WHERE id = 'kj20';
UPDATE stations SET latitude = 3.1010, longitude = 101.6510 WHERE id = 'kj21';
UPDATE stations SET latitude = 3.0940, longitude = 101.6430 WHERE id = 'kj22';
UPDATE stations SET latitude = 3.0870, longitude = 101.6350 WHERE id = 'kj23';
UPDATE stations SET latitude = 3.0790, longitude = 101.6220 WHERE id = 'kj24';
UPDATE stations SET latitude = 3.1600, longitude = 101.6900 WHERE id IN ('ag04', 'sp04');
UPDATE stations SET latitude = 3.1540, longitude = 101.6960 WHERE id IN ('ag05', 'sp05');
UPDATE stations SET latitude = 3.1510, longitude = 101.6940 WHERE id IN ('ag06', 'sp06');
UPDATE stations SET latitude = 3.1330, longitude = 101.7150 WHERE id = 'ag10';
UPDATE stations SET latitude = 3.1260, longitude = 101.7200 WHERE id = 'ag12';
UPDATE stations SET latitude = 3.1180, longitude = 101.7350 WHERE id = 'ag14';
UPDATE stations SET latitude = 3.1250, longitude = 101.7450 WHERE id = 'ag15';
UPDATE stations SET latitude = 3.1350, longitude = 101.7500 WHERE id = 'ag16';
UPDATE stations SET latitude = 3.1420, longitude = 101.7550 WHERE id = 'ag17';
UPDATE stations SET latitude = 3.1680, longitude = 101.6920 WHERE id IN ('ag01', 'sp01');
UPDATE stations SET latitude = 3.1730, longitude = 101.6910 WHERE id IN ('ag02', 'sp02');
UPDATE stations SET latitude = 3.2150, longitude = 101.7100 WHERE id = 'kj02';
UPDATE stations SET latitude = 3.2050, longitude = 101.7150 WHERE id = 'kj03';
UPDATE stations SET latitude = 3.1950, longitude = 101.7180 WHERE id = 'kj04';
UPDATE stations SET latitude = 3.1850, longitude = 101.7200 WHERE id = 'kj05';
UPDATE stations SET latitude = 3.1780, longitude = 101.7180 WHERE id = 'kj06';
UPDATE stations SET latitude = 3.1720, longitude = 101.7150 WHERE id = 'kj07';
UPDATE stations SET latitude = 3.1660, longitude = 101.7130 WHERE id = 'kj08';
UPDATE stations SET latitude = 3.1600, longitude = 101.7150 WHERE id = 'kj09';
UPDATE stations SET latitude = 3.1450, longitude = 101.6950 WHERE id = 'mr2';
UPDATE stations SET latitude = 3.1420, longitude = 101.7000 WHERE id = 'mr3';
UPDATE stations SET latitude = 3.1460, longitude = 101.7060 WHERE id = 'mr5';
UPDATE stations SET latitude = 3.1510, longitude = 101.7050 WHERE id = 'mr7';
UPDATE stations SET latitude = 3.1540, longitude = 101.7010 WHERE id = 'mr8';
UPDATE stations SET latitude = 3.1580, longitude = 101.6990 WHERE id = 'mr9';
UPDATE stations SET latitude = 3.1650, longitude = 101.6970 WHERE id = 'mr10';

-- ============================================
-- PART 4: DUMMY TRIP CALCULATIONS
-- ============================================
INSERT INTO trip_calculations (id, from_station_id, to_station_id, fare_amount, passenger_type) VALUES
('11111111-1111-1111-1111-111111111111', 'kj01', 'kj10', 2.50, 'normal'),
('22222222-2222-2222-2222-222222222222', 'sbk01', 'sbk31', 6.80, 'normal'),
('33333333-3333-3333-3333-333333333333', 'kj15', 'kj24', 3.20, 'student'),
('44444444-4444-4444-4444-444444444444', 'ag03', 'ag18', 2.90, 'normal'),
('55555555-5555-5555-5555-555555555555', 'mr1', 'mr11', 2.50, 'senior'),
('66666666-6666-6666-6666-666666666666', 'sp03', 'sp29', 4.50, 'normal'),
('77777777-7777-7777-7777-777777777777', 'py01', 'py38', 7.20, 'normal'),
('88888888-8888-8888-8888-888888888888', 'kj10', 'kj37', 4.80, 'student'),
('99999999-9999-9999-9999-999999999999', 'sbk17', 'sbk20', 1.80, 'normal'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ag07', 'ag11', 1.60, 'oku'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'kj14', 'kj01', 3.40, 'normal'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'mr6', 'mr1', 2.10, 'normal'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'sp07', 'sp15', 2.80, 'senior'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'py16', 'py28', 3.60, 'normal'),
('ffffffff-ffff-ffff-ffff-ffffffffffff', 'sbk15', 'sbk18', 1.90, 'student')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- PART 5: DUMMY TICKETS (15 tiket contoh)
-- ============================================
DO $$
DECLARE
    test_user_id uuid;
BEGIN
    -- Dapatkan mana-mana user yang ada
    SELECT id INTO test_user_id FROM auth.users LIMIT 1;
    
    IF test_user_id IS NOT NULL THEN
        -- Insert dummy tickets
        INSERT INTO tickets (user_id, trip_calculation_id, status, purchase_date, expiry_date) VALUES
        (test_user_id, '11111111-1111-1111-1111-111111111111', 'active', NOW() - INTERVAL '1 hour', NOW() + INTERVAL '23 hours'),
        (test_user_id, '22222222-2222-2222-2222-222222222222', 'active', NOW() - INTERVAL '2 hours', NOW() + INTERVAL '22 hours'),
        (test_user_id, '33333333-3333-3333-3333-333333333333', 'used', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 hour'),
        (test_user_id, '44444444-4444-4444-4444-444444444444', 'active', NOW() - INTERVAL '3 hours', NOW() + INTERVAL '21 hours'),
        (test_user_id, '55555555-5555-5555-5555-555555555555', 'expired', NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day'),
        (test_user_id, '66666666-6666-6666-6666-666666666666', 'active', NOW() - INTERVAL '30 minutes', NOW() + INTERVAL '23 hours 30 minutes'),
        (test_user_id, '77777777-7777-7777-7777-777777777777', 'used', NOW() - INTERVAL '5 hours', NOW() + INTERVAL '19 hours'),
        (test_user_id, '88888888-8888-8888-8888-888888888888', 'active', NOW() - INTERVAL '4 hours', NOW() + INTERVAL '20 hours'),
        (test_user_id, '99999999-9999-9999-9999-999999999999', 'active', NOW() - INTERVAL '6 hours', NOW() + INTERVAL '18 hours'),
        (test_user_id, 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'used', NOW() - INTERVAL '1 day 2 hours', NOW() - INTERVAL '2 hours'),
        (test_user_id, 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'active', NOW() - INTERVAL '7 hours', NOW() + INTERVAL '17 hours'),
        (test_user_id, 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'expired', NOW() - INTERVAL '3 days', NOW() - INTERVAL '2 days'),
        (test_user_id, 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'active', NOW() - INTERVAL '8 hours', NOW() + INTERVAL '16 hours'),
        (test_user_id, 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'used', NOW() - INTERVAL '10 hours', NOW() + INTERVAL '14 hours'),
        (test_user_id, 'ffffffff-ffff-ffff-ffff-ffffffffffff', 'active', NOW() - INTERVAL '15 minutes', NOW() + INTERVAL '23 hours 45 minutes')
        ON CONFLICT DO NOTHING;
        
        RAISE NOTICE '✅ Dummy tickets inserted for user: %', test_user_id;
    ELSE
        RAISE NOTICE '❌ No users found. Please sign up first!';
    END IF;
END $$;

-- ============================================
-- PART 6: VERIFY DATA
-- ============================================
SELECT 'Lines:' as info, COUNT(*) as count FROM lines
UNION ALL
SELECT 'Stations:', COUNT(*) FROM stations
UNION ALL
SELECT 'Trip Calculations:', COUNT(*) FROM trip_calculations
UNION ALL
SELECT 'Tickets:', COUNT(*) FROM tickets;
