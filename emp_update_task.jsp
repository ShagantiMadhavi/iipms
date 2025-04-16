<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>

<%@ page import="java.sql.*" %>
<%
//Validate session first
String empId = (String) session.getAttribute("emp_id");
if (empId == null || empId.trim().isEmpty()) {
    out.print("error|Unauthorized session. Please log in again.");
    return;
}

// Retrieve form parameters
String category = request.getParameter("category");
String taskTitle = request.getParameter("taskTitle");
String taskDesc = request.getParameter("taskDescription");
String percentCompleteParam = request.getParameter("percentComplete");
String taskCompletedDate = request.getParameter("taskCompletedDate"); // Optional
String taskIdParam = request.getParameter("taskId");
String assignedBy = request.getParameter("taskAssignedBy"); // New column

// Basic validation
if (taskIdParam == null || taskIdParam.trim().isEmpty()) {
    out.print("error|Task ID missing.");
    return;
}

int taskId = 0;
int percentComplete = 0;

try {
    taskId = Integer.parseInt(taskIdParam.trim());
    percentComplete = Integer.parseInt(percentCompleteParam.trim());
} catch (NumberFormatException e) {
    out.print("error|Invalid number format for Task ID or % Complete.");
    return;
}

Connection con = null;
PreparedStatement ps = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

    String sql = "UPDATE employee_tasks SET emp_id = ?, category = ?, task_title = ?, task_description = ?, percent_complete = ?, task_completed_date = ?, assigned_by = ? WHERE id = ?";
    ps = con.prepareStatement(sql);
    ps.setString(1, empId);
    ps.setString(2, category);
    ps.setString(3, taskTitle);
    ps.setString(4, taskDesc);
    ps.setInt(5, percentComplete);
    ps.setString(7, assignedBy); // assigned_by
    ps.setInt(8, taskId); // moved to position 8


    // Handle optional date field
    if (taskCompletedDate == null || taskCompletedDate.trim().isEmpty()) {
        ps.setNull(6, java.sql.Types.DATE);
    } else {
        try {
            ps.setDate(6, java.sql.Date.valueOf(taskCompletedDate.trim()));
        } catch (IllegalArgumentException e) {
            out.print("error|Invalid date format (expected yyyy-MM-dd)");
            return;
        }
    }

    ps.setString(7, assignedBy); // Set assigned_by
    ps.setInt(8, taskId);        // Task ID condition

    int rowsAffected = ps.executeUpdate();

    if (rowsAffected > 0) {
        out.print("success");
    } else {
        out.print("error|No task found with the provided ID.");
    }

} catch (Exception e) {
    e.printStackTrace();
    out.print("error|" + e.getMessage());
} finally {
    if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
    if (con != null) try { con.close(); } catch (SQLException ignore) {}
}
%>

