-- Run this once in the Supabase SQL Editor (see SETUP.md, step 2).

-- One row per completed goal (a row existing = that goal is checked)
create table public.goal_state (
  goal_id text primary key,
  updated_at timestamptz not null default now()
);

-- Lock the table down
alter table public.goal_state enable row level security;

-- Only your shared logged-in account can read/write
create policy "shared account full access"
  on public.goal_state
  for all
  to authenticated
  using (true)
  with check (true);

-- Turn on live sync for this table
alter publication supabase_realtime add table public.goal_state;
