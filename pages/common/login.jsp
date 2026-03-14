<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.util.Base64" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String message = "";
    String messageType = "";
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email != null && password != null && !email.isEmpty() && !password.isEmpty()) {
            try {
                %>
<%@ include file="../../configure/DBConnection.jsp" %>
<%
                
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] hashedPassword = md.digest(password.getBytes("UTF-8"));
                String hashedPasswordStr = Base64.getEncoder().encodeToString(hashedPassword);
                
                PreparedStatement adminStmt = conn.prepareStatement(
                    "SELECT admin_id, full_name FROM admin WHERE email = ? AND password_hash = ?");
                adminStmt.setString(1, email);
                adminStmt.setString(2, hashedPasswordStr);
                ResultSet adminRS = adminStmt.executeQuery();
                
                if (adminRS.next()) {
                    session.setAttribute("userId", adminRS.getInt("admin_id"));
                    session.setAttribute("userName", adminRS.getString("full_name"));
                    session.setAttribute("userType", "admin");
                    session.setAttribute("userEmail", email);
                    response.sendRedirect("../admin/admin-dashboard.jsp");
                    adminRS.close(); adminStmt.close(); conn.close();
                    return;
                }
                adminRS.close(); adminStmt.close();
                
                PreparedStatement studentStmt = conn.prepareStatement(
                    "SELECT student_id, user_id, full_name, status FROM student WHERE email = ? AND password_hash = ?");
                studentStmt.setString(1, email);
                studentStmt.setString(2, hashedPasswordStr);
                ResultSet studentRS = studentStmt.executeQuery();
                
                if (studentRS.next()) {
                    String status = studentRS.getString("status");
                    if ("rejected".equals(status)) {
                        message = "Your registration has been rejected. Please contact admin.";
                        messageType = "danger";
                    } else if ("active".equals(status) || "pending".equals(status) || "approved".equals(status)) {
                        session.setAttribute("userId", studentRS.getInt("student_id"));
                        session.setAttribute("userIdCode", studentRS.getString("user_id"));
                        session.setAttribute("userName", studentRS.getString("full_name"));
                        session.setAttribute("userType", "student");
                        session.setAttribute("userEmail", email);
                        response.sendRedirect("../student/student-dashboard.jsp");
                        studentRS.close(); studentStmt.close(); conn.close();
                        return;
                    }
                }
                studentRS.close(); studentStmt.close();
                
                PreparedStatement teacherStmt = conn.prepareStatement(
                    "SELECT teacher_id, user_id, full_name, status FROM teacher WHERE email = ? AND password_hash = ?");
                teacherStmt.setString(1, email);
                teacherStmt.setString(2, hashedPasswordStr);
                ResultSet teacherRS = teacherStmt.executeQuery();
                
                if (teacherRS.next()) {
                    String status = teacherRS.getString("status");
                    if ("rejected".equals(status)) {
                        message = "Your registration has been rejected. Please contact admin.";
                        messageType = "danger";
                    } else if ("active".equals(status) || "pending".equals(status) || "approved".equals(status)) {
                        session.setAttribute("userId", teacherRS.getInt("teacher_id"));
                        session.setAttribute("userIdCode", teacherRS.getString("user_id"));
                        session.setAttribute("userName", teacherRS.getString("full_name"));
                        session.setAttribute("userType", "teacher");
                        session.setAttribute("userEmail", email);
                        response.sendRedirect("../teacher/teacher-dashboard.jsp");
                        teacherRS.close(); teacherStmt.close(); conn.close();
                        return;
                    }
                }
                teacherRS.close(); teacherStmt.close();
                
                message = "Invalid email or password. Please try again.";
                messageType = "danger";
                conn.close();
            } catch (Exception e) {
                message = "Sign-in error: " + e.getMessage();
                messageType = "danger";
            }
        } else {
            message = "Please enter your email and password.";
            messageType = "danger";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In SIMS DPU</title>
    <link rel="stylesheet" href="../../styles/style.css">
</head>
<body>
    <nav class="navbar"><div class="nav-container"><div class="nav-brand"><h1>SIMS</h1><p>School of Science and Technology</p></div><div class="nav-links"><a href="../../index.html">Home</a><a href="registration.jsp">Register</a></div></div></nav>
    <div class="dashboard-container">
        <h1>Sign In</h1>
        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %>">
                <%= message %>
            </div>
        <% } %>
        <form method="POST" action="login.jsp">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" required>
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
            <input type="submit" value="Sign In">
        </form>
        <p>New to SIMS? <a href="registration.jsp">Create an account</a></p>
    </div>
     <footer class="footer">
        <div class="footer-bottom">
            <p>&copy; 2026 SIMS - Student Information Management System. </p>
            <p>&copy; SURAJ GUPTA | MCA</p>
        </div>
    </footer>
</body>
</html>


