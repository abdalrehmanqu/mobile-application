-- Supabase schema for Digital Library

-- Authors
create table if not exists public.authors (
  id text primary key,
  name text not null,
  profile_image_url text,
  biography text,
  birth_year integer
);

-- Books
create table if not exists public.books (
  id text primary key,
  title text not null,
  author_id text references public.authors(id) on delete set null,
  published_year integer not null,
  category text not null,
  is_available boolean not null default true,
  cover_image_url text,
  description text,
  isbn text,
  page_count integer,
  publisher text
);

-- Members
create table if not exists public.members (
  id text primary key,
  name text not null,
  email text not null unique,
  phone text,
  member_type text not null,
  member_since timestamp with time zone not null default now(),
  profile_image_url text
);

-- Transactions (borrowing)
create table if not exists public.transactions (
  id text primary key,
  member_id text references public.members(id) on delete cascade,
  book_id text references public.books(id) on delete set null,
  borrow_date timestamp with time zone not null,
  due_date timestamp with time zone not null,
  return_date timestamp with time zone,
  is_returned boolean not null default false
);

-- Staff profiles (optional metadata for auth users)
create table if not exists public.staff (
  staff_id text primary key,
  user_id uuid references auth.users(id) on delete cascade,
  username text not null unique,
  full_name text not null,
  role text not null default 'staff'
);

-- Enable Row Level Security
alter table public.authors enable row level security;
alter table public.books enable row level security;
alter table public.members enable row level security;
alter table public.transactions enable row level security;
alter table public.staff enable row level security;

-- Policies: allow authenticated users full CRUD
do $$
declare
  tbl text;
begin
  for tbl in select unnest(array['authors','books','members','transactions','staff']) loop
    if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = tbl and policyname = tbl || '_auth_select') then
      execute format('create policy %I_auth_select on public.%I
        for select using (auth.role() = ''authenticated'');', tbl, tbl);
    end if;

    if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = tbl and policyname = tbl || '_auth_insert') then
      execute format('create policy %I_auth_insert on public.%I
        for insert with check (auth.role() = ''authenticated'');', tbl, tbl);
    end if;

    if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = tbl and policyname = tbl || '_auth_update') then
      execute format('create policy %I_auth_update on public.%I
        for update using (auth.role() = ''authenticated'') with check (auth.role() = ''authenticated'');', tbl, tbl);
    end if;

    if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = tbl and policyname = tbl || '_auth_delete') then
      execute format('create policy %I_auth_delete on public.%I
        for delete using (auth.role() = ''authenticated'');', tbl, tbl);
    end if;
  end loop;
end $$;

-- Seed data generated from assets/data ------------------------------------

-- Authors
insert into public.authors (id, name, profile_image_url, biography, birth_year) values
  ('auth001', 'Dr. Sarah Johnson', null, 'Computer Science Professor at MIT specializing in algorithms and data structures. Published over 50 research papers in top-tier conferences.', 1975),
  ('auth002', 'Prof. Ahmed Al-Zahra', null, 'Software Engineering expert with 20 years of industry experience. Former lead architect at Google and Microsoft.', 1970),
  ('auth003', 'Dr. Maria Rodriguez', null, 'Machine Learning researcher and author of several bestselling AI textbooks. Currently professor at Stanford University.', 1982),
  ('auth004', 'James Thompson', null, 'Tech entrepreneur and author specializing in mobile app development. Founded three successful startups in Silicon Valley.', 1978),
  ('auth005', 'Dr. Fatima Al-Rashid', null, 'Cybersecurity expert and consultant for Fortune 500 companies. Author of multiple books on network security and cryptography.', 1973),
  ('auth006', 'Michael Chen', null, 'Database systems architect and performance optimization specialist. Has designed systems handling millions of transactions daily.', 1985),
  ('auth007', 'Dr. Lisa Williams', null, 'Human-Computer Interaction researcher focusing on user experience design and accessibility in digital systems.', 1980)
on conflict (id) do nothing;

-- Books
insert into public.books (id, title, author_id, published_year, category, is_available, cover_image_url, description, isbn, page_count, publisher) values
  ('book001', 'Advanced Data Structures and Algorithms', 'auth001', 2023, 'Computer Science', true, null, 'Comprehensive guide to advanced data structures including trees, graphs, and hash tables with practical implementations in multiple programming languages.', '978-1234567890', 450, 'Tech Academic Press'),
  ('book002', 'Software Engineering Principles', 'auth002', 2022, 'Software Engineering', true, null, 'Best practices in software development, covering design patterns, testing methodologies, and project management techniques.', '978-2345678901', 380, 'Engineering Publications'),
  ('book003', 'Machine Learning Fundamentals', 'auth003', 2024, 'Artificial Intelligence', false, null, 'Introduction to machine learning concepts, supervised and unsupervised learning, with hands-on examples using Python.', '978-3456789012', 520, 'AI Research Press'),
  ('book004', 'Mobile App Development with Flutter', 'auth004', 2023, 'Mobile Development', false, null, 'Complete guide to building cross-platform mobile applications using Flutter framework, from basics to advanced topics.', '978-4567890123', 620, 'Mobile Tech Books'),
  ('book005', 'Cybersecurity in the Digital Age', 'auth005', 2023, 'Cybersecurity', false, null, 'Modern approaches to cybersecurity, covering threat detection, incident response, and security architecture design.', '978-5678901234', 410, 'Security Press International'),
  ('book006', 'Database Systems Design and Implementation', 'auth006', 2022, 'Database Systems', false, null, 'Comprehensive coverage of database design principles, normalization, query optimization, and distributed database systems.', '978-6789012345', 550, 'Data Science Publications'),
  ('book007', 'User Experience Design Principles', 'auth007', 2024, 'Design', false, null, 'Essential principles of UX design, user research methodologies, and creating accessible digital interfaces.', '978-7890123456', 320, 'Design Innovations Press'),
  ('book008', 'Advanced Software Architecture', 'auth001', 2023, 'Software Engineering', false, null, 'Exploration of architectural patterns, microservices, and scalable system design for enterprise applications.', '978-8901234567', 475, 'Architecture Today')
on conflict (id) do nothing;

-- Members
insert into public.members (id, name, email, phone, member_type, member_since, profile_image_url) values
  ('M001', 'Ahmed Al-Rashid', 'ahmed.alrashid@qu.edu.qa', '+974-5512-3456', 'student', '2024-01-15T00:00:00.000Z', null),
  ('M002', 'Fatima Al-Kuwari', 'fatima.alkuwari@qu.edu.qa', '+974-5523-4567', 'student', '2024-02-01T00:00:00.000Z', null),
  ('M003', 'Omar Hassan', 'omar.hassan@qu.edu.qa', '+974-5534-5678', 'student', '2023-09-10T00:00:00.000Z', null),
  ('M004', 'Noor Al-Thani', 'noor.althani@qu.edu.qa', '+974-5545-6789', 'student', '2024-01-20T00:00:00.000Z', null),
  ('M005', 'Dr. Khalid Ibrahim', 'khalid.ibrahim@qu.edu.qa', '+974-4403-1234', 'faculty', '2020-08-01T00:00:00.000Z', null),
  ('M006', 'Prof. Maryam Al-Mansoori', 'maryam.almansoori@qu.edu.qa', '+974-4403-2345', 'faculty', '2018-09-01T00:00:00.000Z', null)
on conflict (id) do nothing;

-- Staff (optional; requires table to exist)
insert into public.staff (staff_id, user_id, username, full_name, role) values
  ('S001', null, 'admin', 'Ahmed Al-Thani', 'Administrator'),
  ('S002', null, 'librarian', 'Fatima Al-Kuwari', 'Librarian'),
  ('S003', null, 'staff', 'Mohammed Al-Dosari', 'Library Staff')
on conflict (staff_id) do nothing;

-- Transactions
insert into public.transactions (id, member_id, book_id, borrow_date, due_date, return_date, is_returned) values
  ('T001', 'M001', 'book001', '2024-10-15T10:00:00.000Z', '2024-10-29T23:59:59.000Z', '2024-10-28T14:30:00.000Z', true),
  ('T002', 'M002', 'book003', '2024-10-20T09:15:00.000Z', '2024-11-03T23:59:59.000Z', null, false),
  ('T003', 'M003', 'book005', '2024-10-05T11:00:00.000Z', '2024-10-19T23:59:59.000Z', null, false),
  ('T004', 'M001', 'book007', '2024-10-25T13:45:00.000Z', '2024-11-08T23:59:59.000Z', null, false),
  ('T005', 'M004', 'book002', '2024-10-18T08:30:00.000Z', '2024-11-01T23:59:59.000Z', '2024-11-02T10:15:00.000Z', true),
  ('T006', 'M005', 'book006', '2024-09-15T14:20:00.000Z', '2024-10-15T23:59:59.000Z', null, false),
  ('T007', 'M002', 'book004', '2024-10-22T10:00:00.000Z', '2024-11-05T23:59:59.000Z', null, false),
  ('T008', 'M006', 'book008', '2024-10-10T15:30:00.000Z', '2024-11-09T23:59:59.000Z', null, false)
on conflict (id) do nothing;
