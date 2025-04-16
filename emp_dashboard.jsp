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



























<!-- Carousel Section -->
<!-- Carousel Section -->
<div id="carouselExampleAutoplaying" class="carousel slide mb-2" data-bs-ride="carousel" style="height:480px;">
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img src="https://media.istockphoto.com/id/171159522/photo/grunge-purple-background.webp?a=1&b=1&s=612x612&w=0&k=20&c=emGhdwyj_IoIDf8mrC6MZIsgZajKW0KkR8v8drD0D9c=" class="d-block w-100" alt="..." style="height:480px;">
      <div class="carousel-caption d-none d-md-block bg-dark bg-opacity-50 rounded p-3">
        <h5>Welcome to the Employee Dashboard</h5>
        <p>Access everything you need in one place — efficiently and beautifully.</p>
      </div>
    </div>
    <div class="carousel-item">
      <img src="https://img.freepik.com/free-photo/flat-lay-desk-dark-concept-with-copy-space_23-2148459477.jpg" class="d-block w-100" alt="..." style="height:480px;">
      <div class="carousel-caption d-none d-md-block bg-dark bg-opacity-50 rounded p-3">
        <h5>Stay Informed</h5>
        <p>Quick access to updates, notices, and communication tools.</p>
      </div>
    </div>
    <div class="carousel-item">
      <img src="https://images.unsplash.com/photo-1499914485622-a88fac536970?w=600&auto=format&fit=crop&q=60" class="d-block w-100" alt="..." style="height:480px;">
      <div class="carousel-caption d-none d-md-block bg-dark bg-opacity-50 rounded p-3">
        <h5>Your Growth Matters</h5>
        <p>Tools to track progress, achievements, and goals.</p>
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

<!-- Global Styling Components -->
<div class="container mb-4" style="display:none;">
  <div class="row g-4">

    <!-- Beautiful Card 1 -->
    <div class="col-md-4">
      <div class="card shadow-sm border-0" style="background-color:#f8f9fa;">
        <div class="card-body">
          <h5 class="card-title">📁 My Documents</h5>
          <p class="card-text">Securely access payslips, offer letters, and experience certificates.</p>
          <a href="#" class="btn btn-outline-primary btn-sm" style="width:100%;">Go to Documents</a>
        </div>
      </div>
    </div>

    <!-- Beautiful Card 2 -->
    <div class="col-md-4">
      <div class="card shadow-sm border-0" style="background-color:#fff3cd;">
        <div class="card-body">
          <h5 class="card-title">📅 Calendar & Events</h5>
          <p class="card-text">View upcoming meetings, company events, and holidays.</p>
          <a href="#" class="btn btn-outline-dark btn-sm" style="width:100%;">View Calendar</a>
        </div>
      </div>
    </div>

    <!-- Beautiful Card 3 -->
    <div class="col-md-4">
      <div class="card shadow-sm border-0" style="background-color:#e2f0d9;">
        <div class="card-body">
          <h5 class="card-title">🧑‍💻 Work Tools</h5>
          <p class="card-text">Jump to your tasks, time logs, or performance tools with one click.</p>
          <a href="#" class="btn btn-outline-success btn-sm" style="width:100%;">Open Tools</a>
        </div>
      </div>
    </div>

  </div>
</div>

<div class="container mb-4" style="display:none;">
  <div class="row text-center">
    <div class="col-md-3 mb-3">
      <div class="card shadow-sm" style="background-color: #f0f4ff;">
        <div class="card-body">
          <h6 class="card-title">Leaves Remaining</h6>
          <h3 style="color: #0d6efd;">12</h3>
        </div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card shadow-sm" style="background-color: #fef4e9;">
        <div class="card-body">
          <h6 class="card-title">Pending Approvals</h6>
          <h3 style="color: #fd7e14;">3</h3>
        </div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card shadow-sm" style="background-color: #e7f9f1;">
        <div class="card-body">
          <h6 class="card-title">Projects Assigned</h6>
          <h3 style="color: #198754;">5</h3>
        </div>
      </div>
    </div>
    <div class="col-md-3 mb-3">
      <div class="card shadow-sm" style="background-color: #f8f9fa;">
        <div class="card-body">
          <h6 class="card-title">Attendance %</h6>
          <h3 style="color: #6c757d;">96%</h3>
        </div>
      </div>
    </div>
  </div>
</div>


<jsp:include page="footer_main.jsp" />
</body>
</html>