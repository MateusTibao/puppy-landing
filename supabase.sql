-- =====================================================================
-- Puppy | Lista de espera
-- Cole este arquivo inteiro no Supabase: SQL Editor > New query > Run.
-- Pode rodar mais de uma vez sem quebrar nada.
-- =====================================================================

-- 1) Tabela dos cadastros
create table if not exists public.lista_espera (
  id            uuid primary key default gen_random_uuid(),
  created_at    timestamptz not null default now(),
  perfil        text not null check (perfil in ('lojista', 'fornecedor')),
  nome          text not null check (char_length(btrim(nome)) between 2 and 120),
  email         text not null check (char_length(email) <= 254
                                     and email ~* '^[^@\s]+@[^@\s]+\.[^@\s]{2,}$'),
  whatsapp      text not null check (whatsapp ~ '^[0-9]{10,15}$'),
  empresa       text check (empresa  is null or char_length(empresa)  <= 120),
  segmento      text check (segmento is null or char_length(segmento) <= 80),
  cidade        text check (cidade   is null or char_length(cidade)   <= 80),
  origem        text check (origem   is null or char_length(origem)   <= 60),
  consentimento boolean not null check (consentimento = true)
);

-- 2) Um e-mail só pode entrar uma vez (ignora maiúsculas e minúsculas)
create unique index if not exists lista_espera_email_unico
  on public.lista_espera (lower(email));

-- 3) Segurança: a página (papel "anon") só pode INSERIR. Ninguém lê pela internet.
alter table public.lista_espera enable row level security;

revoke all on public.lista_espera from anon, authenticated;
grant insert on public.lista_espera to anon;

drop policy if exists "anon pode se cadastrar" on public.lista_espera;
create policy "anon pode se cadastrar"
  on public.lista_espera
  for insert
  to anon
  with check (true);

-- 4) Função usada pelo ping semanal que evita a pausa do projeto gratuito
create or replace function public.ping()
returns text
language sql
stable
as $$ select 'ok'::text $$;

grant execute on function public.ping() to anon;

-- =====================================================================
-- Para ver os cadastros: Table Editor > lista_espera (ou rode as consultas abaixo).
-- Para baixar: no Table Editor, botão "Export" > CSV.
-- =====================================================================
-- select * from public.lista_espera order by created_at desc;
-- select perfil, count(*) from public.lista_espera group by perfil;
