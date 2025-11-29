"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabaseClient";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";

export default function AdminDashboard() {
  const [tickets, setTickets] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    totalRevenue: 0,
    totalTickets: 0,
    activeTickets: 0,
  });

  useEffect(() => {
    const fetchData = async () => {
      // Fetch all tickets with calculation details
      // Note: We cannot join auth.users directly from the client side due to security restrictions.
      const { data, error } = await supabase
        .from('tickets')
        .select(`
          *,
          trip_calculations (
            fare_amount,
            from_station:stations!trip_calculations_from_station_id_fkey (name),
            to_station:stations!trip_calculations_to_station_id_fkey (name)
          )
        `)
        .order('purchase_date', { ascending: false });

      if (error) {
        // Error biasanya berlaku kerana RLS policy - admin page perlu akses khas
        console.warn('Could not fetch tickets (RLS may be blocking):', error.message);
        setTickets([]);
      } else {
        setTickets(data || []);
        
        // Calculate stats
        const totalRev = data?.reduce((acc, t) => acc + (t.trip_calculations?.fare_amount || 0), 0) || 0;
        const active = data?.filter(t => t.status === 'active').length || 0;
        
        setStats({
          totalRevenue: totalRev,
          totalTickets: data?.length || 0,
          activeTickets: active,
        });
      }
      setLoading(false);
    };

    fetchData();
  }, []);

  if (loading) return <div className="p-8">Loading Admin Dashboard...</div>;

  return (
    <div className="space-y-8 p-8">
      <h1 className="text-3xl font-bold text-primary">Admin Dashboard</h1>

      {/* Stats Cards */}
      <div className="grid gap-4 md:grid-cols-3">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">Total Revenue</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">RM {stats.totalRevenue.toFixed(2)}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">Total Tickets Sold</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.totalTickets}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">Active Tickets</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.activeTickets}</div>
          </CardContent>
        </Card>
      </div>

      {/* Recent Transactions Table */}
      <Card>
        <CardHeader>
          <CardTitle>Recent Transactions</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>User</TableHead>
                <TableHead>Journey</TableHead>
                <TableHead>Fare</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Date</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {tickets.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={6} className="text-center text-muted-foreground py-8">
                    Tiada transaksi lagi
                  </TableCell>
                </TableRow>
              ) : (
                tickets.map((ticket) => (
                  <TableRow key={ticket.id}>
                    <TableCell className="font-mono text-xs">{ticket.id?.slice(0, 8) || '-'}</TableCell>
                    <TableCell className="text-xs text-muted-foreground">{ticket.user_id?.slice(0, 8) || '-'}...</TableCell>
                    <TableCell>
                      {ticket.trip_calculations?.from_station?.name || '?'} → {ticket.trip_calculations?.to_station?.name || '?'}
                    </TableCell>
                    <TableCell>RM {(ticket.trip_calculations?.fare_amount ?? 0).toFixed(2)}</TableCell>
                    <TableCell>
                      <Badge variant={ticket.status === 'active' ? 'default' : 'secondary'}>
                        {ticket.status || 'unknown'}
                      </Badge>
                    </TableCell>
                    <TableCell>{ticket.purchase_date ? new Date(ticket.purchase_date).toLocaleDateString() : '-'}</TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
