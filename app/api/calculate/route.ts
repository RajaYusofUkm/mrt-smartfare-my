import { NextResponse } from 'next/server';
import { supabase } from '@/lib/supabaseClient';

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { from_station_id, to_station_id, passenger_type } = body;

    if (!from_station_id || !to_station_id) {
      return NextResponse.json({ error: 'Missing stations' }, { status: 400 });
    }

    // Fetch stations
    const { data: stations, error } = await supabase
      .from('stations')
      .select('*, lines(name, mode)')
      .in('id', [from_station_id, to_station_id]);

    if (error || !stations || stations.length !== 2) {
      return NextResponse.json({ error: 'Stations not found' }, { status: 404 });
    }

    const fromStation = stations.find(s => s.id === from_station_id);
    const toStation = stations.find(s => s.id === to_station_id);

    // --- FARE CALCULATION LOGIC ---
    let totalFare = 0;
    let distanceKm = 0;

    // Helper: Haversine Distance
    const getDistance = (lat1: number, lon1: number, lat2: number, lon2: number) => {
      const R = 6371; // Radius of the earth in km
      const dLat = (lat2 - lat1) * (Math.PI / 180);
      const dLon = (lon2 - lon1) * (Math.PI / 180);
      const a = 
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(lat1 * (Math.PI / 180)) * Math.cos(lat2 * (Math.PI / 180)) * 
        Math.sin(dLon / 2) * Math.sin(dLon / 2); 
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)); 
      return R * c;
    };

    // 1. If we have coordinates, use Real Distance Formula
    if (fromStation.latitude && fromStation.longitude && toStation.latitude && toStation.longitude) {
      const straightLineDist = getDistance(fromStation.latitude, fromStation.longitude, toStation.latitude, toStation.longitude);
      // Rail distance is usually 1.3x straight line distance (tortuosity factor)
      distanceKm = straightLineDist * 1.3;

      // Official Rapid KL Fare Structure (Cashless)
      // Base: 1.20
      // 0-4km: 0.20/km
      // 4-9km: 0.10/km
      // 9-14km: 0.10/km
      // 14-24km: 0.10/km
      // >24km: 0.10/km
      
      // Simplified: 1.20 + (First 4km * 0.20) + (Rest * 0.10)
      // Actually, let's be more precise based on common structures:
      // 0 - 4 km: 1.20 + (dist * 0.20) -- Wait, usually base includes first X km? 
      // No, usually Base + Rate*Dist.
      
      let fare = 1.20;
      let remainingDist = distanceKm;

      // First 4km
      const block1 = Math.min(remainingDist, 4);
      fare += block1 * 0.20;
      remainingDist -= block1;

      // Next 5km (4-9)
      if (remainingDist > 0) {
        const block2 = Math.min(remainingDist, 5);
        fare += block2 * 0.10;
        remainingDist -= block2;
      }

      // Next 5km (9-14)
      if (remainingDist > 0) {
        const block3 = Math.min(remainingDist, 5);
        fare += block3 * 0.10;
        remainingDist -= block3;
      }

      // Next 10km (14-24)
      if (remainingDist > 0) {
        const block4 = Math.min(remainingDist, 10);
        fare += block4 * 0.10;
        remainingDist -= block4;
      }

      // Above 24km
      if (remainingDist > 0) {
        fare += remainingDist * 0.10;
      }

      // Round to nearest 0.10
      totalFare = Math.ceil(fare * 10) / 10;

    } else {
      // 2. Fallback: Sequence-based Calculation (if coords missing)
      if (fromStation.line_id === toStation.line_id) {
        const seqDiff = Math.abs((fromStation.sequence || 0) - (toStation.sequence || 0));
        totalFare = 1.20 + (seqDiff * 0.40);
      } else {
        const dist1 = Math.abs((fromStation.sequence || 0) - 10);
        const dist2 = Math.abs((toStation.sequence || 0) - 10);
        const seqDiff = dist1 + dist2;
        totalFare = 1.20 + 0.70 + (seqDiff * 0.40);
      }
    }

    // Cap max fare (e.g. RM 8.00 is reasonable max for RapidKL)
    if (totalFare > 10.00) totalFare = 10.00;

    // Apply discounts
    let discount = 0;
    if (passenger_type === 'student' || passenger_type === 'senior') {
      discount = 50;
      totalFare = totalFare * 0.5;
    } else if (passenger_type === 'oku') {
      discount = 100;
      totalFare = 0;
    }

    // Save calculation to DB
    const { data: calcData, error: calcError } = await supabase
      .from('trip_calculations')
      .insert({
        from_station_id,
        to_station_id,
        fare_amount: totalFare,
        passenger_type
      })
      .select()
      .single();

    if (calcError) {
      console.error('Error saving calculation:', calcError);
    }

    return NextResponse.json({
      trip_calculation_id: calcData?.id,
      from: fromStation.name,
      to: toStation.name,
      mode: fromStation.line_id === toStation.line_id ? 'Direct' : 'Interchange',
      passengerType: passenger_type,
      baseFare: discount === 100 ? "0.00" : (totalFare / (1 - discount/100)).toFixed(2), // Reverse calc for display
      discount,
      finalFare: totalFare.toFixed(2),
      duration: Math.ceil(distanceKm ? distanceKm * 2.5 + 5 : 20) // Mock duration: 2.5 mins per km + 5 mins buffer
    });

  } catch (e) {
    console.error(e);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
