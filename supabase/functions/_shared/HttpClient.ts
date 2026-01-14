
import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";

export class HttpClient {
  constructor(private supabase: SupabaseClient) {}

  async insert(table: string, payload: any) {
    const { data, error } = await this.supabase.from(table).insert(payload);
    if (error) throw error;
    return data;
  }

  async select(table: string, opts?: { eq?: Record<string, any>; single?: boolean }) {
    let q: any = this.supabase.from(table).select("*");
    if (opts?.eq) for (const [k, v] of Object.entries(opts.eq)) q = q.eq(k, v as any);
    if (opts?.single) q = q.single();
    const { data, error } = await q;
    if (error) throw error;
    return data;
  }

  async delete(table: string, eq: Record<string, any>) {
    let q: any = this.supabase.from(table).delete();
    for (const [k, v] of Object.entries(eq)) q = q.eq(k, v as any);
    const { data, error } = await q;
    if (error) throw error;
    return data;
  }

  // Auth helpers (use with care: service_role not available in edge runtime)
  async signUp(email: string, password: string) {
    const { data, error } = await this.supabase.auth.signUp({ email, password });
    if (error) throw error;
    return data;
  }

  async signIn(email: string, password: string) {
    const { data, error } = await this.supabase.auth.signInWithPassword({ email, password });
    if (error) throw error;
    return data;
  }

  async sendMagicLink(email: string) {
    const { data, error } = await this.supabase.auth.signInWithOtp({ email });
    if (error) throw error;
    return data;
  }
} 