<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>
<%@ page import="java.sql.*" %>
<%
    String empId = request.getParameter("emp_id");

    if (empId != null && !empId.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
            PreparedStatement ps = con.prepareStatement("DELETE FROM employee74 WHERE emp_id = ?");
            ps.setString(1, empId);
            int result = ps.executeUpdate();
            ps.close();
            con.close();

            if (result > 0) {
                response.sendRedirect("admin_dashboard.jsp?message=✅ Employee with ID " + empId + " deleted successfully.");
                
                out.println(empId);
            } else {
                response.sendRedirect("admin_dashboard.jsp?message=❌ Failed to delete employee with ID " + empId);
            }
        } catch (Exception e) {
            response.sendRedirect("admin_dashboard.jsp?message=❌ Error: " + e.getMessage());
        }
    } else {
        response.sendRedirect("admin_dashboard.jsp?message=❌ Invalid employee ID.");
    }
%>


</body>
</html>