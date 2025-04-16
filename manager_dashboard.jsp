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

<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%
    // Define global variables
    String managerId_ = null;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Database connection
    try {
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/employeetimesheet", "root", "admin");
    } catch (SQLException e) {
        out.println("Error: Unable to connect to the database. " + e.getMessage());
        return;
    }

    // Retrieve the manager's emp_id from the session
    managerId_ = (String) session.getAttribute("emp_id");

    if (managerId_ == null) {
        out.println("<p style='color:red;'>❌ Error: Manager ID is missing. Please log in again.</p>");
        return;
    }
%>

<%
    // Ensure the user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return;
    }

    
%>




<div id="carouselExampleAutoplaying" class="carousel slide" data-bs-ride="carousel" style="height:540px;">

<!-- ✅ TOP NAV LINKS INSIDE CAROUSEL --> 
<div class="position-absolute top-0 mt-3 z-3 p-2 w-100 d-flex justify-content-between align-items-center">

  <!-- Left-side buttons -->
  <div class="d-flex flex-wrap gap-2">

    <!-- Employee Details - Bright Yellow -->
    <a href="manager_view_emp_details.jsp"
       class="btn fw-bold"
       style="background-color: #ffc107; color: black; border: none; padding: 6px 15px; transition: 0.3s ease;">
       🧑‍💼 Employee Details
    </a>

    <!-- Attendance Report - Cyan -->
    <a href="manager_view_emp_attendance.jsp"
       class="btn fw-bold"
       style="background-color: #0dcaf0; color: black; border: none; padding: 6px 15px; transition: 0.3s ease;">
       📅 Attendance Reports
    </a>

    <!-- Tasks - Mint Green -->
    <a href="manager_view_tasks.jsp"
       class="btn fw-bold"
       style="background-color: #20c997; color: black; border: none; padding: 6px 15px; transition: 0.3s ease;">
       📋 Employee Tasks
    </a>

    <!-- Leave Decisions - Purple -->
    <a href="manager_emp_leave_decisions.jsp"
       class="btn fw-bold"
       style="background-color: #6f42c1; color: white; border: none; padding: 6px 15px; transition: 0.3s ease;">
       ✅ Leave Decisions
    </a>

  </div>

  <!-- Right-side live clock -->
  <button type="button" class="btn fw-bold"
          style="min-width: 160px; height: 36px; font-size: 0.85rem; background-color: #fff3cd; box-shadow: inset 2px 2px 5px rgba(0,0,0,0.05); border: 1px solid #ffeeba;">
    <small id="liveTime"></small>
  </button>
</div>

  <div class="carousel-inner">
    <div class="carousel-item active">
      <img src="https://img.freepik.com/free-photo/workplace-office-with-laptop-coffee-dark-room-night_169016-47422.jpg?ga=GA1.1.728400395.1741065362&semt=ais_hybrid&w=740" class="d-block w-100" alt="..." style="height:540px;">
      <div class="carousel-caption d-none d-md-block">
		  <h5>Smart Team Management</h5>
<p>Oversee tasks, attendance, and leave requests with real-time visibility.</p>
		</div>
    </div>
    <div class="carousel-item">
      <img src="https://img.freepik.com/free-photo/high-angle-desktop-with-laptop-copy-space_23-2148430882.jpg?ga=GA1.1.728400395.1741065362&w=740" class="d-block w-100" alt="..." style="height:540px;">
      <div class="carousel-caption d-none d-md-block">
		  <h5>Performance Insights</h5>
<p>Track your goals, performance reviews, and achievements over time.</p>		</div>
    </div>
    <div class="carousel-item">
      <img src="https://img.freepik.com/free-photo/laptop-notepad-black-background-with-neon-light-flat-lay_169016-26820.jpg?ga=GA1.1.728400395.1741065362&semt=ais_hybrid&w=740" class="d-block w-100" alt="..." style="height:540px;">
      <div class="carousel-caption d-none d-md-block">
  <h5>Project Progress Overview</h5>
<p>Get a clear snapshot of project milestones, deadlines, and team contributions.</p>
</div>
    </div>
  </div>
  <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleAutoplaying" data-bs-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="visually-hidden">Previous</span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleAutoplaying" data-bs-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="visually-hidden">Next</span>
  </button>
</div>
<jsp:include page="footer_main.jsp" />

<!-- 
<div class="container-fluid p-4 d-block">

	<div class="btn-group" role="group" aria-label="Basic mixed styles example">
		  <button type="button" class="btn btn-danger"><a href="manager_view_emp_details.jsp" style="text-decoration: none; color: white;">View Employee Details</a></button>
		  <button type="button" class="btn btn-warning"><a href="manager_view_emp_attendance.jsp" style="text-decoration: none;">View Employee Attendance Reports</a></button>
			<button type="button" class="btn btn-info"><a href="manager_view_tasks.jsp" style="text-decoration: none;">View Employee Tasks</a></button>
			<!-- ✅  Leave Management Buttons -->
   
   <!-- 
   
    <button type="button" class="btn btn-success">
    <a href="manager_emp_leave_requests.jsp" style="text-decoration: none; color: white;">Leave Requests</a>
</button>
    -->
   
   <!-- 
   
   
   <button type="button" class="btn btn-secondary">
    <a href="manager_emp_leave_decisions.jsp" style="text-decoration: none; color: white;">Leave Decisions</a>
</button>

	</div>

<div class="pt-4">
    <img src="${pageContext.request.contextPath}/assets/manager_background_img.jpg" 
         style="width: 100%; height: 500px; object-fit: cover; border-radius:10px;">
<div class="position-absolute top-50 start-50 translate-middle text-center px-4" 
     style="padding: 20px; border-radius: 10px;font-family: 'Lucida Handwriting', cursive;color: black;text-shadow: 0 0 3px #FF0000;">
    <h2 style="font-weight: bold;">"The art of communication is the language of leadership."</h2>
    
</div>

</div>

	
</div>
   
    -->
   
   













</body>
</html>
