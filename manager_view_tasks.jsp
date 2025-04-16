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
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>

<%
    
    String managerId_ = (String) session.getAttribute("emp_id");
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>


<div class="container-fluid p-4" style="background-color: #f8f9fa; border-radius: 8px;">
  <h2 class="mb-4 text-success" style="font-weight: 600; border-bottom: 2px solid #198754; padding-bottom: 10px;">
    <i class="fas fa-tasks me-2"></i>Employee Task Details
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
    <th data-field="emp_id" data-sortable="true">Emp ID</th>
    <th data-field="category" data-sortable="true">Category</th>
    <th data-field="task_title" data-sortable="true">Task Title</th>
    <th data-field="task_description" data-sortable="true">Task Description</th>
    <th data-field="percent_complete" data-sortable="true">% Complete</th>
    <th data-field="created_at" data-sortable="true">Created At</th>
    <th data-field="task_completed_date" data-sortable="true">Completed Date</th>
    <th data-field="assigned_by" data-sortable="true">Assigned By</th>
  </tr>
</thead>
<tbody>
<%
    try {
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

        String query = "SELECT t.* FROM employee_tasks t JOIN employee74 e ON t.emp_id = e.emp_id WHERE e.manager_id = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, managerId_);
        rs = ps.executeQuery();

        int count = 1;
        while (rs.next()) {
%>
  <tr>
    <td><%= count++ %></td>
    <td><%= rs.getString("emp_id") %></td>
    <td><%= rs.getString("category") %></td>
    <td><%= rs.getString("task_title") %></td>
    <td><%= rs.getString("task_description") %></td>
    <td><%= rs.getInt("percent_complete") %> %</td>
    <td><%= rs.getTimestamp("created_at") %></td>
    <td><%= rs.getDate("task_completed_date") != null ? rs.getDate("task_completed_date") : "—" %></td>
    <td><%= rs.getString("assigned_by") != null ? rs.getString("assigned_by") : "—" %></td>
  </tr>
<%
        }
    } catch (SQLException e) {
        out.println("<p style='color:red;'>❌ Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
</tbody>

  </table>
</div>

<div id="toolbar">
  <button class="btn btn-outline-success" style="display:none;">
    <i class="fas fa-download me-2"></i>Export Data
  </button>
</div>

<script>
  $(document).ready(function() {
    $('#exportBtn').on('click', function() {
      $('#table').tableExport({ type: 'excel', fileName: 'employee_tasks' });
    });
  });
</script>
<jsp:include page="footer_main.jsp" />
</body>
</html>