<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<jsp:include page="header_main.jsp" />

<!-- Hero Section -->
<div class="position-relative" style="height: 100vh; margin: 0; padding: 0; overflow: hidden;">

    <!-- Fullscreen Background -->
    <img src="https://t4.ftcdn.net/jpg/09/22/54/55/240_F_922545523_AeYfNkWP6M34eQd1lzbMHpTovsYlxkIL.jpg"
         class="position-absolute top-0 start-0 w-100 h-100"
         style="object-fit: cover; z-index: 1;" alt="Admin Background">

    <!-- Overlay Content -->
    <div class="position-absolute top-0 start-0 w-100 h-100 d-flex flex-column justify-content-center align-items-center text-center text-white px-3"
         style="background: rgba(0, 0, 0, 0.5); z-index: 2;">

        <!-- Admin Quote -->
       <h1 class="mb-4 fw-bold animate__animated animate__fadeInDown"
    style="font-family: 'Segoe UI', sans-serif; text-shadow: 2px 2px 10px rgba(0,0,0,0.8); font-size: 2.5rem;">
     Welcome Admin!
</h1>

<p class="mb-4 fs-4 fst-italic"
   style="text-shadow: 1px 1px 6px rgba(0,0,0,0.7); font-weight: 500;">
   "Great management is building success from behind the scenes."
</p>

        <!-- Buttons Group -->
        <!-- Buttons Group -->
<div class="d-flex flex-wrap justify-content-center gap-4 mt-4">

    <a href="admin_view_emp.jsp"
       class="btn text-white px-4 py-3 fs-5"
       style="background: linear-gradient(135deg, #e63946, #ff6b6b); border: none; border-radius: 40px; box-shadow: 0 4px 15px rgba(0,0,0,0.3); transition: all 0.3s ease;">
        👥 View Employee Details
    </a>

    <a href="admin_view_attendance.jsp"
       class="btn text-dark px-4 py-3 fs-5"
       style="background: linear-gradient(135deg, #ffd166, #ffef96); border: none; border-radius: 40px; box-shadow: 0 4px 15px rgba(0,0,0,0.3); transition: all 0.3s ease;">
        📊 Attendance Reports
    </a>
</div>


<!-- Add this script to enable animations -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
        <!-- Footer Note -->
        <div class="mt-5 text-light" style="font-size: 0.9rem; opacity: 0.8;">
            🚀 Powered by IntelliSurge | Admin Panel
        </div>

    </div>
</div>


<jsp:include page="footer_main.jsp" />



</body>
</html>
