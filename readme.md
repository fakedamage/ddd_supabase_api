# Supabase API – Motin Films

Este repositório contém a **configuração da API e do banco de dados no Supabase** utilizada pelo projeto Motin Films, responsável por **autenticação de usuários**, **persistência de dados** e **segurança via RLS (Row Level Security)**.

---

## 📌 Visão Geral

A API Supabase fornece:
- 🔐 **Autenticação de usuários**
  - Cadastro com e-mail e senha
  - Login via **Magic Link**
- 📊 **Persistência de dados** (PostgreSQL)
- 🛡 **Segurança com Row Level Security (RLS)**
- ⚡ Integração direta com aplicações **Next.js**

---

## 🧱 Estrutura de Dados

### Tabela `leads`
Responsável por armazenar os leads captados pelo site.

Campos principais:
- `id` (uuid, primary key)
- `name` (text)
- `email` (text)
- `phone` (text, nullable)
- `need` (text / enum)
- `created_at` (timestamp)

---

## 🔐 Autenticação (Auth)

O Supabase Auth é utilizado para gerenciamento de usuários.

### Métodos suportados
- **Email + senha**
- **Magic Link (OTP)**

### Fluxo Magic Link
1. Usuário informa o e-mail no frontend
2. Supabase envia um link de verificação
3. Ao clicar no link:
   - O token é validado
   - A sessão é criada automaticamente
   - O usuário é redirecionado para `/auth/callback`
4. O frontend troca o `code` por uma sessão válida e redireciona para o dashboard

---

## 🛡 Segurança – Row Level Security (RLS)

O projeto utiliza **RLS** para garantir acesso seguro aos dados.

### Políticas aplicadas
- **INSERT público** para captação de leads
- **SELECT protegido** (somente usuários autenticados)
- **DELETE protegido** (somente usuários autenticados)
- Operações administrativas realizadas via **Service Role** apenas no backend

---

## ⚙️ Variáveis de Ambiente

As seguintes variáveis devem ser configuradas no Supabase e no projeto Next.js:

### Server (API / Backend)
```env
SUPABASE_URL=https://<project-ref>.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
