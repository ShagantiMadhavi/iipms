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
    String leaveId = request.getParameter("leave_id");
    String action = request.getParameter("action");

    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
    PreparedStatement ps = con.prepareStatement("UPDATE leave_requests SET status = ? WHERE id = ?");
    ps.setString(1, action);
    ps.setString(2, leaveId);
    ps.executeUpdate();

    con.close();
    response.sendRedirect("emp_manage_leaves.jsp");
%>
