<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date, java.text.ParseException" %>

<%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>
<%
    String empId = request.getParameter("emp_id");
    String checkInTime = request.getParameter("check_in_time");
    String checkOutTime = request.getParameter("check_out_time");

    if (empId == null || empId.trim().isEmpty()) {
        out.println("❌ Error: Employee ID is missing.");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

        // Step 1: Check if employee has already checked in today
        String checkQuery = "SELECT check_in_time, check_out_time FROM timesheet10 WHERE emp_id = ? AND DATE(check_in_time) = CURDATE()";
        ps = con.prepareStatement(checkQuery);
        ps.setString(1, empId);
        rs = ps.executeQuery();

        if (rs.next()) { 
            // Employee already checked in
            String existingCheckIn = rs.getString("check_in_time");
            String existingCheckOut = rs.getString("check_out_time");

            if (existingCheckOut != null) {
                out.print("⚠️ You have already checked in and checked out today. No further updates allowed.");
            } else if (checkOutTime != null && !checkOutTime.trim().isEmpty()) {
                // Step 2: Update Check-Out Time
                checkOutTime = getFormattedDate(checkOutTime);

             // Step 3: Update Check-Out Time and Calculate Total Worked Time
                String updateQuery = "UPDATE timesheet10 " +
                                     "SET check_out_time = ?, " +
                                     "    total_worked_time = TIMEDIFF(?, check_in_time) " +
                                     "WHERE emp_id = ? AND DATE(check_in_time) = CURDATE()";
                ps = con.prepareStatement(updateQuery);
                ps.setString(1, checkOutTime);
                ps.setString(2, checkOutTime);  // Used for TIMEDIFF calculation
                ps.setString(3, empId);

                int result = ps.executeUpdate();
                if (result > 0) {
                    out.print("✅ Check-out recorded successfully!<br>");
                    
                    // Fetch Total Worked Time to Display
                    String totalTimeQuery = "SELECT total_worked_time FROM timesheet10 WHERE emp_id = ? AND DATE(check_in_time) = CURDATE()";
                    ps = con.prepareStatement(totalTimeQuery);
                    ps.setString(1, empId);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        String totalWorkedTime = rs.getString("total_worked_time");
                        out.print("🕒 Total Worked Time: " + totalWorkedTime);
                    }
                } else {
                    out.print("❌ Failed to record check-out.");
                }

            } else {
                out.print("⚠️ You have already checked in today. No further check-ins allowed.");
            }
        } else { 
            // Employee is checking in for the first time today
            if (checkInTime != null && !checkInTime.trim().isEmpty()) {
                checkInTime = getFormattedDate(checkInTime);

                String insertQuery = "INSERT INTO timesheet10 (emp_id, check_in_time) VALUES (?, ?)";
                ps = con.prepareStatement(insertQuery);
                ps.setString(1, empId);
                ps.setString(2, checkInTime);

                int result = ps.executeUpdate();
                if (result > 0) {
                    out.print("✅ Check-in recorded successfully!");
                } else {
                    out.print("❌ Failed to record check-in.");
                }
            } else {
                out.print("❌ Error: Check-in time is missing.");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("❌ Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
        if (con != null) try { con.close(); } catch (SQLException ignored) {}
    }
%>

<%!     
    public String getFormattedDate(String inputDate) {
        if (inputDate == null || inputDate.trim().isEmpty()) {
            return null;
        }
        
        SimpleDateFormat inputFormat = new SimpleDateFormat("MM/dd/yyyy, HH:mm:ss");
        SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        try {
            Date date = inputFormat.parse(inputDate);
            return outputFormat.format(date);
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
    }
%>

