<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>

<%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>
<%@ include file="header_main.jsp" %>

<%
    // Define global variables
    String managerId = null;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        // Establish database connection
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
    } catch (SQLException e) {
        out.println("<p style='color:red;'>❌ Error: Unable to connect to the database. " + e.getMessage() + "</p>");
        return;
    }
    
    // Retrieve manager's emp_id from session
    managerId = (String) session.getAttribute("emp_id");

    if (managerId == null) {
        out.println("<p style='color:red;'>❌ Error: Manager ID is missing. Please log in again.</p>");
        return;
    }
%>

<div class="container-fluid p-4" style="background-color: #f8f9fa; border-radius: 8px;">
    <h2 class="mb-4 text-success" style="font-weight: 600; border-bottom: 2px solid #198754; padding-bottom: 10px;">
        <i class="fas fa-calendar-check me-2"></i>Employee Attendance Details
    </h2>
	  <div class="mt-3">
	        <a href="manager_dashboard.jsp" class="btn btn-outline-secondary" style="font-weight: 600;">
	            <i class="fas fa-arrow-left me-2"></i>Go Back
	        </a>
    	</div>
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
                <th data-field="emp_id" data-sortable="true">EmpId</th>
                <th data-field="name" data-sortable="true">Name</th>
                <th data-field="check_in_time" data-sortable="true">LogIn</th>
                <th data-field="check_out_time" data-sortable="true">LogOut</th> <!-- Removed data-formatter -->
            	 <th data-field="total_worked_time" data-sortable="true">TotaLoggedTime</th> <!-- Removed data-formatter -->
            	
            </tr>
        </thead>
        <tbody>
            
             <%
    int count = 1;
             try {
                 // Query to fetch employees managed by the logged-in manager along with their attendance records
                 String query = "SELECT e.emp_id, e.name, t.check_in_time, t.check_out_time, t.total_worked_time " +
                                "FROM employee74 e " +
                                "JOIN timesheet10 t ON e.emp_id = t.emp_id " +
                                "WHERE e.manager_id = ? " +
                                "ORDER BY t.check_in_time DESC"; // Sort by recent check-in

                 ps = con.prepareStatement(query);
                 ps.setString(1, managerId); 
                 rs = ps.executeQuery();
                 
                 // Process the result set and display data
                 while (rs.next()) {
                     String employeeId = rs.getString("emp_id");
                     String employeeName = rs.getString("name"); 
                     Timestamp checkInTime = rs.getTimestamp("check_in_time");
                     Timestamp checkOutTime = rs.getTimestamp("check_out_time");
                     String totalWorkedTime = rs.getString("total_worked_time");

                     // Format timestamps (yyyy-MM-dd HH:mm:ss)
                     DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                     String formattedCheckIn = (checkInTime != null) ? checkInTime.toLocalDateTime().format(formatter) : "N/A";
                     String formattedCheckOut = (checkOutTime != null) ? checkOutTime.toLocalDateTime().format(formatter) : "N/A";
         %>
            <tr>
                <td><%= count++ %></td>
                <td><%= employeeId %></td>
                <td><%= employeeName %></td>
                <td><%= checkInTime %></td>
                 <td><%= checkOutTime %></td>
                <td><%= totalWorkedTime %></td>
                
            </tr>
<%
                }
            } catch (SQLException e) {
                out.println("<p style='color:red;'>❌ Error: Unable to execute query. " + e.getMessage() + "</p>");
            } finally {
                // Close the database resources
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                } catch (SQLException e) {
                    out.println("<p style='color:red;'>❌ Error: Unable to close resources. " + e.getMessage() + "</p>");
                }
            }
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
<jsp:include page="footer_main.jsp" />
</body>
</html>
