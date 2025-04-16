<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>
<%@ include file="header_main.jsp" %>

<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%
    // Define global variables
    String managerId_ = null;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Database connection
    try {
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
    } catch (SQLException e) {
        out.println("Error: Unable to connect to the database. " + e.getMessage());
        return;
    }

    // Retrieve the manager's emp_id from the session
    managerId_ = (String) session.getAttribute("emp_id");

    if (managerId_ == null) {
        out.println("<p style='color:red;'>❌ Error: Manager ID is missing. Please log in again.</p>");
        return;
    }
%>

<%
    // Ensure the user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return;
    }

    
%>


<div class="container-fluid p-4" style="background-color: #f8f9fa; border-radius: 8px;">
   <h2 class="mb-4 text-success" style="font-weight: 600; border-bottom: 2px solid #198754; padding-bottom: 10px;">
    <i class="fas fa-address-card me-2"></i>My Employee Details
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
    class="table table-hover table-bordered table-striped text-break" style="background-color: #ffffff;">
        <thead class="table-dark text-center">
            <tr style="font-weight: 600;">
                <th data-field="id" data-sortable="true">#</th>
                <th data-field="emp_id" data-filter-control="select" data-sortable="true">EmpId</th>
                <th data-field="name" data-sortable="true">Name</th>
                <th data-field="email" data-sortable="true">Email</th>
                <th data-field="role" data-sortable="true">Role</th>
                <th data-field="department" data-filter-control="select" data-sortable="true">Dept</th>
                <th data-field="role_type" data-sortable="true">RoleType</th>
                
                           	<th data-field="phone_number" data-sortable="true">PhoneNo</th>
                           	 <th data-field="address" data-sortable="true">Address</th> <!-- Removed data-formatter -->
                           	
            </tr>
        </thead>
        <tbody>
            
             <%
    int count = 1;
    try {
        // Query to retrieve employees under the logged-in manager
        String query = "SELECT emp_id, name, email, role, department, role_type, phone_number, address FROM employee74 WHERE manager_id = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, managerId_);
        rs = ps.executeQuery();

        // Process the result set and display the employee data
        while (rs.next()) {
            String empId = rs.getString("emp_id");
            String empName = rs.getString("name");
            String empEmail = rs.getString("email");
            String empRole = rs.getString("role");
            String empDept = rs.getString("department");
            String empRoletype = rs.getString("role_type");
            String empPhone = rs.getString("phone_number");
            String empAddress = rs.getString("address");
%>
            <tr>
                <td><%= count++ %></td>
                <td><%= empId %></td>
                <td><%= empName %></td>
                <td><%= empEmail %></td>
                <td><%= empRole %></td>
                <td><%= empDept %></td>
                <td><%= empRoletype %></td>
                <td><%= empPhone %></td>
                <td><%= empAddress %></td>
            </tr>
<%
        }
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error: Unable to execute query. " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("<p style='color:red;'>Error: Unable to close resources. " + e.getMessage() + "</p>");
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