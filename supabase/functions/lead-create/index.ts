
import { serve } from "https://deno.land/std@0.201.0/http/server.ts";
import { createSupabaseClient } from "../_shared/supabaseClient.ts";
import { SupabaseLeadRepository } from "../_shared/modules/lead/infrastructure/SupabaseLeadRepository.ts";
import { CreateLead } from "../_shared/modules/lead/application/CreateLead.ts";

serve(async (req: Request) => {
  if (req.method !== "POST") return new Response(null, { status: 405 });
  try {
    const body = await req.json();
    const supabase = createSupabaseClient(req);
    const repo = new SupabaseLeadRepository(supabase as any);
    const useCase = new CreateLead(repo);
    const lead = await useCase.execute(body);
    return new Response(JSON.stringify(lead), { status: 201, headers: { "Content-Type": "application/json" } });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), { status: 400, headers: { "Content-Type": "application/json" } });
  }
});