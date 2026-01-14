export type LeadNeed =
  | "INSTITUTIONAL_FILMS"
  | "CORPORATE_EVENTS"
  | "CONTENT_FILMS";

export class Lead {
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly email: string,
    public readonly phone: string | null,
    public readonly need: LeadNeed,
    public readonly createdAt: string
  ) {}

  static create(payload: {
    name: string;
    email: string;
    phone?: string | null;
    need: LeadNeed;
  }) {
    if (!payload.email || !payload.email.includes("@"))
      throw new Error("Invalid email");
    if (!payload.name || payload.name.trim().length < 2)
      throw new Error("Invalid name");
    return new Lead(
      crypto.randomUUID(),
      payload.name,
      payload.email,
      payload.phone ?? null,
      payload.need,
      new Date().toISOString()
    );
  }

  static fromPersistence(row: any) {
    return new Lead(
      row.id,
      row.name,
      row.email,
      row.phone ?? null,
      row.need,
      row.created_at
    );
  }
}
