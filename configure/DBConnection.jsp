<%
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/student_info_system?useSSL=false&serverTimezone=UTC",
        "root",
        "15056324"
    );
%>
