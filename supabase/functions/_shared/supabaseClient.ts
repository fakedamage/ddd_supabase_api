
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

export function createSupabaseClient(req?: Request) {
  const NEXT_PUBLIC_SUPABASE_URL = Deno.env.get("NEXT_PUBLIC_SUPABASE_URL")!;
  const NEXT_PUBLIC_SUPABASE_ANON_KEY = Deno.env.get("NEXT_PUBLIC_SUPABASE_ANON_KEY")!;

  const headers: Record<string, string> = {};
  if (req) {
    const auth = req.headers.get("authorization");
    if (auth) headers["Authorization"] = auth;
  }

  return createClient(NEXT_PUBLIC_SUPABASE_URL, NEXT_PUBLIC_SUPABASE_ANON_KEY, { global: { headers } });
}