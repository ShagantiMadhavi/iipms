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
    // Get session employee ID
    String empId = (String) session.getAttribute("emp_id");

    if (empId == null || empId.trim().isEmpty()) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get parameters
    int taskId = Integer.parseInt(request.getParameter("id"));
    String category = request.getParameter("category");
    String taskTitle = request.getParameter("task_title");
    String taskDescription = request.getParameter("task_description");
    String percentCompleteStr = request.getParameter("percent_complete");

    // Validation
    if (taskTitle == null || taskTitle.trim().isEmpty()) {
        response.sendRedirect("emp_view_tasks.jsp?msg=Task title is required");
        return;
    }

    int percentComplete = 0;
    try {
        percentComplete = Integer.parseInt(percentCompleteStr);
        if (percentComplete < 0 || percentComplete > 100) {
            response.sendRedirect("emp_view_tasks.jsp?msg=Percent must be between 0 and 100");
            return;
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("emp_view_tasks.jsp?msg=Invalid percent value");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

        String sql = "UPDATE employee_tasks SET category = ?, task_title = ?, task_description = ?, percent_complete = ? WHERE id = ? AND emp_id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, category);
        ps.setString(2, taskTitle);
        ps.setString(3, taskDescription);
        ps.setInt(4, percentComplete);
        ps.setInt(5, taskId);
        ps.setString(6, empId);

        int updated = ps.executeUpdate();
        con.close();

        if (updated > 0) {
            response.sendRedirect("emp_view_tasks.jsp?msg=Task updated successfully");
        } else {
            response.sendRedirect("emp_view_tasks.jsp?msg=Update failed or not authorized");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("emp_view_tasks.jsp?msg=Database error: " + e.getMessage());
    }
%>
