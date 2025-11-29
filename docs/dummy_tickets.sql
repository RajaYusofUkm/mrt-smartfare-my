-- Dummy Tickets Data untuk Admin Dashboard
-- Jalankan di Supabase SQL Editor

-- Pertama, kita perlu beberapa trip_calculations
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

-- Sekarang masukkan dummy tickets
-- NOTA: Ganti 'YOUR_USER_ID' dengan user_id sebenar anda dari Supabase Auth
-- Anda boleh dapatkan user_id dari Authentication > Users di Supabase Dashboard

-- Untuk testing, kita guna user_id yang sama (anda perlu tukar ini)
DO $$
DECLARE
    test_user_id uuid;
BEGIN
    -- Cuba dapatkan mana-mana user yang ada
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
        
        RAISE NOTICE 'Dummy tickets inserted for user: %', test_user_id;
    ELSE
        RAISE NOTICE 'No users found. Please sign up first!';
    END IF;
END $$;

-- Verify data
SELECT 
    t.id,
    t.status,
    tc.fare_amount,
    tc.passenger_type,
    s1.name as from_station,
    s2.name as to_station,
    t.purchase_date
FROM tickets t
JOIN trip_calculations tc ON t.trip_calculation_id = tc.id
JOIN stations s1 ON tc.from_station_id = s1.id
JOIN stations s2 ON tc.to_station_id = s2.id
ORDER BY t.purchase_date DESC;
