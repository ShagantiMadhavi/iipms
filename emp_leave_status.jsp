<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>


    <%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>
<%
    String empId = (String) session.getAttribute("emp_id");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
    PreparedStatement ps = con.prepareStatement("SELECT * FROM leave_requests WHERE emp_id = ?");
    ps.setString(1, empId);
    ResultSet rs = ps.executeQuery();
%>

<jsp:include page="header_main.jsp" />
<jsp:include page="emp_timesheet_header01.jsp" />

<div class="container-fluid p-4">

<h2 class="mb-4 text-success">My Leave Applications</h2>

<table class="table table-bordered table-hover table-striped shadow-sm">
    <thead class="table-primary">
    <tr>
        <th>ID</th> <!-- Added ID column -->
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
        int id = 1; // Counter for leave applications
        while (rs.next()) {
    %>
    <tr>
        <td><%= id++ %></td> <!-- Displaying ID -->
        <td><%= rs.getString("leave_type") %></td>
        <td><%= rs.getDate("from_date") %></td>
        <td><%= rs.getDate("to_date") %></td>
        <td><%= rs.getString("reason") %></td>
        <td>
            <span class="badge bg-<%= rs.getString("status").equalsIgnoreCase("Approved") ? "success" : rs.getString("status").equalsIgnoreCase("Rejected") ? "danger" : "warning" %>">
                <%= rs.getString("status") %>
            </span>
        </td>
        <td><%= rs.getTimestamp("applied_on") %></td>
    </tr>
    <%
        }
        con.close();
    %>
    </tbody>
</table>

</div>
<jsp:include page="footer_main.jsp" />
</body>
</html>
