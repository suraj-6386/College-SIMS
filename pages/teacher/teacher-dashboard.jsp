<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session == null || session.isNew() || session.getAttribute("userId") == null || session.getAttribute("userType") == null) {
        response.sendRedirect("../common/login.jsp"); return;
    }
    if (!"teacher".equals(session.getAttribute("userType"))) {
        response.sendRedirect("../common/login.jsp"); return;
    }
    int teacherId = (Integer) session.getAttribute("userId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard — Dr. D. Y. Patil Vidyapeeth</title>
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
                <a href="teacher-dashboard.jsp" class="active">Dashboard</a>
                <a href="teacher-profile.jsp">Profile</a>
                <a href="teacher-courses.jsp">My Courses</a>
                <a href="teacher-students.jsp">Students</a>
                <a href="teacher-attendance.jsp">Attendance</a>
                <a href="teacher-marks.jsp">Marks</a>
                <a href="../common/announcements.jsp">Announcements</a>
                <a href="../common/logout.jsp" class="btn btn-secondary">Sign Out</a>
            </div>
        </div>
    </nav>
    <div class="dashboard-container">
        <h2>Teacher Dashboard</h2>
        <p class="section-subtitle">Welcome, <%= session.getAttribute("userName") %> (ID: <%= session.getAttribute("userIdCode") %>) <br> <%= session.getAttribute("userEmail") %></p>
        
        <div class="dashboard-grid">
            <div class="dashboard-card">
                <h3>Assigned Subjects</h3>
                <div class="stat-number">
                    <%
                        try {
                            %>
<%@ include file="../../configure/DBConnection.jsp" %>
<%
                            PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) as cnt FROM subjects WHERE teacher_id = ?");
                            ps.setInt(1, teacherId);
                            ResultSet rs = ps.executeQuery();
                            if (rs.next()) out.print(rs.getInt("cnt"));
                            rs.close(); ps.close(); conn.close();
                        } catch (Exception e) { out.print("0"); }
                    %>
                </div>
                <a href="teacher-courses.jsp" class="btn btn-outline" style="margin-top: 1rem; display: block; text-align: center;">View Subjects</a>
            </div>
            
            <div class="dashboard-card">
                <h3>Total Students</h3>
                <div class="stat-number">
                    <%
                        try {
                            %>
<%@ include file="../../configure/DBConnection.jsp" %>
<%
                            PreparedStatement ps = conn.prepareStatement(
                                "SELECT COUNT(DISTINCT se.student_id) as cnt FROM subject_enrollment se " +
                                "JOIN subjects s ON se.subject_id = s.subject_id WHERE s.teacher_id = ? AND se.status = 'active'");
                            ps.setInt(1, teacherId);
                            ResultSet rs = ps.executeQuery();
                            if (rs.next()) out.print(rs.getInt("cnt"));
                            rs.close(); ps.close(); conn.close();
                        } catch (Exception e) { out.print("0"); }
                    %>
                </div>
                <a href="teacher-students.jsp" class="btn btn-outline" style="margin-top: 1rem; display: block; text-align: center;">View Students</a>
            </div></div>
     <footer class="footer">
        <div class="footer-bottom">
            <p>&copy; 2026 SIMS - Student Information Management System. </p>
            <p>&copy; SURAJ GUPTA | MCA</p>
        </div>
    </footer>
</body>
</html>


