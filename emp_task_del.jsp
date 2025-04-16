<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>

<%
    // Check if user is logged in
    String empId = (String) session.getAttribute("emp_id");
    if (empId == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }

    String idParam = request.getParameter("id");

    if (idParam != null) {
        try {
            int taskId = Integer.parseInt(idParam); // ensure it's a valid integer

            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

            // Only delete the task if it belongs to the logged-in employee
            String sql = "DELETE FROM employee_tasks WHERE id = ? AND emp_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, taskId);
            ps.setString(2, empId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                out.print("success");
            } else {
                out.print("error|Task not found or not authorized");
            }

            ps.close();
            con.close();
        } catch (NumberFormatException e) {
            out.print("error|Invalid ID format");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("error|Database error");
        }
    } else {
        out.print("error|Missing ID");
    }
%>
