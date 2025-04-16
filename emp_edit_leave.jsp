<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>

<jsp:include page="header_main.jsp" />
<jsp:include page="emp_timesheet_header01.jsp" />
<%@ page import="java.sql.*" %>
<%
    int leaveId = Integer.parseInt(request.getParameter("id"));
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
    PreparedStatement ps = con.prepareStatement("SELECT * FROM leave_requests WHERE id = ?");
    ps.setInt(1, leaveId);
    ResultSet rs = ps.executeQuery();
    rs.next();
%>

<div class="container mt-4">
    <h3 class="text-primary mb-4">Edit Leave Request (ID: <%= leaveId %>)</h3>
    <form action="emp_update_leave.jsp" method="post" class="border p-4 shadow-sm rounded bg-light">
        <input type="hidden" name="id" value="<%= leaveId %>">

        <div class="mb-3">
            <label class="form-label">Leave Type</label>
            <select name="leave_type" class="form-select" required>
                <option <%= rs.getString("leave_type").equals("Casual Leave") ? "selected" : "" %>>Casual Leave</option>
				<option <%= rs.getString("leave_type").equals("Sick Leave") ? "selected" : "" %>>Sick Leave</option>
				<option <%= rs.getString("leave_type").equals("Earned Leave") ? "selected" : "" %>>Earned Leave</option>
				<option <%= rs.getString("leave_type").equals("Vacation Leave") ? "selected" : "" %>>Vacation Leave</option>
				<option <%= rs.getString("leave_type").equals("Maternity Leave") ? "selected" : "" %>>Maternity Leave</option>
				<option <%= rs.getString("leave_type").equals("Paternity Leave") ? "selected" : "" %>>Paternity Leave</option>
				<option <%= rs.getString("leave_type").equals("Bereavement Leave") ? "selected" : "" %>>Bereavement Leave</option>
				<option <%= rs.getString("leave_type").equals("Personal Leave") ? "selected" : "" %>>Personal Leave</option>
				<option <%= rs.getString("leave_type").equals("Marriage Leave") ? "selected" : "" %>>Marriage Leave</option>
				<option <%= rs.getString("leave_type").equals("Unpaid Leave") ? "selected" : "" %>>Unpaid Leave</option>
				<option <%= rs.getString("leave_type").equals("Study Leave") ? "selected" : "" %>>Study Leave</option>
				<option <%= rs.getString("leave_type").equals("Compensatory Off") ? "selected" : "" %>>Compensatory Off</option>
				<option <%= rs.getString("leave_type").equals("Annual Leave") ? "selected" : "" %>>Annual Leave</option>
				<option <%= rs.getString("leave_type").equals("Religious Leave") ? "selected" : "" %>>Religious Leave</option>
				<option <%= rs.getString("leave_type").equals("Medical Leave") ? "selected" : "" %>>Medical Leave</option>
				<option <%= rs.getString("leave_type").equals("Work From Home") ? "selected" : "" %>>Work From Home</option>
				<option <%= rs.getString("leave_type").equals("Half-Day Leave") ? "selected" : "" %>>Half-Day Leave</option>
				<option <%= rs.getString("leave_type").equals("Training Leave") ? "selected" : "" %>>Training Leave</option>
				<option <%= rs.getString("leave_type").equals("Jury Duty") ? "selected" : "" %>>Jury Duty</option>
				<option <%= rs.getString("leave_type").equals("Emergency Leave") ? "selected" : "" %>>Emergency Leave</option>
				<option <%= rs.getString("leave_type").equals("Others") ? "selected" : "" %>>Others</option>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">From Date</label>
            <input type="date" name="from_date" value="<%= rs.getString("from_date") %>" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">To Date</label>
            <input type="date" name="to_date" value="<%= rs.getString("to_date") %>" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Reason</label>
            <textarea name="reason" class="form-control" required><%= rs.getString("reason") %></textarea>
        </div>

        <button type="submit" class="btn btn-success">Update Leave</button>
        <a href="emp_dashboard.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</div>

<%
    rs.close();
    ps.close();
    con.close();
%>
<jsp:include page="footer_main.jsp" />
