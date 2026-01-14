import { User } from "./User.ts";
export interface UserRepository {
  register(email: string, password: string): Promise<User>;
  authenticate(
    email: string,
    password: string
  ): Promise<{ user: User; accessToken?: string }>;
  magicLink(email: string): Promise<void>;
  deleteById(id: string): Promise<void>;
}
