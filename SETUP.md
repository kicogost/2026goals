# 2026 Goals — setup

The app is built. It runs in two modes automatically:

- **Local-only** (right now): saves checkmarks on whatever device you open it, no login. Good for a quick look.
- **Synced** (after the 4 steps below): one shared login, and every tick syncs live between all your devices via Supabase.

Follow the steps once, send me the 3 values at the end, and I'll flip it into synced mode and deploy it to Vercel.

---

## Step 1 — Create the Supabase project (~3 min)

1. Go to **https://supabase.com** → sign in (GitHub login is easiest) → **New project**.
2. Name it anything (e.g. `goals-2026`), pick a strong database password (you won't need it day-to-day), choose the region closest to you (e.g. *West EU (Ireland)*), and create it.
3. Wait ~1 minute for it to finish provisioning.

## Step 2 — Create the table + turn on sync

1. In the left sidebar open **SQL Editor** → **New query**.
2. Paste everything below and click **Run**. (It's also saved in `schema.sql` in this folder.)

```sql
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
```

You should see "Success. No rows returned."

## Step 3 — Create your one shared login

1. Left sidebar → **Authentication** → **Users** → **Add user** → **Create new user**.
2. Use an email you'll both remember (your own is fine, e.g. `francisco@rallyup.team`) and a password you'll **both** share — this is the password you'll type to open the app.
3. **Tick "Auto Confirm User"** (important — otherwise it'll wait for an email confirmation).
4. Click **Create user**.

## Step 4 — Grab your keys

1. Left sidebar → **Project Settings** (gear) → **API**.
2. Copy two things:
   - **Project URL** — looks like `https://abcdefgh.supabase.co`
   - **anon public** key — the long one labelled `anon` / `public` (NOT the `service_role` one)

> The `anon` key is safe to ship in the app — the table is protected by the login + Row-Level Security, so without your shared password nobody can read anything.

---

## Then send me:

1. **Project URL**
2. **anon public key**
3. **The email** you used for the shared login (step 3)

I'll drop them into the app, double-check it, and deploy it to Vercel so you both get a single link that works on phone and laptop. You'll log in once per device and never again.
