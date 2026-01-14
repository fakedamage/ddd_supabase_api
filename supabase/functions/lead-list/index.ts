
import { serve } from "https://deno.land/std@0.201.0/http/server.ts";
import { createSupabaseClient } from "../_shared/supabaseClient.ts";
import { SupabaseLeadRepository } from "../_shared/modules/lead/infrastructure/SupabaseLeadRepository.ts";

serve(async (req: Request) => {
  if (req.method !== "GET") return new Response(null, { status: 405 });
  try {
    const supabase = createSupabaseClient(req);
    const repo = new SupabaseLeadRepository(supabase as any);
    const rows = await repo.list();
    return new Response(JSON.stringify(rows), { status: 200, headers: { "Content-Type": "application/json" } });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), { status: 401, headers: { "Content-Type": "application/json" } });
  }
});