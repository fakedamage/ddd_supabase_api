export class User {
  constructor(
    public readonly id: string,
    public readonly email: string,
    public readonly createdAt: string
  ) {}
  static fromAuthUser(u: any) {
    return new User(u.id, u.email, u.created_at ?? new Date().toISOString());
  }
}
