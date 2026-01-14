
import { serve } from "https://deno.land/std@0.201.0/http/server.ts";
import { createSupabaseClient } from "../_shared/supabaseClient.ts";
import { SupabaseLeadRepository } from "../_shared/modules/lead/infrastructure/SupabaseLeadRepository.ts";

serve(async (req: Request) => {
  if (req.method !== "DELETE") return new Response(null, { status: 405 });
  try {
    const url = new URL(req.url);
    const id = url.searchParams.get("id");
    if (!id) return new Response(JSON.stringify({ error: "id required" }), { status: 400, headers: { "Content-Type": "application/json" } });
    const supabase = createSupabaseClient(req);
    const repo = new SupabaseLeadRepository(supabase as any);
    await repo.deleteById(id);
    return new Response(null, { status: 204 });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500, headers: { "Content-Type": "application/json" } });
  }
});