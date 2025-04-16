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

<div class="container mt-5">

 <button type="button" class="btn btn-info"> <a href="admin_dashboard.jsp">go back</a></button>
		
    <div class="d-flex justify-content-between align-items-center mb-3 mt-3">
        <h3 class="text-primary">👨‍💼 All Employees</h3>
        <a href="admin_add_emp.jsp" class="btn btn-success">
            <i class="bi bi-plus-circle"></i> Add Employee
        </a>
    </div>

    <% if (!message.isEmpty()) { %>
    <div class="alert alert-info text-center"><%= message %></div>

    <!-- 🔄 Auto-refresh page after 2 seconds -->
    <script>
        setTimeout(function() {
            window.location.href = "admin_dashboard.jsp"; // reload same page
        }, 2000); // 2 seconds
    </script>
<% } %>


    <table class="table table-bordered table-striped table-responsive text-break">
        <thead class="table-dark">
            <tr>
            	<th class="w-5">S.No</th>
                <th >EmpID</th>
                <th>Name</th>
                <th>Email</th>
                <th style="display:none;">Password</th>
                <th>Role</th>
                <th>RoleType</th>
                <th>Department</th>
                <th>HireDate</th>
                <th>PhoneNo</th>
                <th>Address</th>
                <th>ManagerID</th>           
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
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
             <td class="w-5"><%= sno++ %></td> <!-- Serial number -->
                <td><%= empId %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("email") %></td>
                <td style="display:none;"><%= rs.getString("password") %></td>
                <td><%= rs.getString("role") %></td>
                <td><%= rs.getString("role_type") %></td>
                <td><%= rs.getString("department") %></td>
                <td><%= rs.getString("hire_date") %></td>
                <td><%= rs.getString("phone_number") %></td>
                <td><%= rs.getString("address") %></td>
                <td><%= rs.getString("manager_id") != null ? rs.getString("manager_id") : "N/A" %></td>
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
</body>
</html>
