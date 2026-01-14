import { UserRepository } from "../domain/UserRepository.ts";
export class AuthUser {
  constructor(private repo: UserRepository) {}
  async signIn(dto: { email: string; password: string }) {
    if (!dto.password) throw new Error("Password required");
    return await this.repo.authenticate(dto.email, dto.password);
  }
  async signUp(dto: { email: string; password: string }) {
    if (!dto.password) throw new Error("Password required");
    return await this.repo.authenticate(dto.email, dto.password);
  }
  async magic(dto: { email: string }) {
    return await this.repo.magicLink(dto.email);
  }
  async delete(id: string) {
    return await this.repo.deleteById(id);
  }
}
