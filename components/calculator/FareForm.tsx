"use client";

import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Label } from "@/components/ui/label";
import { supabase } from "@/lib/supabaseClient";
import { useRouter } from "next/navigation";

const PASSENGER_TYPES = [
  { value: "normal", label: "Normal (No Discount)" },
  { value: "student", label: "Student (50% Off)" },
  { value: "senior", label: "Senior Citizen (50% Off)" },
  { value: "oku", label: "OKU (Free)" },
];

export function FareForm() {
  const [fromMode, setFromMode] = useState<string>("");
  const [toMode, setToMode] = useState<string>("");
  const [fromStation, setFromStation] = useState("");
  const [toStation, setToStation] = useState("");
  const [passengerType, setPassengerType] = useState("normal");
  const [result, setResult] = useState<any>(null);
  const [loading, setLoading] = useState(false);
  const [paying, setPaying] = useState(false);
  
  const [stations, setStations] = useState<any[]>([]);
  const [lines, setLines] = useState<any[]>([]);
  const router = useRouter();

  useEffect(() => {
    const fetchData = async () => {
      const { data: linesData } = await supabase.from('lines').select('*');
      const { data: stationsData } = await supabase.from('stations').select('*, lines(name, mode)').order('name');
      
      if (linesData) setLines(linesData);
      if (stationsData) setStations(stationsData);
    };
    fetchData();
  }, []);

  // Extract unique modes
  const modes = Array.from(new Set(lines.map(l => l.mode)));

  // Filter stations based on selected mode
  const fromStationsFiltered = fromMode 
    ? stations.filter(s => s.lines?.mode === fromMode).sort((a, b) => (a.sequence || 0) - (b.sequence || 0))
    : [];
    
  const toStationsFiltered = toMode 
    ? stations.filter(s => s.lines?.mode === toMode).sort((a, b) => (a.sequence || 0) - (b.sequence || 0))
    : [];

  const handleCalculate = async () => {
    setLoading(true);
    try {
      const res = await fetch('/api/calculate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          from_station_id: fromStation,
          to_station_id: toStation,
          passenger_type: passengerType
        })
      });
      
      if (!res.ok) throw new Error('Calculation failed');
      
      const data = await res.json();
      setResult(data);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  const handlePay = async () => {
    setPaying(true);
    try {
      // 1. Check Auth
      const { data: { session } } = await supabase.auth.getSession();
      if (!session) {
        router.push("/login");
        return;
      }

      // 2. Create Ticket directly (Client-side to respect RLS with Auth Session)
      const { error } = await supabase.from('tickets').insert({
        user_id: session.user.id,
        trip_calculation_id: result.trip_calculation_id,
        status: 'active',
        purchase_date: new Date().toISOString(),
        expiry_date: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString() // 24 hours validity
      });

      if (error) throw error;

      // 3. Redirect to Dashboard
      router.push("/dashboard");
      
    } catch (error) {
      console.error(error);
      alert("Payment failed. Please try again.");
    } finally {
      setPaying(false);
    }
  };

  return (
    <div className="grid gap-8 md:grid-cols-2">
      <Card className="w-full shadow-lg border-primary/20">
        <CardHeader className="bg-primary/5">
          <CardTitle className="text-2xl text-primary">Plan Your Journey</CardTitle>
          <CardDescription>Calculate fares across MRT, LRT, and Monorail</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4 pt-6">
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* FROM SECTION */}
            <div className="space-y-4 p-4 border rounded-lg bg-muted/20">
              <Label className="text-lg font-semibold text-primary">From</Label>
              
              <div className="space-y-2">
                <Label className="text-xs text-muted-foreground">Select Mode</Label>
                <Select value={fromMode} onValueChange={(val) => { setFromMode(val); setFromStation(""); }}>
                  <SelectTrigger>
                    <SelectValue placeholder="Select Mode (e.g. MRT)" />
                  </SelectTrigger>
                  <SelectContent>
                    {modes.map((m) => (
                      <SelectItem key={m} value={m}>{m}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <Label className="text-xs text-muted-foreground">Select Station</Label>
                <Select value={fromStation} onValueChange={setFromStation} disabled={!fromMode}>
                  <SelectTrigger>
                    <SelectValue placeholder={fromMode ? "Select Station" : "Select Mode First"} />
                  </SelectTrigger>
                  <SelectContent className="max-h-[300px]">
                    {fromStationsFiltered.map((s) => (
                      <SelectItem key={s.id} value={s.id}>
                        {s.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>

            {/* TO SECTION */}
            <div className="space-y-4 p-4 border rounded-lg bg-muted/20">
              <Label className="text-lg font-semibold text-primary">To</Label>
              
              <div className="space-y-2">
                <Label className="text-xs text-muted-foreground">Select Mode</Label>
                <Select value={toMode} onValueChange={(val) => { setToMode(val); setToStation(""); }}>
                  <SelectTrigger>
                    <SelectValue placeholder="Select Mode (e.g. LRT)" />
                  </SelectTrigger>
                  <SelectContent>
                    {modes.map((m) => (
                      <SelectItem key={m} value={m}>{m}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <Label className="text-xs text-muted-foreground">Select Station</Label>
                <Select value={toStation} onValueChange={setToStation} disabled={!toMode}>
                  <SelectTrigger>
                    <SelectValue placeholder={toMode ? "Select Station" : "Select Mode First"} />
                  </SelectTrigger>
                  <SelectContent className="max-h-[300px]">
                    {toStationsFiltered.map((s) => (
                      <SelectItem key={s.id} value={s.id}>
                        {s.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>
          </div>

          <div className="space-y-2 pt-4">
            <Label>Passenger Type</Label>
            <Select value={passengerType} onValueChange={setPassengerType}>
              <SelectTrigger>
                <SelectValue placeholder="Select Type" />
              </SelectTrigger>
              <SelectContent>
                {PASSENGER_TYPES.map((t) => (
                  <SelectItem key={t.value} value={t.value}>{t.label}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <Button 
            className="w-full text-lg py-6" 
            onClick={handleCalculate}
            disabled={!fromStation || !toStation || fromStation === toStation || loading}
          >
            {loading ? "Calculating..." : "Calculate Fare"}
          </Button>
        </CardContent>
      </Card>

      {result && (
        <Card className="w-full shadow-lg border-secondary/50 bg-secondary/10 animate-in fade-in slide-in-from-bottom-4">
          <CardHeader>
            <CardTitle className="text-xl text-primary">Journey Details</CardTitle>
          </CardHeader>
          <CardContent className="space-y-6">
            <div className="flex justify-between items-center border-b pb-4 border-dashed border-primary/30">
              <div>
                <p className="text-sm text-muted-foreground">From</p>
                <p className="font-bold text-lg">{result.from}</p>
              </div>
              <div className="text-2xl text-primary">→</div>
              <div className="text-right">
                <p className="text-sm text-muted-foreground">To</p>
                <p className="font-bold text-lg">{result.to}</p>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="bg-white p-4 rounded-lg shadow-sm">
                <p className="text-sm text-muted-foreground">Total Fare</p>
                <p className="text-3xl font-bold text-primary">RM {result.finalFare}</p>
                {result.discount > 0 && (
                  <p className="text-xs text-green-600 font-medium mt-1">
                    {result.discount}% Discount Applied
                  </p>
                )}
              </div>
              <div className="bg-white p-4 rounded-lg shadow-sm">
                <p className="text-sm text-muted-foreground">Duration</p>
                <p className="text-3xl font-bold text-primary">{result.duration} <span className="text-sm font-normal text-muted-foreground">min</span></p>
              </div>
            </div>

            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">Journey Type</span>
                <span>{result.mode}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">Passenger Type</span>
                <span className="capitalize">{result.passengerType}</span>
              </div>
            </div>
          </CardContent>
          <CardFooter>
            <Button 
              className="w-full bg-green-600 hover:bg-green-700 text-white"
              onClick={handlePay}
              disabled={paying}
            >
              {paying ? "Processing..." : "Pay Now (Simulation)"}
            </Button>
          </CardFooter>
        </Card>
      )}
    </div>
  );
}
