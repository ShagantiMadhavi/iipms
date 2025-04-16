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
<%@ include file="db_connection.jsp" %>
<%@ page session="true" %>
<%
    String managerId = (String) session.getAttribute("emp_id");
    if (managerId == null) {
        response.sendRedirect("emp_login.jsp");
        return;
    }

  
    String query = "SELECT * FROM leave_requests WHERE manager_id = ? AND status = 'Pending'";
    PreparedStatement pst = conn.prepareStatement(query);
    pst.setString(1, managerId);
    ResultSet rs = pst.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Pending Leave Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4 text-center">Pending Leave Requests</h2>
    <table class="table table-bordered table-hover table-striped">
        <thead class="table-dark">
            <tr>
                <th>Leave ID</th>
                <th>Employee ID</th>
                <th>Leave Type</th>
                <th>From</th>
                <th>To</th>
                <th>Reason</th>
                <th>Status</th>
                <th>Applied On</th>
            </tr>
        </thead>
        <tbody>
            <%
                while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("emp_id") %></td>
                <td><%= rs.getString("leave_type") %></td>
                <td><%= rs.getDate("from_date") %></td>
                <td><%= rs.getDate("to_date") %></td>
                <td><%= rs.getString("reason") %></td>
                <td class="text-warning"><%= rs.getString("status") %></td>
                <td><%= rs.getTimestamp("applied_on") %></td>
            </tr>
            <%
                }
                rs.close();
                pst.close();
                conn.close();
            %>
        </tbody>
    </table>
</div>
</body>
</html>

