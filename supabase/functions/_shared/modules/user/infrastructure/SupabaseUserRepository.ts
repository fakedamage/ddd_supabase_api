import { HttpClient } from "../../../HttpClient.ts";
import { UserRepository } from "../domain/UserRepository.ts";
import { User } from "../domain/User.ts";
import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";

export class SupabaseUserRepository implements UserRepository {
  private http: HttpClient;
  private supabase: SupabaseClient;
  constructor(supabase: SupabaseClient) {
    this.supabase = supabase;
    this.http = new HttpClient(supabase as any);
  }

  async register(email: string, password: string) {
    const { data, error } = await this.supabase.auth.signUp({
      email,
      password,
    });
    if (error) throw error;
    const u = (data as any).user ?? data;
    return User.fromAuthUser(u);
  }

  async authenticate(email: string, password: string) {
    const { data, error } = await this.supabase.auth.signInWithPassword({
      email,
      password,
    });
    if (error) throw error;
    const user = (data as any).user;
    const session = (data as any).session;
    return {
      user: User.fromAuthUser(user),
      accessToken: session?.access_token,
    };
  }

  async magicLink(email: string) {
    await this.http.sendMagicLink(email);
  }

  async deleteById(id: string) {
    throw new Error(
      "deleteUser requires admin privileges; call from server with service_role key"
    );
  }
}
