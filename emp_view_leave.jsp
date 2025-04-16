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
    String empId = (String) session.getAttribute("emp_id");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
    PreparedStatement ps = con.prepareStatement("SELECT * FROM leave_requests WHERE emp_id = ?");
    ps.setString(1, empId);
    ResultSet rs = ps.executeQuery();
%>


<jsp:include page="header_main.jsp" />
<jsp:include page="emp_timesheet_header01.jsp" />

<div class="container-fluid p-4" style="background-color: #f8f9fa; border-radius: 8px;">
    <h2 class="mb-4 text-success" style="font-weight: 600; border-bottom: 2px solid #198754; padding-bottom: 10px;">
        <i class="fas fa-calendar-check me-2"></i>My Leave Applications
    </h2>

    <table id="myTable"
    data-toggle="table"
    data-pagination="true"
    data-search="true"
    data-show-columns="true"
    data-show-export="true"
    data-sortable="true"
    data-click-to-select="true"
    data-toolbar="#toolbar"
    class="table table-hover table-bordered table-striped" style="background-color: #ffffff;">
        <thead class="table-dark text-center">
            <tr style="font-weight: 600;">
                <th data-field="id" data-sortable="true">#</th>
                <th data-field="leave_type" data-filter-control="select" data-sortable="true">Leave Type</th>
                <th data-field="from_date" data-sortable="true">From</th>
                <th data-field="to_date" data-sortable="true">To</th>
                <th data-field="reason" data-sortable="true">Reason</th>
                <th 
  data-field="status"
  data-sortable="true"
  data-sorter="statusSorter"
>
  Status
</th>
                <th data-field="applied_on" data-sortable="true">Applied On</th>
                <th data-field="action">Action</th> <!-- Removed data-formatter -->
            </tr>
        </thead>
        <tbody>
            <%
                int count = 1;
                while (rs.next()) {
            %>
            <tr>
                <td><%= count++ %></td>
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
                <td>
                    <% if (rs.getString("status").equalsIgnoreCase("Pending")) { %>
                        <a href="emp_edit_leave.jsp?id=<%= rs.getInt("id") %>" class="btn btn-sm btn-warning me-1">Edit</a>
                        <a href="emp_delete_leave.jsp?id=<%= rs.getInt("id") %>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this leave request?');">Delete</a>
                    <% } else { %>
                        <span class="text-muted">Locked</span>
                    <% } %>
                </td>
            </tr>
            <%
                }
                con.close();
            %>
        </tbody>
    </table>
</div>

<div id="toolbar">
    <button class="btn btn-outline-success" style="display:none;">
        <i class="fas fa-download me-2" ></i>Export Data
    </button>
</div>


<script>
    $(document).ready(function() {
        // Custom export functionality (if required)
        $('#exportBtn').on('click', function() {
            $('#table').tableExport({type: 'excel', fileName: 'leave_applications'});
        });
    });
</script>

<script>
    function statusSorter(a, b) {
        // Extract the inner text (without HTML tags)
        const cleanA = $(a).text().trim().toLowerCase();
        const cleanB = $(b).text().trim().toLowerCase();
        return cleanA.localeCompare(cleanB);
    }

    $(document).ready(function () {
        $('#myTable').bootstrapTable(); // Re-initialize if needed
    });
</script>
<jsp:include page="footer_main.jsp" />

</body>
</html>
