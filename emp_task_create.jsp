<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }

    // Retrieve form data
    String empId = (String) session.getAttribute("emp_id");
    String category = request.getParameter("category");
    String taskTitle = request.getParameter("taskTitle");
    String taskDesc = request.getParameter("taskDescription");
    String percentCompleteParam = request.getParameter("percentComplete");
    String assignedBy = request.getParameter("taskAssignedBy");

    int percentComplete = 0;
    try {
        percentComplete = Integer.parseInt(percentCompleteParam != null ? percentCompleteParam : "0");
        if (percentComplete < 0 || percentComplete > 100) {
            out.print("error|Percent complete must be between 0 and 100");
            return;
        }
    } catch (NumberFormatException e) {
        out.print("error|Invalid percent complete value");
        return;
    }

    // Establish database connection
    Connection con = null;
    PreparedStatement ps = null;

    try {
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

        // SQL query to insert task
        String sql = "INSERT INTO employee_tasks (emp_id, category, task_title, task_description, percent_complete, assigned_by) VALUES (?, ?, ?, ?, ?, ?)";
        ps = con.prepareStatement(sql);
        ps.setString(1, empId);
        ps.setString(2, category);
        ps.setString(3, taskTitle);
        ps.setString(4, taskDesc);
        ps.setInt(5, percentComplete);
        ps.setString(6, assignedBy);

        int inserted = ps.executeUpdate();

        if (inserted > 0) {
            out.print("success");
        } else {
            out.print("error|Failed to save task");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.print("error|" + e.getMessage());
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
