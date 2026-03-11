# Student Information Management System (SIMS)

This project is a web app for managing student details like attendance, marks, and courses. It lets students, teachers, and admins log in to view and update info.

## Tech Stack
- HTML
- CSS
- JSP
- MySQL

## New Machine Setup

1. Download and install XAMPP (includes Apache and MySQL).
2. Start XAMPP and click "Start" for Apache and MySQL.
3. Open phpMyAdmin in browser (localhost/phpmyadmin).
4. Create a new database called "student_info_system".
5. Import the SQLQUERY.sql file into the database.
6. Copy the project folder to C:\xampp\htdocs\ or for Tomcat, to webapps folder.
7. For Tomcat, start Tomcat server.
8. Open browser and go to localhost/StudentInfoManageSystem (or htdocs path).
9. Basic CSS has been added to provide modernized styling for tables, forms, and layouts across all pages.

## Run Details
- Register a new account as admin or teacher.
- For testing, use admin email: admin@example.com, password: admin123 (if set in database).
- Login at login.jsp.

---

## File Architecture

```
StudentInfoManageSystem/
├── index.html               # Public landing page
├── login.jsp                # Unified sign-in portal (routes by role)
├── registration.jsp         # New user self-registration
├── logout.jsp               # Session termination
├── style.css                # Global "Digital Craftsmanship" stylesheet
│
├── admin-dashboard.jsp      # Admin overview with system stats
├── admin-pending.jsp        # Registration approval queue
├── admin-users.jsp          # User management table
│
├── teacher-dashboard.jsp    # Teacher overview with subjects & students
├── teacher-courses.jsp      # Course management
├── teacher-students.jsp     # Student list view
├── teacher-attendance.jsp   # Mark & manage attendance
├── teacher-marks.jsp        # Enter & update student grades
├── teacher-profile.jsp      # Teacher profile view
├── teacher-subjects.jsp     # Subject listing
│
├── student-dashboard.jsp    # Student overview (enrolled, marks, attendance)
├── student-courses.jsp      # Enrolled courses list
├── student-attendance.jsp   # Personal attendance record
├── student-marks.jsp        # Personal grades view
├── student-profile.jsp      # Student profile view
│
├── courses.jsp              # Course catalogue (admin)
├── subjects.jsp             # Subject management (admin)
├── announcements.jsp        # Announcement feed (all roles)
├── reports.jsp              # System reports (admin)
├── error.jsp                # Error page
│
├── get-course-students.jsp  # AJAX: students by course
├── get-subject-students.jsp # AJAX: students by subject
├── get-user-details.jsp     # AJAX: user detail lookup
│
├── DB_SETUP.sql             # Database schema & initial data
├── SQLQUERY.sql             # Reference SQL queries
│
└── WEB-INF/
    └── lib/
        └── mysql-connector-java-*.jar
```

---

## Module Descriptions

### 1. Administration Portal
- **Dashboard**: System-wide statistics — pending approvals, user counts, course/enrollment totals.
- **Pending Approvals**: Review and approve/reject new Student and Teacher registrations. Approving a student auto-enrols them in their course's subjects for the declared semester.
- **User Management**: View and manage all registered students and teachers.
- **Course & Subject Management**: Create courses (e.g., B.Sc. CS), add subjects, and assign teachers.
- **Reports**: Consolidated academic reports across all users.
- **Announcements**: Post notices visible to all system users.

### 2. Teacher (Faculty) Portal
- **Dashboard**: Quick overview of assigned subjects and enrolled student count; one-click access to attendance.
- **My Courses**: Detailed view of all subjects assigned by admin.
- **Students**: Full list of students enrolled in the teacher's subjects.
- **Attendance**: Mark attendance per subject per session (present/absent).
- **Marks**: Enter and update marks/grades per student per subject.
- **Profile**: View personal information on record.

### 3. Student Portal
- **Dashboard**: At-a-glance view of enrolled subjects, marks received, and overall attendance percentage.
- **My Courses**: List of all active subject enrolments.
- **Attendance**: Personal attendance log, session-by-session.
- **Marks**: View grades entered by teachers per subject.
- **Profile**: Personal academic profile.

---

## New Machine Setup

### Prerequisites
- [XAMPP](https://www.apachefriends.org/) with **Apache Tomcat 9.x** and **MySQL**
- JDK 8+ (included with XAMPP Tomcat)
- MySQL Connector/J JAR in `WEB-INF/lib/`

---

### Step 1 — Database Setup

1. Start **MySQL** from the XAMPP Control Panel.
2. Open **phpMyAdmin** at `http://localhost/phpmyadmin`
3. Create a new database named `student_info_system`.
4. Select that database, click **Import**, and upload `DB_SETUP.sql`.

Alternatively, via the MySQL CLI:
```sql
CREATE DATABASE student_info_system;
USE student_info_system;
SOURCE /path/to/DB_SETUP.sql;
```

---

### Step 2 — JDBC Driver

Ensure the MySQL Connector JAR is present:
```
StudentInfoManageSystem/WEB-INF/lib/mysql-connector-java-X.X.X.jar
```
Download from: [https://dev.mysql.com/downloads/connector/j/](https://dev.mysql.com/downloads/connector/j/)

---

### Step 3 — Database Credentials

The connection string is embedded in each JSP file. If your MySQL password differs from the default, do a project-wide search-and-replace:

```
URL:      jdbc:mysql://localhost:3306/student_info_system?useSSL=false&serverTimezone=UTC
Username: root
Password: 15056324   ← change this to match your MySQL root password
```

---

### Step 4 — Deploy to Tomcat

1. Start **Apache Tomcat** from the XAMPP Control Panel.
2. Copy the entire `StudentInfoManageSystem/` folder to:
   ```
   C:\xampp\tomcat\webapps\MyApps\StudentInfoManageSystem\
   ```
3. Tomcat auto-deploys the application.

---

### Step 5 — Access the Application

| Page         | URL                                                                       |
|--------------|---------------------------------------------------------------------------|
| Landing Page | `http://localhost:8080/MyApps/StudentInfoManageSystem/index.html`         |
| Sign In      | `http://localhost:8080/MyApps/StudentInfoManageSystem/login.jsp`          |
| Register     | `http://localhost:8080/MyApps/StudentInfoManageSystem/registration.jsp`   |

---

### Default Admin Account

The default admin credentials are seeded by `DB_SETUP.sql`. Check that file for the admin email and password (stored as SHA-256 hash). To create a new admin manually:

```sql
INSERT INTO admin (full_name, email, password_hash)
VALUES ('Admin Name', 'admin@sims.edu', SHA2('yourpassword', 256));
```
> **Note:** Use `Base64(SHA-256(password))` as encoded in the JSP, or update to match the hashing scheme in `login.jsp`.

---

## Design Notes

SIMS uses a purposefully crafted "Digital Craftsmanship" aesthetic — **no Bootstrap, no frameworks**:

- **Typography**: *Libre Baskerville* (headings) paired with *Outfit* (interface data)
- **Palette**: Charcoal `#1e1e1e` · Cream `#fdfcf0` · Sage Green `#88967b`
- **Transitions**: `cubic-bezier(0.4, 0, 0.2, 1)` — soft, non-linear hover effects
- **Layout**: Asymmetric editorial structure; left-anchored nav brand, staggered dashboard cards

---

## License

This project is developed for academic purposes at DY Patil School of Science and Technology, Pune.
&copy; 2026 — All rights reserved.
