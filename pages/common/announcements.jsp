<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session == null || session.isNew() || session.getAttribute("userId") == null || session.getAttribute("userType") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int userId = (Integer) session.getAttribute("userId");
    String userType = (String) session.getAttribute("userType");
    String message = "";
    String messageType = "";
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String visibility = request.getParameter("visibility");
            
            try {
                %>
<%@ include file="../../configure/DBConnection.jsp" %>
<%
                
                int posterId = userId;
                
                PreparedStatement ps = conn.prepareStatement("INSERT INTO announcements (posted_by, title, content, visibility_level) VALUES (?, ?, ?, ?)");
                ps.setInt(1, posterId);
                ps.setString(2, title);
                ps.setString(3, content);
                ps.setString(4, visibility);
                ps.executeUpdate();
                ps.close();
                
                message = "Announcement posted successfully!";
                messageType = "success";
                conn.close();
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                messageType = "danger";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Announcements - SIMS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../../styles/style.css">
    <style>
        .announcements-header {
            margin-bottom: 2.5rem;
            border-bottom: 2px solid var(--color-border);
            padding-bottom: 1rem;
        }

        .post-form-card {
            background: white;
            border-radius: 16px;
            padding: 2.5rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
            margin-bottom: 3rem;
            border: 1px solid var(--color-border);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
        }

        .announcement-feed {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .announcement-card {
            background: white;
            border-radius: 12px;
            padding: 1.8rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            border: 1px solid var(--color-border);
            border-left: 6px solid var(--color-primary);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .announcement-card:hover {
            transform: translateX(5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.06);
        }

        .announcement-title {
            font-family: var(--font-heading);
            font-size: 1.4rem;
            color: var(--color-primary);
            margin-bottom: 0.8rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .announcement-content {
            font-size: 1.05rem;
            color: #444;
            line-height: 1.7;
            margin-bottom: 1.5rem;
            white-space: pre-wrap;
        }

        .announcement-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1.2rem;
            border-top: 1px solid #f0f0f0;
            font-size: 0.85rem;
            color: #777;
        }

        .poster-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .poster-badge {
            background: #f8f9fa;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-weight: 600;
            color: var(--color-text);
            border: 1px solid #eee;
        }

        .timestamp {
            font-style: italic;
            color: #999;
        }

        .empty-state {
            text-align: center;
            padding: 5rem 2rem;
            background: white;
            border-radius: 16px;
            border: 2px dashed #eee;
        }

        .empty-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand"><h1>SIMS</h1><p>Announcements</p></div>
            <div class="nav-links">
                <% if ("admin".equals(userType)) { %>
                    <a href="../admin/admin-dashboard.jsp" class="nav-link">Dashboard</a>
                <% } else if ("teacher".equals(userType)) { %>
                    <a href="../teacher/teacher-dashboard.jsp" class="nav-link">Dashboard</a>
                <% } else { %>
                    <a href="../student/student-dashboard.jsp" class="nav-link">Dashboard</a>
                <% } %>
                <a href="logout.jsp" class="nav-link">Logout</a>
            </div>
        </div>
    </nav>

    <div class="dashboard-container">
        <div class="announcements-header">
            <a href="<%= "admin".equals(userType) ? "../admin/admin-dashboard.jsp" : ("teacher".equals(userType) ? "../teacher/teacher-dashboard.jsp" : "../student/student-dashboard.jsp") %>" class="back-btn">&larr; Back to Dashboard</a>
            <h2>📢 Announcements Feed</h2>
            <p>Stay updated with the latest news and academic notices.</p>
        </div>
        
        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %>" style="max-width: 100%;"><%= message %></div>
        <% } %>
        
        <% if ("admin".equals(userType) || "teacher".equals(userType)) { %>
        <div class="post-form-card">
            <h3>✨ Post New Announcement</h3>
            <p style="margin-bottom: 2rem; font-size: 0.9rem; color: #666;">Create a broadcast message for students or faculty.</p>
            <form method="POST">
                <input type="hidden" name="action" value="create">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Subject / Title *</label>
                        <input type="text" name="title" placeholder="Enter a descriptive title..." required>
                    </div>
                    <div class="form-group">
                        <label>Visibility *</label>
                        <select name="visibility">
                            <option value="all">Public (Everyone)</option>
                            <option value="students">Students Only</option>
                            <option value="teachers">Teachers Only</option>
                            <option value="admin">Admin Only</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label>Announcement Content *</label>
                    <textarea name="content" rows="5" placeholder="Write your announcement message here..." required></textarea>
                </div>
                <div style="display: flex; justify-content: flex-end;">
                    <button type="submit" class="btn btn-primary" style="padding: 1rem 3rem;">
                        <span>Post Announcement &rarr;</span>
                    </button>
                </div>
            </form>
        </div>
        <% } %>
        
        <h3 style="margin-bottom: 2rem;">📜 Recent Broadcasts</h3>
        <div class="announcement-feed">
            <%
                try {
                    %>
<%@ include file="../../configure/DBConnection.jsp" %>
<%
                    
                    String sql = "SELECT a.*, t.full_name as poster_name FROM announcements a " +
                                "JOIN teacher t ON a.posted_by = t.teacher_id " +
                                "WHERE a.visibility_level = 'all' OR a.visibility_level = ? " +
                                "ORDER BY a.posted_at DESC";
                    
                    if ("admin".equals(userType)) {
                        sql = "SELECT a.*, t.full_name as poster_name FROM announcements a " +
                              "JOIN teacher t ON a.posted_by = t.teacher_id " +
                              "ORDER BY a.posted_at DESC";
                    }
                    
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    if (!"admin".equals(userType)) {
                        stmt.setString(1, userType + "s");
                    }
                    ResultSet rs = stmt.executeQuery();
                    
                    boolean hasAnnouncements = false;
                    while (rs.next()) {
                        hasAnnouncements = true;
            %>
            <div class="announcement-card">
                <div class="announcement-title">
                    <span>📑</span>
                    <%= rs.getString("title") %>
                </div>
                <div class="announcement-content"><%= rs.getString("content") %></div>
                <div class="announcement-meta">
                    <div class="poster-info">
                        <span>Posted by:</span>
                        <span class="poster-badge">👤 <%= rs.getString("poster_name") %></span>
                    </div>
                    <span class="timestamp">🕒 <%= rs.getTimestamp("posted_at") %></span>
                </div>
            </div>
            <% }
                    if (!hasAnnouncements) {
                        %>
                        <div class="empty-state">
                            <span class="empty-icon">📭</span>
                            <h4>No announcements yet.</h4>
                            <p>When notices are posted, they will appear in this feed.</p>
                        </div>
                        <%
                    }
                    conn.close();
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>Error loading announcements: " + e.getMessage() + "</div>");
                }
            %>
        </div>
    </div>

    <footer class="footer">
        <div class="footer-bottom"> <p>&copy; 2026 SIMS - Student Information Management System. </p>
            <p>&copy; SURAJ GUPTA | MCA</p></div>
    </footer>
</body>
</html>




