"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabaseClient";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

export function TicketList({ userId }: { userId: string }) {
  const [tickets, setTickets] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchTickets = async () => {
      const { data, error } = await supabase
        .from('tickets')
        .select(`
          *,
          trip_calculations (
            fare_amount,
            passenger_type,
            stations!trip_calculations_from_station_id_fkey (name),
            to_station:stations!trip_calculations_to_station_id_fkey (name)
          )
        `)
        .eq('user_id', userId)
        .order('created_at', { ascending: false });

      if (error) {
        console.error('Error fetching tickets:', error);
      } else {
        setTickets(data || []);
      }
      setLoading(false);
    };

    fetchTickets();
  }, [userId]);

  if (loading) return <div>Loading tickets...</div>;

  if (tickets.length === 0) {
    return (
      <Card>
        <CardContent className="p-8 text-center text-muted-foreground">
          No tickets found. Plan a journey to buy one!
        </CardContent>
      </Card>
    );
  }

  return (
    <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
      {tickets.map((ticket) => (
        <Card key={ticket.id} className="overflow-hidden border-l-4 border-l-primary">
          <CardHeader className="bg-muted/50 pb-2">
            <div className="flex justify-between items-start">
              <CardTitle className="text-lg">
                {ticket.trip_calculations?.stations?.name} → {ticket.trip_calculations?.to_station?.name}
              </CardTitle>
              <Badge variant={ticket.status === 'active' ? 'default' : 'secondary'}>
                {ticket.status}
              </Badge>
            </div>
          </CardHeader>
          <CardContent className="pt-4 space-y-2">
            <div className="flex justify-between text-sm">
              <span className="text-muted-foreground">Fare</span>
              <span className="font-bold">RM {ticket.trip_calculations?.fare_amount.toFixed(2)}</span>
            </div>
            <div className="flex justify-between text-sm">
              <span className="text-muted-foreground">Type</span>
              <span className="capitalize">{ticket.trip_calculations?.passenger_type}</span>
            </div>
            <div className="flex justify-between text-sm">
              <span className="text-muted-foreground">Date</span>
              <span>{new Date(ticket.purchase_date).toLocaleDateString()}</span>
            </div>
            <div className="text-xs text-muted-foreground mt-2 pt-2 border-t">
              ID: {ticket.id.slice(0, 8)}...
            </div>
          </CardContent>
        </Card>
      ))}
    </div>
  );
}
