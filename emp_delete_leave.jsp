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
    int id = Integer.parseInt(request.getParameter("id"));

    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
    PreparedStatement ps = con.prepareStatement("DELETE FROM leave_requests WHERE id = ? AND status = 'Pending'");
    ps.setInt(1, id);

    int i = ps.executeUpdate();
    con.close();

    if (i > 0) {
        response.sendRedirect("emp_view_leave.jsp?msg=Leave request deleted successfully");
    } else {
        response.sendRedirect("emp_view_leave.jsp?msg=Cannot delete approved/rejected leave request");
    }
%>
