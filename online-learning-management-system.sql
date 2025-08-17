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
    photo_url varchar(255),
    is_approved boolean default false,
    verification_document varchar(255),  -- Stores file path to uploaded verification document
    department varchar(100),
    bio text,
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
insert into app_user (full_name, email, password_hash, created_at, is_approved, verification_document, bio) values
('alice johnson', 'alice@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true, null, 'Passionate about programming and artificial intelligence. Currently focusing on full-stack development.'),
('bob smith', 'bob@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true, null, 'Interested in cybersecurity and network administration. Always eager to learn new technologies.'),
('charlie davis', 'charlie@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true, null, 'Aspiring software engineer with a passion for clean code and problem-solving.'),
('diana miller', 'diana@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true, null, 'Enthusiastic about data science and machine learning applications.'),
('ethan brown', 'ethan@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true, null, 'Web development enthusiast with a keen interest in user experience design.'),
('fiona wilson', 'fiona@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), false, '/uploads/verification/fiona_id.jpg', 'Computer Science Department - Senior Lecturer with 10+ years of experience in teaching programming fundamentals.'),
('george clark', 'george@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), false, '/uploads/verification/george_id.jpg', 'Information Technology Department - Associate Professor specializing in web technologies and database systems.'),
('hannah lee', 'hannah@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), false, '/uploads/verification/hannah_id.jpg', 'Software Engineering Department - Expert in algorithms and data structures with a passion for teaching.'),
('ian turner', 'ian@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true, null, 'Computer Science Department - Department Head with extensive experience in academic administration and research.'),
('julia harris', 'julia@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true, null, 'Information Systems - Director of Academic Programs focused on technology integration in education.');

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
('Introduction to Programming', 'Learn basics of coding', 'None', 6, now()),
('Advanced Java', 'Deep dive into Java programming', 'Introduction to Programming', 7, now()),
('Web Development', 'HTML, CSS, JS Fundamentals', 'None', 8, now()),
('Database Systems', 'SQL and Database Design', 'Introduction to Programming', 6, now()),
('Data Structures', 'Lists, Stacks, Queues', 'Introduction to Programming', 7, now()),
('Algorithms', 'Sorting, Searching, Graphs', 'Data Structures', 8, now()),
('Operating Systems', 'Processes, Threads, Memory', 'Introduction to Programming', 6, now()),
('Computer Networks', 'Networking Fundamentals', 'Introduction to Programming', 7, now()),
('Cybersecurity Basics', 'Security Principles', 'None', 8, now()),
('Software Engineering', 'SDLC, Agile, Testing', 'Introduction to Programming', 6, now()),
('Mobile App Development', 'Building Cross-Platform Mobile Apps', 'Introduction to Programming', 7, now()),
('Cloud Computing', 'Introduction to Cloud Services and Deployment', 'Introduction to Programming', 8, now()),
('Machine Learning', 'Intro to ML Algorithms and Applications', 'Data Structures', 6, now()),
('Web Security', 'Security Best Practices for Web Applications', 'Web Development', 7, now()),
('DevOps Fundamentals', 'CI/CD, Containers, and Infrastructure as Code', 'Introduction to Programming', 8, now()),
('iOS Development', 'Building iOS Apps with Swift', 'Introduction to Programming', 6, now()),
('Android Development', 'Building Android Apps with Kotlin', 'Introduction to Programming', 7, now()),
('Data Visualization', 'Creating Effective Data Visualizations', 'Introduction to Programming', 8, now()),
('Blockchain Basics', 'Introduction to Blockchain Technology', 'Introduction to Programming', 6, now());

-- ===============================================
-- 5) assignment (10; one per course)
-- ===============================================
insert into assignment (course_id, title, description, due_date) values
(1, 'Hello World Program', 'Write a basic program', '2025-09-01'),
(2, 'Java OOP Project', 'Implement classes and objects', '2025-09-05'),
(3, 'Responsive Webpage', 'Build a responsive HTML/CSS page', '2025-09-10'),
(4, 'ER Diagram', 'Design a database ER diagram', '2025-09-12'),
(5, 'Linked List Implementation', 'Code a linked list', '2025-09-15'),
(6, 'Sorting Algorithms', 'Implement bubble sort and quicksort', '2025-09-18'),
(7, 'Process Scheduling', 'Simulate CPU scheduling', '2025-09-20'),
(8, 'TCP Connection Demo', 'Demonstrate TCP handshake', '2025-09-22'),
(9, 'Password Hashing Demo', 'Explore hashing and salting', '2025-09-25'),
(10, 'Agile Project Plan', 'Create a project backlog', '2025-09-28'),
(11, 'Mobile App Prototype', 'Design and prototype a mobile app', '2025-10-05'),
(12, 'Cloud Deployment Project', 'Deploy an application to the cloud', '2025-10-10'),
(13, 'ML Model Implementation', 'Build and train a simple ML model', '2025-10-15'),
(14, 'Security Audit', 'Perform a security assessment of a web app', '2025-10-20'),
(15, 'CI/CD Pipeline Setup', 'Create a complete CI/CD pipeline', '2025-10-25'),
(16, 'iOS App Feature', 'Implement a key feature in an iOS app', '2025-10-30'),
(17, 'Android App Feature', 'Implement a key feature in an Android app', '2025-11-05'),
(18, 'Data Visualization Project', 'Create interactive data visualizations', '2025-11-10'),
(19, 'Blockchain Demo', 'Create a simple blockchain application', '2025-11-15');
-- Removed assignment for non-existent course 20

-- ===============================================
-- 6) enrollment (20 enrollments; students 1-5 take 2 courses each)
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
(10, 5, now(), 5.00),
(11, 1, now(), 0.00),
(12, 1, now(), 15.00),
(13, 2, now(), 0.00),
(14, 2, now(), 20.00),
(15, 3, now(), 0.00),
(16, 3, now(), 10.00),
(17, 4, now(), 0.00),
(18, 4, now(), 5.00),
(19, 5, now(), 0.00),
(20, 5, now(), 25.00);
