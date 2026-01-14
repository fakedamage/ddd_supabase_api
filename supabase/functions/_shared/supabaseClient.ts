
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

export function createSupabaseClient(req?: Request) {
  const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
  const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!;

  const headers: Record<string, string> = {};
  if (req) {
    const auth = req.headers.get("authorization");
    if (auth) headers["Authorization"] = auth;
  }

  return createClient(SUPABASE_URL, SUPABASE_ANON_KEY, { global: { headers } });
}