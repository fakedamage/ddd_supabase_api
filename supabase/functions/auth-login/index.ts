
import { serve } from "https://deno.land/std@0.201.0/http/server.ts";
import { createSupabaseClient } from "../_shared/supabaseClient.ts";
import { SupabaseUserRepository } from "../_shared/modules/user/infrastructure/SupabaseUserRepository.ts";

serve(async (req: Request) => {
  if (req.method !== "POST") return new Response(null, { status: 405 });
  try {
    const body = await req.json();
    const supabase = createSupabaseClient();
    const repo = new SupabaseUserRepository(supabase as any);
    const result = await repo.authenticate(body.email, body.password);
    return new Response(JSON.stringify(result), { status: 200, headers: { "Content-Type": "application/json" } });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), { status: 401, headers: { "Content-Type": "application/json" } });
  }
});