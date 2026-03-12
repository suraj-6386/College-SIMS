# Student Information Management System (SIMS)

This project is a web app for managing student details like attendance, marks, and courses. It implements a Role-Based Directory system to separate concerns for Admins, Teachers, and Students.

## Tech Stack
- HTML, CSS, JavaScript
- JSP (JavaServer Pages)
- MySQL Database

## Role-Based Directory Map
- `/pages/admin/` — Admin-specific JSP files (Dashboard, User Management, Approvals).
- `/pages/teacher/` — Teacher-specific JSP files (Attendance, Grading, My Students).
- `/pages/student/` — Student-specific JSP files (View Marks, Attendance, Profile).
- `/pages/common/` — Shared JSP files (Login, Registration, Announcements, Logout).
- `/configure/` — Database connection configuration (`DBConnection.jsp`).
- `/styles/` — Global CSS styling.
- `/images/` — Asset storage for logos and auxiliary images.

## Path Synchronization Rules
For optimal resource loading, all internal paths follow a strict hierarchy:
- **CSS**: `../../styles/style.css` (from role subfolders).
- **Images**: `../../images/logo.png`.
- **Database**: `../../configure/DBConnection.jsp`.
- **Common Access**: `../common/filename.jsp`.

## Design Aesthetics
SIMS features a professional **Dark Red and White** humanized UI theme:
- **Palette**: Dark Red (`#8B0000`) and White (`#FFFFFF`).
- **Typography**: Clean Sans-Serif (Inter / Arial).
- **UI Components**: Soft rounded corners (12px), fixed headers, and subtle micro-animations.

## New Machine Setup

### Prerequisites
- [XAMPP](https://www.apachefriends.org/) with **Apache Tomcat 8.5.x+** and **MySQL**.
- MySQL Connector/J JAR in `WEB-INF/lib/`.

### Step 1 — Database Setup
1. Start **MySQL** from XAMPP.
2. Open **phpMyAdmin** at `http://localhost/phpmyadmin`.
3. Create a new database named `student_info_system`.
&copy; 2026 — All rights reserved.
