-- ============================================================
-- Student Dashboard - Supabase RLS Policies & Setup
-- Run this in Supabase Dashboard -> SQL Editor
-- ============================================================

-- 1. Ensure tables exist with correct structure
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY,  -- matches auth.users.id
  email TEXT,
  name TEXT,
  role TEXT DEFAULT 'user',
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.students (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT,
  email TEXT,
  course TEXT,
  student_code TEXT UNIQUE,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.complaints (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES students(id) ON DELETE CASCADE,
  message TEXT,
  status TEXT DEFAULT 'Pending',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.complaints ENABLE ROW LEVEL SECURITY;

-- 3. Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "Profiles select" ON public.profiles;
DROP POLICY IF EXISTS "Profiles insert" ON public.profiles;
DROP POLICY IF EXISTS "Students select" ON public.students;
DROP POLICY IF EXISTS "Students insert" ON public.students;
DROP POLICY IF EXISTS "Students update" ON public.students;
DROP POLICY IF EXISTS "Students delete" ON public.students;
DROP POLICY IF EXISTS "Complaints select" ON public.complaints;
DROP POLICY IF EXISTS "Complaints insert" ON public.complaints;
DROP POLICY IF EXISTS "Complaints update" ON public.complaints;

-- 4. Profiles policies
CREATE POLICY "Profiles select"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Profiles insert"
  ON public.profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- 5. Students policies (full access for authenticated users)
CREATE POLICY "Students select"
  ON public.students FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Students insert"
  ON public.students FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Students update"
  ON public.students FOR UPDATE
  TO authenticated
  USING (true);

CREATE POLICY "Students delete"
  ON public.students FOR DELETE
  TO authenticated
  USING (true);

-- 6. Complaints policies
CREATE POLICY "Complaints select"
  ON public.complaints FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Complaints insert"
  ON public.complaints FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Complaints update"
  ON public.complaints FOR UPDATE
  TO authenticated
  USING (true);

-- 7. Set your admin email role (CHANGE TO YOUR ACTUAL ADMIN EMAIL)
UPDATE public.profiles
SET role = 'admin'
WHERE email = 'developersohrab5564@gmail.com';

-- 8. Verify admin role is set
SELECT * FROM public.profiles WHERE role = 'admin';
