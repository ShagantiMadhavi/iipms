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
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>

<%
    String empId = null;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Create a connection to the database
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
    } catch (SQLException e) {
        out.println("<div class='alert alert-danger'>❌ Error: Unable to connect to the database.</div>");
        return;
    }

    // Retrieve the employee's emp_id from the session
    empId = (String) session.getAttribute("emp_id");

    if (empId == null) {
        out.println("<div class='alert alert-danger'>❌ Error: Employee ID is missing. Please log in again.</div>");
        return;
    }
%>










<div class="container-fluid p-4" style="background-color: #f8f9fa; border-radius: 8px;">
   <h2 class="mb-4 text-success" style="font-weight: 600; border-bottom: 2px solid #198754; padding-bottom: 10px;">
    <i class="fas fa-address-card me-2"></i>My Attendance Report
</h2>
  <div class="mt-3">
	        <a href="admin_dashboard.jsp" class="btn btn-outline-secondary" style="font-weight: 600;">
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
    class="table table-hover table-bordered table-striped text-break" style="background-color: #ffffff;">
        <thead class="table-dark text-center">
            <tr style="font-weight: 600;">
                <th data-field="id" data-sortable="true">#</th>
                
                 <th data-field="check_in_time" data-sortable="true">logIn</th> <!-- Removed data-formatter -->
                
                
                <th data-field="check_out_time" data-sortable="true">logOut</th>
                <th data-field="address" data-sortable="true">TotalWorkedTime</th>
               
                           </tr>
        </thead>
        <tbody>
            
            <%
    try {
        String query = "SELECT id, check_in_time, check_out_time, total_worked_time FROM timesheet10 WHERE emp_id = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, empId); 
        rs = ps.executeQuery();

        int count = 1; // Counter for S.No

        while (rs.next()) {
            // You can still fetch the 'id' if needed internally, but not display it
            // String employeeId = rs.getString("id");

            Timestamp checkInTime = rs.getTimestamp("check_in_time");
            Timestamp checkOutTime = rs.getTimestamp("check_out_time");
            String totalWorkedTime = rs.getString("total_worked_time");

            String formattedCheckInTime = (checkInTime != null) ? checkInTime.toString() : "N/A";
            String formattedCheckOutTime = (checkOutTime != null) ? checkOutTime.toString() : "N/A";
            String formattedTotalWorkedTime = (totalWorkedTime != null) ? totalWorkedTime : "N/A";
%>
            <tr>
                <td><%= count++ %></td>
                
                <td><%= checkInTime %></td>
                <td><%= checkOutTime %></td>
                 <td><%= totalWorkedTime %></td>
               
            </tr>
<%
        }

    } catch (SQLException e) {
        out.println("<div class='alert alert-danger'>❌ Error: Unable to execute query.</div>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("<div class='alert alert-danger'>❌ Error: Unable to close database resources.</div>");
        }
    }
%>
        </tbody>
    </table>
</div>

<div id="toolbar" style="display:none;">
    <button id="exportBtn" class="btn btn-outline-success">
        <i class="fas fa-download me-2"></i>Export Data
    </button>
</div>

<script>
    $(document).ready(function() {
        $('#exportBtn').on('click', function() {
            $('#myTable').tableExport({
                type: 'excel',
                fileName: 'Employee_Details'
            });
        });
    });
</script>
<jsp:include page="footer_main.jsp" />

</body>
</html>