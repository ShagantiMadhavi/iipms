<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>

<%
    String empTaskIdParam = request.getParameter("id");

    if (empTaskIdParam == null || empTaskIdParam.isEmpty()) {
        out.print("error|Task ID is missing");
        return;
    }

    int empTaskId = 0;
    try {
        empTaskId = Integer.parseInt(empTaskIdParam);
    } catch (NumberFormatException e) {
        out.print("error|Invalid Task ID");
        return;
    }

    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
    PreparedStatement ps = con.prepareStatement("SELECT * FROM employee_tasks WHERE id = ?");
    ps.setInt(1, empTaskId);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        out.print(rs.getInt("id") + "|" 
                + rs.getString("emp_id") + "|" 
                + rs.getString("category") + "|" 
                + rs.getString("task_title") + "|" 
                + rs.getString("task_description") + "|" 
                + rs.getInt("percent_complete") + "|" 
                + (rs.getString("task_completed_date") != null ? rs.getString("task_completed_date") : "") + "|" 
                + (rs.getString("assigned_by") != null ? rs.getString("assigned_by") : ""));
    } else {
        out.print("error|No task found");
    }

    rs.close();
    ps.close();
    con.close();
%>

