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
    String managerId = (String) session.getAttribute("emp_id");

    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
    PreparedStatement ps = con.prepareStatement(
        "SELECT lr.*, e.name FROM leave_requests lr JOIN employee74 e ON lr.emp_id = e.emp_id WHERE e.manager_id = ?");
    ps.setString(1, managerId);
    ResultSet rs = ps.executeQuery();
%>


<h2 class="mb-4 text-danger">Team Leave Requests</h2>

<table class="table table-bordered table-hover shadow-sm">
    <thead class="table-dark">
    <tr>
        <th>Employee Name</th>
        <th>Leave Type</th>
        <th>From</th>
        <th>To</th>
        <th>Reason</th>
        <th>Status</th>
        <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <%
        while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getString("leave_type") %></td>
        <td><%= rs.getDate("from_date") %></td>
        <td><%= rs.getDate("to_date") %></td>
        <td><%= rs.getString("reason") %></td>
        <td><%= rs.getString("status") %></td>
        <td>
            <form action="emp_update_leave_status.jsp" method="post" class="d-flex gap-2">
                <input type="hidden" name="leave_id" value="<%= rs.getInt("id") %>">
                <button name="action" value="Approved" class="btn btn-success btn-sm">Approve</button>
                <button name="action" value="Rejected" class="btn btn-danger btn-sm">Reject</button>
            </form>
        </td>
    </tr>
    <%
        }
        con.close();
    %>
    </tbody>
</table>
<jsp:include page="footer_main.jsp" />
</body>
</html>
