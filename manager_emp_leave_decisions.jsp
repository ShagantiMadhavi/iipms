<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>
<%@ page import="java.sql.*" %>
<%--

<%
    String filter = request.getParameter("filter");
    String action = request.getParameter("action");
    String leaveId = request.getParameter("leave_id");

    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

    if (action != null && leaveId != null) {
        PreparedStatement updateStmt = conn.prepareStatement("UPDATE leave_requests SET status=? WHERE id=?");
        updateStmt.setString(1, action);
        updateStmt.setInt(2, Integer.parseInt(leaveId));
        updateStmt.executeUpdate();
        response.sendRedirect("manager_emp_leave_decisions.jsp?filter=Pending");
        return;
    }

    PreparedStatement ps = conn.prepareStatement("SELECT lr.*, e.name FROM leave_requests lr JOIN employee e ON lr.emp_id = e.emp_id WHERE lr.status = ?");
    ps.setString(1, filter);
    ResultSet rs = ps.executeQuery();
%>

 --%>











<%
    String filter = request.getParameter("filter");
    String action = request.getParameter("action");
    String leaveId = request.getParameter("leave_id");

    if (filter == null || filter.trim().isEmpty()) {
        filter = "Pending"; // Default to Pending
    }

    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

    if (action != null && leaveId != null) {
        PreparedStatement updateStmt = conn.prepareStatement("UPDATE leave_requests SET status=? WHERE id=?");
        updateStmt.setString(1, action);
        updateStmt.setInt(2, Integer.parseInt(leaveId));
        updateStmt.executeUpdate();
        response.sendRedirect("manager_emp_leave_decisions.jsp?filter=Pending");
        return;
    }

    PreparedStatement ps;
    if ("All".equalsIgnoreCase(filter)) {
        ps = conn.prepareStatement("SELECT lr.*, e.name FROM leave_requests lr JOIN employee74 e ON lr.emp_id = e.emp_id");
    } else {
        ps = conn.prepareStatement("SELECT lr.*, e.name FROM leave_requests lr JOIN employee74 e ON lr.emp_id = e.emp_id WHERE lr.status = ?");
        ps.setString(1, filter);
    }
    ResultSet rs = ps.executeQuery();

%>


<jsp:include page="header_main.jsp" />












<div class="container-fluid p-4" style="background-color: #f8f9fa; border-radius: 8px;">
   <!-- Inline CSS for hover effect -->
<h2 class="mb-4" style="font-weight: 600; color: #007bff; border-bottom: 2px solid #007bff; padding-bottom: 10px; transition: all 0.3s ease;" onmouseover="this.style.color='#ff5722'; this.style.borderBottom='2px solid #ff5722'" onmouseout="this.style.color='#007bff'; this.style.borderBottom='2px solid #007bff'">
    <i class="fas fa-calendar-check me-2"></i>Employee Leave Applications - <%= filter %>
</h2>

<!-- Filter Buttons -->
<div class="mb-4 d-flex gap-2">
    <a href="manager_emp_leave_decisions.jsp?filter=Pending" class="btn btn-outline-warning <%= "Pending".equals(filter) ? "active" : "" %>">Pending</a>
    <a href="manager_emp_leave_decisions.jsp?filter=Approved" class="btn btn-outline-success <%= "Approved".equals(filter) ? "active" : "" %>">Approved</a>
    <a href="manager_emp_leave_decisions.jsp?filter=Rejected" class="btn btn-outline-danger <%= "Rejected".equals(filter) ? "active" : "" %>">Rejected</a>
	<a href="manager_emp_leave_decisions.jsp?filter=All" class="btn btn-outline-primary <%= "All".equals(filter) ? "active" : "" %>">All</a>
	
</div>

       <div class="mt-3">
	        <a href="manager_dashboard.jsp" class="btn btn-outline-secondary" style="font-weight: 600;">
	            <i class="fas fa-arrow-left me-2"></i>Go Back
	        </a>
    	</div>
    
    <h4 class="text-primary mb-3">
        
    </h4>

    <table 
        id="leaveTable"
        data-toggle="table"
        data-search="true"
        data-pagination="true"
        data-show-columns="true"
        data-show-export="true"
        data-click-to-select="true"
        class="table table-bordered table-hover table-striped"
    >
        <thead class="table-dark text-center">
            <tr><th data-field="id" data-sortable="true">#</th>
            
                <th data-field="emp_id" data-sortable="true">Employee</th>
                <th data-field="leave_type" data-sortable="true">Leave Type</th>
                <th data-field="from" data-sortable="true">From</th>
                <th data-field="to" data-sortable="true">To</th>
                <th data-field="reason" data-sortable="true">Reason</th>
                
                <th data-field="applied_on" data-sortable="true">Applied On</th>
                <% if ("Pending".equals(filter)) { %>
                    <th data-field="action">Action</th>
                <% } %>
                
                <th data-field="status" data-sortable="true">Status</th>
            </tr>
        </thead>
        <tbody>
            <%
            int count = 1;
                boolean hasData = false;
                while (rs.next()) {
                    hasData = true;
            %>
            <tr class="text-center align-middle">
            <td><%= count++ %></td>
                <td title="<%= rs.getString("name") %>"><%= rs.getString("emp_id") %></td>
                <td><%= rs.getString("leave_type") %></td>
                <td><%= rs.getDate("from_date") %></td>
                <td><%= rs.getDate("to_date") %></td>
                <td><%= rs.getString("reason") %></td>
                
                <td><%= rs.getTimestamp("applied_on") %></td>
                <% if ("Pending".equals(filter)) { %>
                    <td>
                        <div class="d-flex gap-2 justify-content-center">
                            <a href="manager_emp_leave_decisions.jsp?action=Approved&leave_id=<%= rs.getInt("id") %>&filter=Pending" class="btn btn-success btn-sm">Approve</a>
                            <a href="manager_emp_leave_decisions.jsp?action=Rejected&leave_id=<%= rs.getInt("id") %>&filter=Pending" class="btn btn-danger btn-sm">Reject</a>
                        </div>
                    </td>
                <% } %>
                
                <td>
                    <span class="badge bg-<%= rs.getString("status").equalsIgnoreCase("Approved") ? "success" : rs.getString("status").equalsIgnoreCase("Rejected") ? "danger" : "warning" %>">
                        <%= rs.getString("status") %>
                    </span>
                </td>
            </tr>
            <% } %>
            <% if (!hasData) { %>
                <tr>
                    <td colspan="8" class="text-center text-muted">No <%= filter %> leave requests found.</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>

<!-- Optional Export Toolbar -->
<div id="toolbar" class="mt-3">
    <button id="exportBtn" class="btn btn-outline-success">
        <i class="fas fa-download me-2"></i>Export Data
    </button>
</div>

<script>
    $(document).ready(function() {
        $('#exportBtn').on('click', function() {
            $('#leaveTable').tableExport({
                type: 'excel',
                fileName: 'leave_applications_<%= filter %>'
            });
        });
    });
</script>

<jsp:include page="footer_main.jsp" />
</body>
</html>
