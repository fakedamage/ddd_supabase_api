import { UserRepository } from "../domain/UserRepository.ts";
export class RegisterUser {
  constructor(private repo: UserRepository) {}
  async execute(dto: { email: string; password: string }) {
    if (!dto.email.includes("@")) throw new Error("Invalid email");
    if (!dto.password || dto.password.length < 6)
      throw new Error("Password too short");
    return await this.repo.register(dto.email, dto.password);
  }
}
