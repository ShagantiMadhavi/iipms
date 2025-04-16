<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.sql.*" %>

<%
//Avoid re-declaring the connection if already established
Connection conn = (Connection) application.getAttribute("conn");
    try {
        String url = "jdbc:mysql://localhost:3306/EmployeeTimesheet";
        String user = "root";
        String password = "admin";

        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish the connection
        conn = DriverManager.getConnection(url, user, password);
        session.setAttribute("conn", conn);
        
        // Sample query to fetch emp_id (modify according to your logic)
        String query = "SELECT emp_id FROM employees WHERE name = ?"; // Modify table & condition as needed
        PreparedStatement pst = conn.prepareStatement(query);
        pst.setString(1, "some_username"); // Change to dynamic username
        
        ResultSet rs = pst.executeQuery();
        if (rs.next()) {
            session.setAttribute("emp_id", rs.getString("emp_id")); // Store emp_id in session
        }

        //out.println("<h2>Database Connection Successful! ✅</h2>");
    } catch (Exception e) {
       // out.println("<h2>Database Connection Failed! ❌</h2>");
       // out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
