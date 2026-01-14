-- ENUM: tipo de necessidade do lead
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'lead_need') THEN
    CREATE TYPE lead_need AS ENUM (
      'INSTITUTIONAL_FILMS',
      'CORPORATE_EVENTS',
      'CONTENT_FILMS'
    );
  END IF;
END$$;

-- UUID generator
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Tabela leads
CREATE TABLE IF NOT EXISTS public.leads (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name text NOT NULL,
  email text NOT NULL,
  phone text,
  need lead_need NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- RLS
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "allow_public_insert" ON public.leads;

CREATE POLICY "allow_public_insert"
  ON public.leads
  FOR INSERT
  WITH CHECK (true);

-- SELECT somente autenticado
CREATE POLICY "allow_select_authenticated"
  ON public.leads
  FOR SELECT
  USING (auth.role() = 'authenticated');
