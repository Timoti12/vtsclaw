-- Skema database VTS-CLAW (Supabase / Postgres)
create schema if not exists private;
revoke all on schema private from public, anon, authenticated;
grant usage on schema private to authenticated;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nama text not null check (char_length(nama) between 2 and 120),
  institusi text not null check (char_length(institusi) between 2 and 200),
  email text not null,
  role text not null default 'user' check (role in ('user','developer')),
  created_at timestamptz not null default now()
);
alter table public.profiles enable row level security;

create or replace function private.is_developer()
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.profiles where id = (select auth.uid()) and role = 'developer');
$$;
revoke all on function private.is_developer() from public, anon;
grant execute on function private.is_developer() to authenticated;

create policy "profil sendiri atau developer dapat membaca"
on public.profiles for select to authenticated
using ( (select auth.uid()) = id or (select private.is_developer()) );

create policy "ubah profil sendiri"
on public.profiles for update to authenticated
using ( (select auth.uid()) = id )
with check ( (select auth.uid()) = id );

revoke all on public.profiles from anon, authenticated;
grant select on public.profiles to authenticated;
grant update (nama, institusi) on public.profiles to authenticated;  -- role tidak bisa diubah dari klien

create or replace function private.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, nama, institusi, email, role)
  values (new.id,
    coalesce(nullif(trim(new.raw_user_meta_data->>'nama'), ''), 'Tanpa Nama'),
    coalesce(nullif(trim(new.raw_user_meta_data->>'institusi'), ''), '-'),
    new.email, 'user');
  return new;
end;
$$;
revoke all on function private.handle_new_user() from public, anon, authenticated;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function private.handle_new_user();

create index profiles_role_idx on public.profiles (role) where role = 'developer';

-- Menjadikan akun sebagai developer (jalankan manual di SQL Editor, ganti emailnya):
-- update public.profiles set role = 'developer' where email = 'EMAIL_ANDA';
