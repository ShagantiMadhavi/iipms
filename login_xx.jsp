<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String jdbcURL = "jdbc:mysql://localhost:3306/employeetimesheet";
    String jdbcUsername = "root";
    String jdbcPassword = "admin";
    Connection conn = (Connection) session.getAttribute("conn");

    if (conn == null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
            session.setAttribute("conn", conn);
        } catch (Exception e) {
            out.println("<p style='color:red;'>Database connection error: " + e.getMessage() + "</p>");
            return;
        }
    }

    if (request.getParameter("login") != null) {
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        try {
            PreparedStatement pst = conn.prepareStatement("SELECT emp_id, name, email, password, role, category, manager_id FROM emp WHERE email=? AND password=?");
            pst.setString(1, email);
            pst.setString(2, pass);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                session.setAttribute("emp_id", rs.getString("emp_id"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("emailId", rs.getString("email"));
                session.setAttribute("password", rs.getString("password"));
                session.setAttribute("role", rs.getString("role"));
                session.setAttribute("category", rs.getString("category"));
                session.setAttribute("manager_id", rs.getString("manager_id"));

                String category = rs.getString("category");
                if ("Manager".equals(category)) {
                    response.sendRedirect("manager_dashboard.jsp");
                } else if ("Employee".equals(category)) {
                    response.sendRedirect("emp_dashboard.jsp");
                } else if ("Admin".equals(category)) {
                    response.sendRedirect("admin_dashboard.jsp");
                }
            } else {
                session.setAttribute("errorMsg", "Invalid Email or Password!");
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Database error: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login</title>
  <link rel="shortcut icon" href="../assets/icon_logo.svg" type="image/x-icon">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

  <style>
    body {
      background-color: #f4faff;
      font-family: 'Segoe UI', sans-serif;
        background-size: cover;        /* Make image cover entire screen */
        background-position: center;   /* Center the image */
        background-repeat: no-repeat;  /* Don't repeat the image */
        height: 100vh;                 /* Full viewport height */
        margin: 0;
        padding: 0;
        font-family: 'Segoe UI', sans-serif;
    }

    .navbar {
      padding: 1rem;
      background-color: white;
     box-shadow: rgba(0, 0, 0, 0.1) 0px 10px 50px;
    }

    .company_logo img {
      width: 60px;
      height: 50px;
    }

    .company_logo_tm {
      font-size: 10px;
      color: #024b74;
      position: relative;
      top: 8px;
      left: 4px;
    }

    .card-sub-title {
      font-size: 20px;
      text-transform: uppercase;
      color: #024b74;
      margin-bottom: 10px;
      text-align: center;
      
    }

    .card_img {
      width: 100%;
      height: 200px;
      object-fit: cover;
      border-radius: 50%;
      transition: transform 0.5s ease;
      box-shadow: rgba(100, 100, 111, 0.2) 0px 7px 29px 0px;
    }

    .card_img:hover {
      transform: scale(1.05);
    }

    .login-container {
      width: 100%;
      max-width: 400px;
      background: white;
      padding: 30px;
      border-radius: 15px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.1);
      margin: auto;
    }

    .login_title {
      text-align: center;
      color: #024b74;
      font-size: 24px;
      font-weight: bold;
      margin-bottom: 20px;
    }

    .input-field {
      font-size: 14px;
      padding: 10px 20px;
      border: 1px solid #ccc;
      background-color: #024b74;
      color: white;
      border-radius: 25px;
      width: 100%;
    }

    .input-field::placeholder {
      color: white;
    }

    .btn-custom {
      width: 100%;
      padding: 10px;
      background-color: #002444;
      color: white;
      border: none;
      border-radius: 25px;
      transition: background 0.3s;
    }

    .btn-custom:hover {
      background-color: #024b74;
    }

    .error-message {
      color: red;
      font-size: 13px;
    }

    .cards-container {
      display: flex;
      justify-content: center;
      gap: 15px;
      margin-bottom: 2rem;
    }

    @media (max-width: 768px) {
      .cards-container {
        flex-direction: column;
        align-items: center;
      }

      .card_img {
        height: 150px;
      }

      .login-container {
        margin-top: 20px;
      }
     
    }

   /* Show only 1 image on mobile */
@media (max-width: 767px) {
  .cards-container > div:nth-child(2),
  .cards-container > div:nth-child(3) {
    display: none;
  }
}

/* Show only 2 images on tablets (iPad Mini, Air, Pro) */
@media (min-width: 768px) and (max-width: 1024px) {
  .cards-container > div:nth-child(3) {
    display: none;
  }
}

/* Optional: Reset all to show on large screens */
@media (min-width: 1025px) {
  .cards-container > div {
    display: block;
  }
}

  </style>
</head>

<body>

  <!-- Navbar -->
  <nav class="navbar d-flex justify-content-start">
    <div class=" d-flex align-items-center">
     <a class="navbar-brand2 fw-bold d-flex align-items-center" 
							  href="https://www.intellisurgetechnologies.com/"
 
							   style="text-decoration: none;" target="_blank">
							    <img alt="company-logo" src="https://www.intellisurgetechnologies.com/images/logo-final.svg" 
							         id="company-logo" class="me-2" style="height: 40px;outline: none !important;border: none !important;">
							   
							</a>
							 <span style="font-size:1.2rem;cursor:pointer;font-weight:bold;" class="ms-4 mt-3">
							        <span style="margin-right:-6px; color:orange !important;"><i>i</i></span>
							        <span style="font-size:1.2rem;color:#0372aa !important; font-family:'Roboto';">
							            <span><i title="IntelliSurge Integrated Project Management System">IPMS</i></span>
							        </span>
							  </span>
							
    </div>
  </nav>

  <!-- Main Content -->
  <div class="container py-4">
    <div class="row align-items-center justify-content-center">
      <div class="col-md-8 mb-4">
        <div class="cards-container">
          <div>
            <h2 class="card-sub-title" style="color:black;">Innovate</h2>
            <img class="card_img" src="../assets/AI picture.jpg" alt="AI" style="height: 240px;width: 240px;">
          </div>
          <div>
            <h2 class="card-sub-title" style="color:black;">Elevate</h2>
            <img class="card_img" src="../assets/AI picture1.jpg" alt="Coding" style="height: 240px;width: 240px;">
          </div>
          <div>
            <h2 class="card-sub-title" style="color:black;">Empower</h2>
            <img class="card_img" src="../assets/AI picture2.jpg" alt="Empower" style="height: 240px;width: 240px;">
          </div>
        </div>
      </div>

      <!-- Login Form -->
      <div class="col-12 col-md-6 col-lg-4">
        <div class="login-container text-container">
         <div class="text-center mb-3">
                <img src="data:image/jpeg;base64,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" class="img-fluid" alt="" style="height: 70px;width: 70px;border-radius: 50%;box-shadow: rgba(3, 102, 214, 0.3) 0px 0px 0px 3px;" >

              </div>
          <div class="login_title" style=";"><h3>LogIn</h3> </div>
          
          <% if (session.getAttribute("errorMsg") != null) { %>
            <div class="error-message"><%= session.getAttribute("errorMsg") %></div>
            <% session.removeAttribute("errorMsg"); %>
          <% } %>

          <form method="post">
            <div class="mb-3">
              <input type="email" class="input-field" name="email" placeholder="Enter Email" required />
            </div>
            <div class="mb-3">
              <input type="password" class="input-field" name="password" placeholder="Enter Password" required />
            </div>
            <div class="mb-3">
              <button type="submit" name="login" class="btn-custom">Login</button>
            </div>
            <div class="text-center">
              <span>Forgot Password?</span> <a href="forgot_password.jsp">Click Here!</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>

</body>
</html>
