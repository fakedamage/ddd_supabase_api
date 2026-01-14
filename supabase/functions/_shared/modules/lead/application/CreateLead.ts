import { LeadRepository } from "../domain/LeadRepository.ts";
import { Lead } from "../domain/Lead.ts";

export class CreateLead {
  constructor(private repo: LeadRepository) {}

  async execute(dto: {
    name: string;
    email: string;
    phone?: string | null;
    need: any;
  }) {
    const exists = await this.repo.findByEmail(dto.email);
    if (exists) throw new Error("Lead already exists");
    const lead = Lead.create({
      name: dto.name,
      email: dto.email,
      phone: dto.phone ?? null,
      need: dto.need,
    });
    await this.repo.save(lead);
    return lead;
  }
}
