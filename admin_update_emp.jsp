<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<jsp:include page="header_main.jsp" />

<%
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String empId = request.getParameter("emp_id");
    String message = "";

    String name = "", email = "", password = "", role = "", department = "", hire_date = "", phone_number = "", address = "", manager_id = "", role_type = "";

    if (request.getParameter("update") != null) {
        // Form submitted
        name = request.getParameter("name").trim();
        email = request.getParameter("email").trim();
        password = request.getParameter("password").trim();
        role = request.getParameter("role").trim();
        department = request.getParameter("department").trim();
        hire_date = request.getParameter("hire_date").trim();
        phone_number = request.getParameter("phone_number").trim();
        address = request.getParameter("address").trim();
        manager_id = request.getParameter("manager_id").trim();
        role_type = request.getParameter("role_type").trim();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

            PreparedStatement ps = con.prepareStatement(
                "UPDATE employee74 SET name=?, email=?, password=?, role=?, department=?, hire_date=?, phone_number=?, address=?, manager_id=?, role_type=? WHERE emp_id=?"
            );

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);
            ps.setString(5, department);
            ps.setString(6, hire_date);
            ps.setString(7, phone_number);
            ps.setString(8, address);
            ps.setString(9, manager_id);
            ps.setString(10, role_type);
            ps.setString(11, empId);

            int updated = ps.executeUpdate();
            message = (updated > 0) ? "✅ Employee updated successfully!" : "❌ Update failed!";

            ps.close();
            con.close();
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    } else {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

            PreparedStatement ps = con.prepareStatement("SELECT * FROM employee74 WHERE emp_id = ?");
            ps.setString(1, empId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                name = rs.getString("name");
                email = rs.getString("email");
                password = rs.getString("password");
                role = rs.getString("role");
                department = rs.getString("department");
                hire_date = rs.getString("hire_date");
                phone_number = rs.getString("phone_number");
                address = rs.getString("address");
                manager_id = rs.getString("manager_id");
                role_type = rs.getString("role_type");
            } else {
                message = "❌ No employee found with ID: " + empId;
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }
%>

<div class="container-fluid p-4">
    <div class="m-4">
        <form method="post" class="border p-4 rounded shadow-sm bg-light" style="max-width: 600px; margin: auto;">

            <div class="mb-3" style="display:none;">
                <input type="text" name="emp_id" class="form-control" value="<%= empId %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Name</label>
                <input type="text" name="name" class="form-control" value="<%= name %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" value="<%= email %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="text" name="password" class="form-control" value="<%= password %>" required>
            </div>

            <!-- Role Dropdown -->
            <div class="mb-3">
                <label class="form-label">Role</label>
                <select name="role" class="form-select" required>
                    <option value="" disabled <%= (role == null || role.isEmpty()) ? "selected" : "" %>>Select Job role</option>
                    <%
                        String[] roles = {"software_engineer", "product_manager", "data_analyst", "ux_designer", "project_manager",
                                          "qa_engineer", "business_analyst", "devops_engineer", "technical_writer", "it_support",
                                          "hr_manager", "marketing_specialist", "sales_executive", "finance_analyst",
                                          "customer_service_rep", "systems_admin", "network_engineer", "content_creator",
                                          "account_manager", "security_analyst"};
                        for (String r : roles) {
                    %>
                        <option value="<%= r %>" <%= r.equalsIgnoreCase(role != null ? role : "") ? "selected" : "" %>><%= r.replace("_", " ") %></option>
                    <% } %>
                </select>
            </div>

            <!-- Role Type Dropdown -->
            <div class="mb-3">
                <label class="form-label">Role Type</label>
                <select name="role_type" class="form-select" required>
                    <option value="" disabled <%= (role_type == null || role_type.isEmpty()) ? "selected" : "" %>>Select a role</option>
                    <option value="Admin" <%= "Admin".equalsIgnoreCase(role_type != null ? role_type : "") ? "selected" : "" %>>Admin</option>
                    <option value="Manager" <%= "Manager".equalsIgnoreCase(role_type != null ? role_type : "") ? "selected" : "" %>>Manager</option>
                    <option value="Employee" <%= "Employee".equalsIgnoreCase(role_type != null ? role_type : "") ? "selected" : "" %>>Employee</option>
                    <option value="Intern" <%= "Intern".equalsIgnoreCase(role_type != null ? role_type : "") ? "selected" : "" %>>Intern</option>
                </select>
            </div>

            <!-- Department Dropdown -->
            <div class="mb-3">
                <label class="form-label">Department</label>
                <select name="department" class="form-select" required>
                    <option value="" disabled <%= (department == null || department.isEmpty()) ? "selected" : "" %>>Select department</option>
                    <%
                        String[] departments = {"HR", "Development", "Marketing", "Finance", "QA", "Support", "BDM", "Vice Counsellor", "Sales", "Training"};
                        for (String d : departments) {
                    %>
                        <option value="<%= d %>" <%= d.equalsIgnoreCase(department != null ? department : "") ? "selected" : "" %>><%= d %></option>
                    <% } %>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Hire Date</label>
                <input type="date" class="form-control" name="hire_date" value="<%= hire_date %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Phone No</label>
                <input type="text" name="phone_number" class="form-control" value="<%= phone_number %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Address</label>
                <input type="text" name="address" class="form-control" value="<%= address %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Manager ID</label>
                <input type="text" name="manager_id" class="form-control" value="<%= manager_id != null ? manager_id : "" %>">
            </div>

            <div class="d-grid gap-2">
                <button type="submit" name="update" class="btn btn-primary">✏️ Update Employee</button>
                <a href="admin_dashboard.jsp" class="btn btn-secondary">⬅ Back to Dashboard</a>
            </div>

            <% if (!message.isEmpty()) { %>
                <div class="mt-3 alert alert-info text-center"><%= message %></div>
            <% } %>
        </form>
    </div>
</div>
</body>
</html>
