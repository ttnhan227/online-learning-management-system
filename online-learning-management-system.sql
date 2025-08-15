-- ===============================================
-- LMS core schema: auth + course + assignment + enrollment
-- ===============================================

begin;

-- 1) role
create table role (
    role_id serial primary key,
    role_name varchar(50) not null unique
);

-- 2) app_user  (renamed from 'user' to avoid reserved word)
create table app_user (
    user_id serial primary key,
    full_name varchar(100) not null,
    email varchar(100) not null unique,
    password_hash varchar(255) not null,
    created_at timestamptz not null default now()
);

-- 3) user_role (many-to-many between app_user and role)
create table user_role (
    user_role_id serial primary key,
    user_id int not null,
    role_id int not null,
    constraint fk_userrole_user foreign key (user_id)
        references app_user(user_id) on delete cascade,
    constraint fk_userrole_role foreign key (role_id)
        references role(role_id) on delete cascade,
    constraint uq_userrole unique (user_id, role_id)
);

-- 4) course
create table course (
    course_id serial primary key,
    title varchar(255) not null,
    description text,
    prerequisites text,
    instructor_id int,
    created_at timestamptz not null default now(),
    constraint fk_course_instructor foreign key (instructor_id)
        references app_user(user_id) on delete set null
);

-- 5) assignment
create table assignment (
    assignment_id serial primary key,
    course_id int not null,
    title varchar(255) not null,
    description text,
    due_date date,
    constraint fk_assignment_course foreign key (course_id)
        references course(course_id) on delete cascade
);

-- 6) enrollment
create table enrollment (
    enrollment_id serial primary key,
    course_id int not null,
    student_id int not null,
    enrolled_at timestamptz not null default now(),
    progress numeric(5,2) default 0.00,
    constraint fk_enrollment_course foreign key (course_id)
        references course(course_id) on delete cascade,
    constraint fk_enrollment_student foreign key (student_id)
        references app_user(user_id) on delete cascade,
    constraint chk_enrollment_progress check (progress >= 0 and progress <= 100),
    constraint uq_enrollment unique (course_id, student_id)
);

-- indexes for better performance
create index idx_userrole_user_id on user_role(user_id);
create index idx_userrole_role_id on user_role(role_id);
create index idx_course_instructor on course(instructor_id);
create index idx_assignment_course on assignment(course_id);
create index idx_enrollment_course on enrollment(course_id);
create index idx_enrollment_student on enrollment(student_id);

commit;

-- ===============================================
-- 1) role (10 rows)
-- ===============================================
insert into role (role_name) values
('student'),
('instructor'),
('administrator');

-- ===============================================
-- 2) app_user (10 users, password 123)
-- ===============================================
insert into app_user (full_name, email, password_hash, created_at) values
('alice johnson', 'alice@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now()),
('bob smith', 'bob@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now()),
('charlie davis', 'charlie@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now()),
('diana miller', 'diana@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now()),
('ethan brown', 'ethan@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now()),
('fiona wilson', 'fiona@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now()),
('george clark', 'george@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now()),
('hannah lee', 'hannah@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now()),
('ian turner', 'ian@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now()),
('julia harris', 'julia@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now());

-- ===============================================
-- 3) user_role (10 links; users 1-5 students, 6-8 instructors, 9-10 admins)
-- ===============================================
insert into user_role (user_id, role_id) values
(1, 1),  -- student
(2, 1),  -- student
(3, 1),  -- student
(4, 1),  -- student
(5, 1),  -- student
(6, 2),  -- instructor
(7, 2),  -- instructor
(8, 2),  -- instructor
(9, 3),  -- admin
(10, 3); -- admin

-- ===============================================
-- 4) course (10 courses) owned by instructors (users 6-8)
-- ===============================================
insert into course (title, description, prerequisites, instructor_id, created_at) values
('intro to programming', 'learn basics of coding', 'none', 6, now()),
('advanced java', 'deep dive into java', 'intro to programming', 7, now()),
('web development', 'html, css, js fundamentals', 'none', 8, now()),
('database systems', 'sql and database design', 'intro to programming', 6, now()),
('data structures', 'lists, stacks, queues', 'intro to programming', 7, now()),
('algorithms', 'sorting, searching, graphs', 'data structures', 8, now()),
('operating systems', 'processes, threads, memory', 'intro to programming', 6, now()),
('computer networks', 'networking fundamentals', 'intro to programming', 7, now()),
('cybersecurity basics', 'security principles', 'none', 8, now()),
('software engineering', 'sdlc, agile, testing', 'intro to programming', 6, now());

-- ===============================================
-- 5) assignment (10; one per course)
-- ===============================================
insert into assignment (course_id, title, description, due_date) values
(1, 'hello world program', 'write a basic program', '2025-09-01'),
(2, 'java oop project', 'implement classes and objects', '2025-09-05'),
(3, 'responsive webpage', 'build a responsive html/css page', '2025-09-10'),
(4, 'er diagram', 'design a database er diagram', '2025-09-12'),
(5, 'linked list implementation', 'code a linked list', '2025-09-15'),
(6, 'sorting algorithms', 'implement bubble sort and quicksort', '2025-09-18'),
(7, 'process scheduling', 'simulate cpu scheduling', '2025-09-20'),
(8, 'tcp connection demo', 'demonstrate tcp handshake', '2025-09-22'),
(9, 'password hashing demo', 'explore hashing and salting', '2025-09-25'),
(10, 'agile project plan', 'create a project backlog', '2025-09-28');

-- ===============================================
-- 6) enrollment (10 enrollments; students 1-5 take 2 courses each)
-- ===============================================
insert into enrollment (course_id, student_id, enrolled_at, progress) values
(1, 1, now(), 20.00),
(2, 1, now(), 0.00),
(3, 2, now(), 50.00),
(4, 2, now(), 10.00),
(5, 3, now(), 0.00),
(6, 3, now(), 30.00),
(7, 4, now(), 40.00),
(8, 4, now(), 15.00),
(9, 5, now(), 60.00),
(10, 5, now(), 5.00);
