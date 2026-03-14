<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session == null || session.isNew() || session.getAttribute("userId") == null || session.getAttribute("userType") == null) {
        response.sendRedirect("../common/login.jsp"); return;
    }
    if (!"student".equals(session.getAttribute("userType"))) {
        response.sendRedirect("../common/login.jsp"); return;
    }
    
    int userId = (Integer) session.getAttribute("userId");
    int totalCourses = 0, marksReceived = 0;
    double attendancePercent = 0;
    
    try {
        %>
<%@ include file="../../configure/DBConnection.jsp" %>
<%
        Statement stmt = conn.createStatement();
        
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM subject_enrollment WHERE student_id = " + userId + " AND status = 'active'");
        if (rs.next()) totalCourses = rs.getInt("count");
        
        rs = stmt.executeQuery("SELECT COUNT(*) as count FROM marks WHERE student_id = " + userId);
        if (rs.next()) marksReceived = rs.getInt("count");
        
        rs = stmt.executeQuery("SELECT ROUND(SUM(IF(status = 'present', 1, 0)) * 100 / NULLIF(COUNT(*), 0), 2) as percentage FROM attendance WHERE student_id = " + userId);
        if (rs.next() && rs.getObject("percentage") != null) {
            attendancePercent = rs.getDouble("percentage");
        }
        conn.close();
    } catch (Exception e) { }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard SIMS DPU</title>
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
                <a href="student-dashboard.jsp" class="active">Dashboard</a>
                <a href="student-courses.jsp">My Courses</a>
                <a href="student-attendance.jsp">Attendance</a>
                <a href="student-marks.jsp">Marks</a>
                <a href="student-profile.jsp">Profile</a>
                <a href="../common/announcements.jsp">Announcements</a>
                <a href="../common/logout.jsp" class="btn btn-secondary">Sign Out</a>
            </div>
        </div>
    </nav>
    <div class="dashboard-container">
        <h2>Student Dashboard</h2>
        <p class="section-subtitle">Welcome, <%= session.getAttribute("userName") %> (ID: <%= session.getAttribute("userIdCode") %>)</p>
        
        <div class="dashboard-grid">
            <div class="dashboard-card">
                <h3>Enrolled Subjects</h3>
                <div class="stat-number"><%= totalCourses %></div>
                <a href="student-courses.jsp" class="btn btn-outline" style="margin-top: 1rem; display: block; text-align: center;">View Courses</a>
            </div>
            <div class="dashboard-card">
                <h3>Marks Received</h3>
                <div class="stat-number"><%= marksReceived %></div>
                <a href="student-marks.jsp" class="btn btn-outline" style="margin-top: 1rem; display: block; text-align: center;">View Marks</a>
            </div>
            <div class="dashboard-card">
                <h3>Attendance</h3>
                <div class="stat-number"><%= String.format("%.1f", attendancePercent) %>%</div>
                <a href="student-attendance.jsp" class="btn btn-outline" style="margin-top: 1rem; display: block; text-align: center;">View Attendance</a>
            </div></div>
     <footer class="footer">
        <div class="footer-bottom">
             <p>&copy; 2026 SIMS - Student Information Management System. </p>
            <p>&copy; SURAJ GUPTA | MCA</p>
        </div>
    </footer>
</body>
</html>


