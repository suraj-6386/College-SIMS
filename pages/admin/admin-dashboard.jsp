<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session == null || session.isNew() || 
        session.getAttribute("userId") == null || 
        session.getAttribute("userType") == null) {
        response.sendRedirect("../common/login.jsp"); return;
    }
    if (!"admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect("../common/login.jsp"); return;
    }
    
    int totalUsers = 0, totalStudents = 0, totalTeachers = 0;
    int pendingApprovals = 0, approvedUsers = 0;
    int totalCourses = 0, assignedCourses = 0, totalEnrollments = 0;
    
    try {
        %>
<%@ include file="../../configure/DBConnection.jsp" %>
<%
        Statement stmt = conn.createStatement();
        
        ResultSet rs = stmt.executeQuery("SELECT (SELECT COUNT(*) FROM student) + (SELECT COUNT(*) FROM teacher) as count");
        if (rs.next()) totalUsers = rs.getInt("count");
        
        rs = stmt.executeQuery("SELECT COUNT(*) as count FROM student WHERE status = 'approved'");
        if (rs.next()) totalStudents = rs.getInt("count");
        
        rs = stmt.executeQuery("SELECT COUNT(*) as count FROM teacher WHERE status = 'approved'");
        if (rs.next()) totalTeachers = rs.getInt("count");
        
        rs = stmt.executeQuery("SELECT (SELECT COUNT(*) FROM student WHERE status = 'pending') + (SELECT COUNT(*) FROM teacher WHERE status = 'pending') as count");
        if (rs.next()) pendingApprovals = rs.getInt("count");
        
        rs = stmt.executeQuery("SELECT (SELECT COUNT(*) FROM student WHERE status = 'approved') + (SELECT COUNT(*) FROM teacher WHERE status = 'approved') as count");
        if (rs.next()) approvedUsers = rs.getInt("count");
        
        rs = stmt.executeQuery("SELECT COUNT(*) as count FROM courses");
        if (rs.next()) totalCourses = rs.getInt("count");
        
        rs = stmt.executeQuery("SELECT COUNT(*) as count FROM subjects");
        if (rs.next()) assignedCourses = rs.getInt("count");
        
        rs = stmt.executeQuery("SELECT COUNT(DISTINCT student_id) as count FROM subject_enrollment");
        if (rs.next()) totalEnrollments = rs.getInt("count");
        
        conn.close();
    } catch (Exception e) { }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — Dr. D. Y. Patil Vidyapeeth</title>
    <link rel="stylesheet" href="../../styles/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">
                <h1>SIMS</h1>
                <p>School of Science and Technology</p>
            </div>
            <div class="nav-links">
                <a href="admin-dashboard.jsp" class="active">Dashboard</a>
                <a href="admin-pending.jsp">Approvals</a>
                <a href="admin-users.jsp">Users</a>
                <a href="courses.jsp">Courses</a>
                <a href="reports.jsp">Reports</a>
                <a href="../common/announcements.jsp">Announcements</a>
                <a href="../common/logout.jsp" class="btn btn-secondary">Sign Out</a>
            </div>
        </div>
    </nav>
    <div class="dashboard-container">
        <h2>Admin Dashboard</h2>
        <p class="section-subtitle">Welcome, <%= session.getAttribute("userName") %> (Administrator)</p>
        
        <div class="dashboard-grid">
            <div class="dashboard-card" style="border-top: 4px solid var(--color-sage);">
                <h3>Pending Approvals</h3>
                <div class="stat-number"><%= pendingApprovals %></div>
                <a href="admin-pending.jsp" class="btn btn-primary" style="margin-top: 1rem; display: block; text-align: center;">Review Registrations</a>
            </div>
            <div class="dashboard-card">
                <h3>Total Users</h3>
                <div class="stat-number"><%= totalUsers %></div>
                <div class="stat-label"><%= totalStudents %> Students  ·  <%= totalTeachers %> Teachers</div>
                <a href="admin-users.jsp" class="btn btn-outline" style="margin-top: 1rem; display: block; text-align: center;">Manage Users</a>
            </div>
            <div class="dashboard-card">
                <h3>System Courses</h3>
                <div class="stat-number"><%= totalCourses %></div>
                <div class="stat-label"><%= assignedCourses %> Active Subjects</div>
                <a href="courses.jsp" class="btn btn-outline" style="margin-top: 1rem; display: block; text-align: center;">Manage Curriculum</a>
            </div>
            <div class="dashboard-card">
                <h3>Total Enrollments</h3>
                <div class="stat-number"><%= totalEnrollments %></div>
                <a href="reports.jsp" class="btn btn-outline" style="margin-top: 1rem; display: block; text-align: center;">Generate Reports</a>
            </div>
        </div>
        
        <h3 style="margin-top: 2rem;">Quick Actions</h3>
        <div class="links-container" style="margin-top: 1rem;">
            <a href="admin-pending.jsp" class="action-btn">Review Pending Enrollments</a>
            <a href="admin-users.jsp" class="action-btn">Edit User Profiles</a>
            <a href="courses.jsp" class="action-btn">Update Course Catalogue</a>
            <a href="reports.jsp" class="action-btn">View Analytics & Reports</a>
        </div>
    </div>
     <footer class="footer">
        <div class="footer-bottom">
            <p>&copy; 2026 SIMS - Student Information Management System. </p>
            <p>&copy; SURAJ GUPTA | MCA</p>
        </div>
    </footer>
</body>
</html>


