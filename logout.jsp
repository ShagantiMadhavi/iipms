<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
    session.invalidate(); // Destroy the session
    response.sendRedirect("login.jsp"); // Redirect to login page
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>logout here</title>
</head>
<body>

</body>
</html>