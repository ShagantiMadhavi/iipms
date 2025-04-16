<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>




<jsp:include page="header_main.jsp" />




<%@ page import="java.sql.*" %>

<%
    String message = "";

    // 🔥 Handle POST-based delete (no URL param)
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("delete_emp_id") != null) {
        String deleteId = request.getParameter("delete_emp_id").trim();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
            PreparedStatement ps = con.prepareStatement("DELETE FROM employee74 WHERE emp_id = ?");
            ps.setString(1, deleteId);
            int result = ps.executeUpdate();
            ps.close();
            con.close();

            if (result > 0) {
                message = "✅ Employee with ID " + deleteId + " deleted successfully.";
            } else {
                message = "❌ Failed to delete employee with ID " + deleteId;
            }
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }
%>



<div class="container-fluid p-4" style="background-color: #f8f9fa; border-radius: 8px;">
   <h2 class="mb-4 text-success" style="font-weight: 600; border-bottom: 2px solid #198754; padding-bottom: 10px;">
    <i class="fas fa-address-card me-2"></i>Employee Details
</h2>
 

    <% if (!message.isEmpty()) { %>
    <div class="alert alert-info text-center"><%= message %></div>
    
    

    <!-- 🔄 Auto-refresh page after 2 seconds -->
    <script>
        setTimeout(function() {
            window.location.href = "admin_dashboard.jsp"; // reload same page
        }, 2000); // 2 seconds
    </script>
<% } %>

 <div class="mt-3 d-flex justify-content-between align-items-center">

    <!-- Left-side: Go Back Button -->
    <a href="admin_dashboard.jsp"
       class="btn btn-outline-secondary"
       style="font-weight: 600;">
        <i class="fas fa-arrow-left me-2"></i>Go Back
    </a>

    <!-- Right-side: Add Button  -->
    <a href="admin_add_emp.jsp"
       class="btn btn-outline-primary"
       style="font-weight: 600;">
        <i class="bi bi-plus-circle"></i> Add Employee
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
                <!-- 
                <th data-visible="false" data-sortable="true" style="display:none;">Password</th>
                 -->
                <th data-field="role" data-sortable="true">Role</th>
                <th data-field="department" data-filter-control="select" data-sortable="true">Dept</th>
                <th data-field="role_type" data-sortable="true">RoleType</th>
                <th data-field="hire_date" data-sortable="true">HireDate</th>
                 <th data-field="manager_id" data-sortable="true">ManagerId</th> <!-- Removed data-formatter -->
                
                
                <th data-field="phone_number" data-sortable="true">PhoneNo</th>
                <th data-field="address" data-sortable="true">Address</th>
                <th data-field="action" data-sortable="false">Action</th>
                           </tr>
        </thead>
        <tbody>
            
           <%
           int count = 1;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
                PreparedStatement ps = con.prepareStatement("SELECT * FROM employee74");
                ResultSet rs = ps.executeQuery();

                boolean hasData = false;
                int sno = 1;
                while (rs.next()) {
                    hasData = true;
                    String empId = rs.getString("emp_id");
        %>
            <tr>
                <td><%= count++ %></td>
                <td><%= empId %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("email") %></td>
                <!-- 
                <td style="display:none;"><%= rs.getString("password")%></td>
                 -->
                
                <td><%= rs.getString("role") %></td>
                <td><%= rs.getString("department") %></td>
                <td><%= rs.getString("role_type") %></td>
                <td><%= rs.getString("hire_date") %></td>
                <td><%= rs.getString("manager_id")  != null ? rs.getString("manager_id") : "N/A"  %></td>
                <td><%= rs.getString("phone_number") %></td>
                <td><%= rs.getString("address") %></td>
                 <td>
                    <a href="admin_update_emp.jsp?emp_id=<%= empId %>" class="btn btn-sm btn-warning me-1">
                        <i class="bi bi-pencil-square"></i>
                    </a>

                    <!-- 🔒 Delete using POST -->
                    <form method="post" style="display:inline;" onsubmit="return confirm('Are you sure to delete this employee?');">
                        <input type="hidden" name="delete_emp_id" value="<%= empId %>">
                        <button type="submit" class="btn btn-sm btn-danger">
                            <i class="bi bi-trash"></i>
                        </button>
                    </form>
                </td>
            </tr>
<%
                }

                if (!hasData) {
        %>
            <tr>
                <td colspan="8" class="text-center text-danger">No employee records found.</td>
            </tr>
        <%
                }

                rs.close();
                ps.close();
                con.close();
            } catch (Exception e) {
        %>
            <tr>
                <td colspan="8" class="text-danger">Error: <%= e.getMessage() %></td>
            </tr>
        <%
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
<jsp:include page="footer_main.jsp" />

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

</body>
</html>
