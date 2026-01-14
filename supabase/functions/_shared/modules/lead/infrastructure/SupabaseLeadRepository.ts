import { HttpClient } from "../../../HttpClient.ts";
import { Lead } from "../domain/Lead.ts";
import { LeadRepository } from "../domain/LeadRepository.ts";

import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";

export class SupabaseLeadRepository implements LeadRepository {
  private http: HttpClient;
  constructor(private supabase: SupabaseClient) {
    this.http = new HttpClient(supabase as any);
  }

  async save(lead: Lead): Promise<void> {
    await this.http.insert("leads", {
      id: lead.id,
      name: lead.name,
      email: lead.email,
      phone: lead.phone,
      need: lead.need,
    });
  }

  async list(): Promise<Lead[]> {
    const rows = await this.http.select("leads");
    return (rows || []).map((r: any) => Lead.fromPersistence(r));
  }

  async findByEmail(email: string): Promise<Lead | null> {
    const row = await this.http.select("leads", {
      eq: { email },
      single: true,
    });
    return row ? Lead.fromPersistence(row) : null;
  }

  async deleteById(id: string): Promise<void> {
    await this.http.delete("leads", { id });
  }
}
