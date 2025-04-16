<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%--

<%@ page import="java.sql.*, java.text.*, java.util.*, javax.mail.*, javax.mail.internet.*, javax.activation.*" %>
<%
    String empId = request.getParameter("emp_id");
    String leaveType = request.getParameter("leave_type");
    String fromDate = request.getParameter("from_date");
    String toDate = request.getParameter("to_date");
    String reason = request.getParameter("reason");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

        // Insert leave request
        ps = con.prepareStatement("INSERT INTO leave_requests (emp_id, leave_type, from_date, to_date, reason) VALUES (?, ?, ?, ?, ?)");
        ps.setString(1, empId);
        ps.setString(2, leaveType);
        ps.setString(3, fromDate);
        ps.setString(4, toDate);
        ps.setString(5, reason);

        int i = ps.executeUpdate();

        if (i > 0) {
            out.println("<p style='color:green;'>Leave request submitted successfully.</p>");

            // --- Fetch manager's email ---
            String managerEmail = null;
            ps = con.prepareStatement("SELECT e2.email FROM employee74 e1 JOIN employee74 e2 ON e1.manager_id = e2.emp_id WHERE e1.emp_id = ?");
            ps.setString(1, empId);
            rs = ps.executeQuery();
            if (rs.next()) {
                managerEmail = rs.getString("email");
            }

            if (managerEmail != null) {
                // --- Send Email to Manager ---
                String fromEmail = "shaganti74@gmail.com"; // your email
                String fromPass = "fjdcjmhxkyqzyjlt"; // app password

                Properties props = new Properties();
                props.put("mail.smtp.host", "smtp.gmail.com");
                props.put("mail.smtp.port", "587");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");

                Session mailSession = Session.getInstance(props, new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(fromEmail, fromPass);
                    }
                });

                Message message = new MimeMessage(mailSession);
                message.setFrom(new InternetAddress(fromEmail));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(managerEmail));
                message.setSubject("Leave Request from Employee ID: " + empId);
                message.setText("Leave Type: " + leaveType + "\nFrom: " + fromDate + "\nTo: " + toDate + "\nReason: " + reason);

                Transport.send(message);
                out.println("<p style='color:blue;'>Notification email sent to manager: " + managerEmail + "</p>");
            } else {
                out.println("<p style='color:orange;'>Manager's email not found. Email not sent.</p>");
            }
        } else {
            out.println("<p style='color:red;'>Failed to submit leave request.</p>");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>


 --%>



<%@ page import="java.sql.*, java.text.*, java.util.*, javax.mail.*, javax.mail.internet.*, javax.activation.*" %>
<%
    String empId = request.getParameter("emp_id");
    String leaveType = request.getParameter("leave_type");
    String fromDate = request.getParameter("from_date");
    String toDate = request.getParameter("to_date");
    String reason = request.getParameter("reason");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String alertMessage = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");

        // Insert leave request
        ps = con.prepareStatement("INSERT INTO leave_requests (emp_id, leave_type, from_date, to_date, reason) VALUES (?, ?, ?, ?, ?)");
        ps.setString(1, empId);
        ps.setString(2, leaveType);
        ps.setString(3, fromDate);
        ps.setString(4, toDate);
        ps.setString(5, reason);

        int i = ps.executeUpdate();

        if (i > 0) {
            alertMessage += "Leave request submitted successfully.\\n";

            // --- Fetch manager's email ---
            String managerEmail = null;
            ps = con.prepareStatement("SELECT e2.email FROM employee74 e1 JOIN employee74 e2 ON e1.manager_id = e2.emp_id WHERE e1.emp_id = ?");
            ps.setString(1, empId);
            rs = ps.executeQuery();
            if (rs.next()) {
                managerEmail = rs.getString("email");
            }

            if (managerEmail != null) {
                // --- Send Email to Manager ---
                String fromEmail = "shaganti74@gmail.com"; // your email
                String fromPass = "fjdcjmhxkyqzyjlt"; // app password

                Properties props = new Properties();
                props.put("mail.smtp.host", "smtp.gmail.com");
                props.put("mail.smtp.port", "587");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");

                Session mailSession = Session.getInstance(props, new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(fromEmail, fromPass);
                    }
                });

                Message message = new MimeMessage(mailSession);
                message.setFrom(new InternetAddress(fromEmail));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(managerEmail));
                message.setSubject("Leave Request from Employee ID: " + empId);
                message.setText("Leave Type: " + leaveType + "\nFrom: " + fromDate + "\nTo: " + toDate + "\nReason: " + reason);

                Transport.send(message);
                //alertMessage += "Notification email sent to your manager: " + managerEmail + "\\n";
                //alertMessage += "Notification email sent to your manager!."+ "\\n";
            } else {
                alertMessage += "Manager's email not found. Email not sent.\\n";
            }
        } else {
            alertMessage += "Failed to submit leave request.\\n";
        }
    } catch (Exception e) {
        alertMessage += "Error: " + e.getMessage().replace("\"", "'") + "\\n";
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>

<script>
    alert("<%= alertMessage %>");
    window.location.href = "emp_apply_leave.jsp"; // Change or remove redirect if needed
</script>

