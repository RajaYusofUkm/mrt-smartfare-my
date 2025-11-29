import { FareForm } from "@/components/calculator/FareForm";

export default function Home() {
  return (
    <div className="space-y-12">
      <section className="text-center space-y-4 py-12">
        <h1 className="text-4xl md:text-6xl font-bold text-primary tracking-tight">
          Smart Travel, <span className="text-secondary-foreground">Better Fares</span>
        </h1>
        <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
          Calculate your MRT, LRT, and Monorail fares instantly. Plan your journey and save with our smart fare calculator.
        </p>
      </section>

      <section className="max-w-5xl mx-auto">
        <FareForm />
      </section>
    </div>
  );
}
