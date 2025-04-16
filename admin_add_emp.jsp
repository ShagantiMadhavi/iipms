<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("IIPMS/login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>
    <jsp:include page="header_main.jsp" />
    
<%@ page import="java.sql.*" %>

<div class="container mt-5">
    <h3 class="text-center text-primary mb-4">➕ Add New Employee</h3>

    <%
        String message = "";
        if (request.getParameter("add") != null) {
            String empId = request.getParameter("emp_id").trim();
            String name = request.getParameter("name").trim();
            String email = request.getParameter("email").trim();
            String password = request.getParameter("password").trim();
            String role = request.getParameter("role").trim();
            String role_type = request.getParameter("role_type").trim();
            String hire_date = request.getParameter("hire_date").trim();
            String department = request.getParameter("department").trim();
            String phone_number = request.getParameter("phone_number").trim();
            String address = request.getParameter("address").trim();
            String manager_id = request.getParameter("manager_id").trim();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

                PreparedStatement ps = con.prepareStatement(
                		  "INSERT INTO employee74(emp_id, name, email, password, role, department, hire_date, phone_number, address, manager_id, role_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                		);

                ps.setString(1, empId);
                ps.setString(2, name);
                ps.setString(3, email);
                ps.setString(4, password);
                ps.setString(5, role);
                ps.setString(6, department);
                ps.setString(7, hire_date);
                ps.setString(8, phone_number);
                ps.setString(9, address);
               
                if (manager_id == null || manager_id.equals("")) {
                    ps.setNull(10, java.sql.Types.VARCHAR);
                } else {
                    ps.setString(10, manager_id);
                }
                ps.setString(11, role_type);


                int inserted = ps.executeUpdate();
                message = (inserted > 0) ? "✅ Employee added successfully!" : "❌ Failed to add employee!";

                ps.close();
                con.close();
            } catch (Exception e) {
                message = "❌ Error: " + e.getMessage();
            }
        }
    %>

    <form method="post" class="border p-4 rounded shadow-sm bg-light" style="max-width: 600px; margin: auto;">
        <div class="mb-3">
            <label class="form-label">Employee ID</label>
            <input type="text" name="emp_id" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Name</label>
            <input type="text" name="name" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="text" name="password" class="form-control" required>
        </div>

		<div class="mb-3">
  <label class="form-label">Role</label>
  <select name="role" class="form-select" required>
    <option value="" disabled selected>Select Job role</option>
    <option value="software_engineer">Software Engineer</option>
    <option value="product_manager">Product Manager</option>
    <option value="data_analyst">Data Analyst</option>
    <option value="ux_designer">UX Designer</option>
    <option value="project_manager">Project Manager</option>
    <option value="qa_engineer">QA Engineer</option>
    <option value="business_analyst">Business Analyst</option>
    <option value="devops_engineer">DevOps Engineer</option>
    <option value="technical_writer">Technical Writer</option>
    <option value="it_support">IT Support</option>
    <option value="hr_manager">HR Manager</option>
    <option value="marketing_specialist">Marketing Specialist</option>
    <option value="sales_executive">Sales Executive</option>
    <option value="finance_analyst">Finance Analyst</option>
    <option value="customer_service_rep">Customer Service Rep</option>
    <option value="systems_admin">Systems Administrator</option>
    <option value="network_engineer">Network Engineer</option>
    <option value="content_creator">Content Creator</option>
    <option value="account_manager">Account Manager</option>
    <option value="security_analyst">Security Analyst</option>
  </select>
</div>

        <div class="mb-3">
            <label class="form-label">RoleType</label>
             <select name="role_type" class="form-select" required>
		    <option value="" disabled selected>Select a role</option>
		    <option value="Admin">Admin</option>
		    <option value="Manager">Manager</option>
		    <option value="Employee">Employee</option>
		     </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Department</label>
           <select name="department" class="form-select">
		    <option value="" disabled selected>Select department</option>
		    <option value="HR">HR</option>
		    <option value="Development">Development</option>
		    <option value="Marketing">Marketing</option>
		    <option value="Finance">Finance</option>
		    <option value="QA">QA</option>
		    <option value="Support">Support</option>
		    <option value="BDM">BDM</option>
		    <option value="Vice Counsellor">Vice Counsellor</option>
		    <option value="Sales">Sales</option>
		    <option value="Training">Training</option>
		</select>
        </div>
        
        <div class="mb-3">
            <label for="dateInput" class="form-label">HireDate</label>
  <input type="date" class="form-control" name="hire_date" id="dateInput" required>
        </div>
        
        <div class="mb-3">
            <label class="form-label">PhoneNo</label>
            <input type="number" name="phone_number" class="form-control" required>
        </div>
<div class="mb-3">
            <label class="form-label">Address</label>
            <input type="text" name="address" class="form-control" required>
        </div>

        

        <div class="mb-3">
            <label class="form-label">Manager ID</label>
            <input type="text" name="manager_id" class="form-control" required>
        </div>

        <div class="d-grid gap-2">
            <button type="submit" name="add" class="btn btn-success">➕ Add Employee</button>
            <a href="admin_dashboard.jsp" class="btn btn-secondary">⬅ Back to Dashboard</a>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="mt-3 alert alert-info text-center"><%= message %></div>
        <% } %>
    </form>
</div>
<jsp:include page="footer_main.jsp" />

</body>
</html>