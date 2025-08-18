-- ===============================================
-- LMS core schema: auth + course + assignment + enrollment
-- Fixed: add missing 20th course so FKs (assignment/enrollment) succeed
-- ===============================================

BEGIN;

-- ----- reset (optional but helpful for reruns) -----
DROP TABLE IF EXISTS enrollment CASCADE;
DROP TABLE IF EXISTS assignment CASCADE;
DROP TABLE IF EXISTS course CASCADE;
DROP TABLE IF EXISTS user_role CASCADE;
DROP TABLE IF EXISTS app_user CASCADE;
DROP TABLE IF EXISTS role CASCADE;

-- 1) role
CREATE TABLE role (
    role_id     SERIAL PRIMARY KEY,
    role_name   VARCHAR(50) NOT NULL UNIQUE
);

-- 2) app_user  (renamed from 'user' to avoid reserved word)
CREATE TABLE app_user (
    user_id                 SERIAL PRIMARY KEY,
    full_name               VARCHAR(100) NOT NULL,
    email                   VARCHAR(100) NOT NULL UNIQUE,
    password_hash           VARCHAR(255) NOT NULL,
    photo_url               VARCHAR(255),
    is_approved             BOOLEAN DEFAULT FALSE,
    verification_document   VARCHAR(255),  -- path to uploaded verification document
    department              VARCHAR(100),
    bio                     TEXT,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3) user_role (many-to-many between app_user and role)
CREATE TABLE user_role (
    user_role_id    SERIAL PRIMARY KEY,
    user_id         INT NOT NULL,
    role_id         INT NOT NULL,
    CONSTRAINT fk_userrole_user FOREIGN KEY (user_id)
        REFERENCES app_user(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_userrole_role FOREIGN KEY (role_id)
        REFERENCES role(role_id) ON DELETE CASCADE,
    CONSTRAINT uq_userrole UNIQUE (user_id, role_id)
);

-- 4) course
CREATE TABLE course (
    course_id       SERIAL PRIMARY KEY,
    title           VARCHAR(255) NOT NULL,
    description     TEXT,
    prerequisites   TEXT,
    instructor_id   INT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT fk_course_instructor FOREIGN KEY (instructor_id)
        REFERENCES app_user(user_id) ON DELETE SET NULL
);

-- 5) assignment
CREATE TABLE assignment (
    assignment_id   SERIAL PRIMARY KEY,
    course_id       INT NOT NULL,
    title           VARCHAR(255) NOT NULL,
    description     TEXT,
    due_date        DATE,
    CONSTRAINT fk_assignment_course FOREIGN KEY (course_id)
        REFERENCES course(course_id) ON DELETE CASCADE
);

-- 6) enrollment
CREATE TABLE enrollment (
    enrollment_id   SERIAL PRIMARY KEY,
    course_id       INT NOT NULL,
    student_id      INT NOT NULL,
    enrolled_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    progress        NUMERIC(5,2) DEFAULT 0.00,
    CONSTRAINT fk_enrollment_course FOREIGN KEY (course_id)
        REFERENCES course(course_id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id)
        REFERENCES app_user(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_enrollment_progress CHECK (progress >= 0 AND progress <= 100),
    CONSTRAINT uq_enrollment UNIQUE (course_id, student_id)
);

-- indexes for better performance
CREATE INDEX idx_userrole_user_id   ON user_role(user_id);
CREATE INDEX idx_userrole_role_id   ON user_role(role_id);
CREATE INDEX idx_course_instructor  ON course(instructor_id);
CREATE INDEX idx_assignment_course  ON assignment(course_id);
CREATE INDEX idx_enrollment_course  ON enrollment(course_id);
CREATE INDEX idx_enrollment_student ON enrollment(student_id);

COMMIT;

-- ===============================================
-- 1) role (3 rows)
-- ===============================================
INSERT INTO role (role_name) VALUES
('student'),
('instructor'),
('administrator');

-- ===============================================
-- 2) app_user (10 users, password = "123" bcrypt)
-- ===============================================
INSERT INTO app_user (full_name, email, password_hash, created_at, is_approved, verification_document, bio) VALUES
('Alice Johnson', 'alice@example.com',   '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true,  NULL,                              'Passionate about programming and artificial intelligence. Currently focusing on full-stack development.'),
('Bob Smith',     'bob@example.com',     '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true,  NULL,                              'Interested in cybersecurity and network administration. Always eager to learn new technologies.'),
('Charlie Davis', 'charlie@example.com', '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true,  NULL,                              'Aspiring software engineer with a passion for clean code and problem-solving.'),
('Diana Miller',  'diana@example.com',   '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true,  NULL,                              'Enthusiastic about data science and machine learning applications.'),
('Ethan Brown',   'ethan@example.com',   '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true,  NULL,                              'Web development enthusiast with a keen interest in user experience design.'),
('Fiona Wilson',  'fiona@example.com',   '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true, 'uploads/verification/verif_1755478498208_-261572805.png','Computer Science Department - Senior Lecturer with 10+ years of experience in teaching programming fundamentals.'),
('George Clark',  'george@example.com',  '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true, 'uploads/verification/verif_1755478498208_-261572805.png','Information Technology Department - Associate Professor specializing in web technologies and database systems.'),
('Hannah Lee',    'hannah@example.com',  '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true, 'uploads/verification/verif_1755478498208_-261572805.png','Software Engineering Department - Expert in algorithms and data structures with a passion for teaching.'),
('Ian Turner',    'ian@example.com',     '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true,  NULL,                              'Computer Science Department - Department Head with extensive experience in academic administration and research.'),
('Julia Harris',  'julia@example.com',   '$2a$12$bJpKOjzVwt95ojetfyFctODEoYiiu7/8rttt8wQHwdhPg762L8r4G', now(), true,  NULL,                              'Information Systems - Director of Academic Programs focused on technology integration in education.');

-- ===============================================
-- 3) user_role (users 1-5 students, 6-8 instructors, 9-10 admins)
-- ===============================================
INSERT INTO user_role (user_id, role_id) VALUES
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
-- 4) course (20 courses) owned by instructors (users 6-8)
-- ===============================================
INSERT INTO course (title, description, prerequisites, instructor_id, created_at) VALUES
( 'Introduction to Programming', 'Learn basics of coding',                                  'None',                           6, now() ),
( 'Advanced Java',               'Deep dive into Java programming',                          'Introduction to Programming',    7, now() ),
( 'Web Development',             'HTML, CSS, JS Fundamentals',                               'None',                           8, now() ),
( 'Database Systems',            'SQL and Database Design',                                  'Introduction to Programming',    6, now() ),
( 'Data Structures',             'Lists, Stacks, Queues',                                    'Introduction to Programming',    7, now() ),
( 'Algorithms',                  'Sorting, Searching, Graphs',                               'Data Structures',                8, now() ),
( 'Operating Systems',           'Processes, Threads, Memory',                               'Introduction to Programming',    6, now() ),
( 'Computer Networks',           'Networking Fundamentals',                                  'Introduction to Programming',    7, now() ),
( 'Cybersecurity Basics',        'Security Principles',                                      'None',                           8, now() ),
( 'Software Engineering',        'SDLC, Agile, Testing',                                     'Introduction to Programming',    6, now() ),
( 'Mobile App Development',      'Building Cross-Platform Mobile Apps',                      'Introduction to Programming',    7, now() ),
( 'Cloud Computing',             'Introduction to Cloud Services and Deployment',            'Introduction to Programming',    8, now() ),
( 'Machine Learning',            'Intro to ML Algorithms and Applications',                  'Data Structures',                6, now() ),
( 'Web Security',                'Security Best Practices for Web Applications',             'Web Development',                7, now() ),
( 'DevOps Fundamentals',         'CI/CD, Containers, and Infrastructure as Code',            'Introduction to Programming',    8, now() ),
( 'iOS Development',             'Building iOS Apps with Swift',                             'Introduction to Programming',    6, now() ),
( 'Android Development',         'Building Android Apps with Kotlin',                        'Introduction to Programming',    7, now() ),
( 'Data Visualization',          'Creating Effective Data Visualizations',                   'Introduction to Programming',    8, now() ),
( 'Blockchain Basics',           'Introduction to Blockchain Technology',                    'Introduction to Programming',    6, now() ),
-- NEW #20 to satisfy FK references in assignments/enrollments:
( 'Advanced Web Security',       'Advanced topics in web application security and testing',  'Web Security',                   7, now() );

-- ===============================================
-- 5) assignment (20; one per course_id 1..20)
-- ===============================================
INSERT INTO assignment (course_id, title, description, due_date) VALUES
(1,  'Hello World Program',        'Write a basic program',                                       '2025-09-01'),
(2,  'Java OOP Project',           'Implement classes and objects',                               '2025-09-05'),
(3,  'Responsive Webpage',         'Build a responsive HTML/CSS page',                            '2025-09-10'),
(4,  'ER Diagram',                 'Design a database ER diagram',                                '2025-09-12'),
(5,  'Linked List Implementation', 'Code a linked list',                                          '2025-09-15'),
(6,  'Sorting Algorithms',         'Implement bubble sort and quicksort',                         '2025-09-18'),
(7,  'Process Scheduling',         'Simulate CPU scheduling',                                     '2025-09-20'),
(8,  'TCP Connection Demo',        'Demonstrate TCP handshake',                                   '2025-09-22'),
(9,  'Password Hashing Demo',      'Explore hashing and salting',                                 '2025-09-25'),
(10, 'Agile Project Plan',         'Create a project backlog',                                    '2025-09-28'),
(11, 'Mobile App Prototype',       'Design and prototype a mobile app',                           '2025-10-05'),
(12, 'Cloud Deployment Project',   'Deploy an application to the cloud',                          '2025-10-10'),
(13, 'ML Model Implementation',    'Build and train a simple ML model',                           '2025-10-15'),
(14, 'Security Audit',             'Perform a security assessment of a web app',                  '2025-10-20'),
(15, 'CI/CD Pipeline Setup',       'Create a complete CI/CD pipeline',                            '2025-10-25'),
(16, 'iOS App Feature',            'Implement a key feature in an iOS app',                       '2025-10-30'),
(17, 'Android App Feature',        'Implement a key feature in an Android app',                   '2025-11-05'),
(18, 'Data Visualization Project', 'Create interactive data visualizations',                      '2025-11-10'),
(19, 'Blockchain Demo',            'Create a simple blockchain application',                      '2025-11-15'),
(20, 'Web Security Assessment',    'Security best practices for web applications (advanced lab)', '2025-11-20');

-- ===============================================
-- 6) enrollment (20 enrollments; students 1-5 take 2 courses each incl. course_id 20)
-- ===============================================
INSERT INTO enrollment (course_id, student_id, enrolled_at, progress) VALUES
(1,  1, now(), 20.00),
(2,  1, now(), 0.00),
(3,  2, now(), 50.00),
(4,  2, now(), 10.00),
(5,  3, now(), 0.00),
(6,  3, now(), 30.00),
(7,  4, now(), 40.00),
(8,  4, now(), 15.00),
(9,  5, now(), 60.00),
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
