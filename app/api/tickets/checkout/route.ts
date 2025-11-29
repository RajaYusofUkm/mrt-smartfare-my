import { NextResponse } from 'next/server';
import { supabase } from '@/lib/supabaseClient';

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { trip_calculation_id, user_id } = body;

    if (!trip_calculation_id || !user_id) {
      return NextResponse.json({ error: 'Missing data' }, { status: 400 });
    }

    // 1. Get calculation details
    const { data: calc, error: calcError } = await supabase
      .from('trip_calculations')
      .select('*')
      .eq('id', trip_calculation_id)
      .single();

    if (calcError || !calc) {
      return NextResponse.json({ error: 'Calculation not found' }, { status: 404 });
    }

    // 2. Create Ticket
    // In a real app, we would process payment with Stripe/ToyyibPay here.
    const { data: ticket, error: ticketError } = await supabase
      .from('tickets')
      .insert({
        user_id,
        trip_calculation_id,
        status: 'active',
        purchase_date: new Date().toISOString(),
        expiry_date: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString() // 24 hours validity
      })
      .select()
      .single();

    if (ticketError) {
      console.error('Ticket creation error:', ticketError);
      return NextResponse.json({ error: 'Failed to create ticket' }, { status: 500 });
    }

    return NextResponse.json({ success: true, ticket });

  } catch (e) {
    console.error(e);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
