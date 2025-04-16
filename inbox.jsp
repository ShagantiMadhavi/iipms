<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>
    <jsp:include page="header_main.jsp" />
<jsp:include page="emp_timesheet_header01.jsp" />

<div class="container-fluid p-4">
<div style="color: blue; font-style: italic;">No data available at the moment.</div>
</div>
</body>
</html>