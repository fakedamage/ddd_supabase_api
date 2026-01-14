
import { serve } from "https://deno.land/std@0.201.0/http/server.ts";
import { createSupabaseClient } from "../_shared/supabaseClient.ts";
import { SupabaseUserRepository } from "../_shared/modules/user/infrastructure/SupabaseUserRepository.ts";
import { RegisterUser } from "../_shared/modules/user/application/RegisterUser.ts";

serve(async (req: Request) => {
  if (req.method !== "POST") return new Response(null, { status: 405 });
  try {
    const body = await req.json();
    const supabase = createSupabaseClient(); // signup uses anon key
    const repo = new SupabaseUserRepository(supabase as any);
    const useCase = new RegisterUser(repo);
    const user = await useCase.execute(body);
    return new Response(JSON.stringify(user), { status: 201, headers: { "Content-Type": "application/json" } });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), { status: 400, headers: { "Content-Type": "application/json" } });
  }
});