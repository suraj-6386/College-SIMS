<%@ page import="java.sql.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
    response.setHeader("Content-Type", "application/json");
    String subjectIdStr = request.getParameter("subject_id");
    
    if (subjectIdStr == null || subjectIdStr.trim().isEmpty()) {
        out.print("[]");
        return;
    }
    
    try {
        int subjectId = Integer.parseInt(subjectIdStr);
        
        %>
<%@ include file="../configure/DBConnection.jsp" %>
<%
        
        String query = "SELECT st.student_id, st.full_name, st.roll_number " +
                       "FROM student st " +
                       "JOIN subject_enrollment se ON st.student_id = se.student_id " +
                       "WHERE se.subject_id = ? AND se.status = 'active' AND st.status = 'approved' " +
                       "ORDER BY st.roll_number";
        
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, subjectId);
        
        ResultSet rs = pstmt.executeQuery();
        
        StringBuilder json = new StringBuilder("[");
        boolean first = true;
        
        while (rs.next()) {
            if (!first) {
                json.append(",");
            }
            json.append("{");
            json.append("\"student_id\":").append(rs.getInt("student_id")).append(",");
            json.append("\"full_name\":\"").append(rs.getString("full_name") != null ? rs.getString("full_name").replace("\"", "\\\"") : "").append("\",");
            json.append("\"roll_number\":\"").append(rs.getString("roll_number") != null ? rs.getString("roll_number").replace("\"", "\\\"") : "").append("\"");
            json.append("}");
            first = false;
        }
        
        json.append("]");
        
        rs.close();
        pstmt.close();
        conn.close();
        
        out.print(json.toString());
    } catch (Exception e) {
        // Return empty array on error to prevent JSON parse errors
        out.print("[]");
    }
%>
