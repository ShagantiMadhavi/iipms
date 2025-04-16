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
            out.println("Database connection error: " + e.getMessage());
            return;
        }
    }

    if (request.getParameter("login") != null) {
        String email = request.getParameter("email").trim().toLowerCase();
        String pass = request.getParameter("password").trim();

        try {
            PreparedStatement pst = conn.prepareStatement(
                "SELECT * FROM employee74 WHERE LOWER(email) = ? AND password = ?"
            );
            pst.setString(1, email);
            pst.setString(2, pass);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                session.setAttribute("emp_id", rs.getString("emp_id"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("role", rs.getString("role"));
                session.setAttribute("department", rs.getString("department"));
                session.setAttribute("hire_date", rs.getString("hire_date"));
                session.setAttribute("phone_number", rs.getString("phone_number"));
                session.setAttribute("address", rs.getString("address"));
                session.setAttribute("manager_id", rs.getString("manager_id"));
                session.setAttribute("role_type", rs.getString("role_type"));

                String roleType = rs.getString("role_type");

             // Redirect to appropriate dashboard
                if ("Manager".equalsIgnoreCase(roleType)) {
                    response.sendRedirect("manager_dashboard.jsp");
                } else if ("Employee".equalsIgnoreCase(roleType)) {
                    response.sendRedirect("emp_dashboard.jsp");
                } else {
                    response.sendRedirect("admin_dashboard.jsp");
                }
                return; // Important to prevent further execution
            } else {
                session.setAttribute("errorMsg", "Invalid Email or Password!");
                response.sendRedirect("login.jsp");
            }
        } catch (Exception e) {
            out.println("Login failed: " + e.getMessage());
        }
    }
%>



<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login</title>
  <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/icon_logo.svg" type="image/x-icon">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

  <style>
   body {
    background-color: #f4faff;
    background-image: url('assets/login_background_img.jpg');
     background-size: cover;      /* Full width, natural height */
  
    background-repeat: no-repeat;
   
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
     backdrop-filter: blur(30px);
     box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
      padding: 30px;
      border-radius: 15px;
     
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
      background-color: #0372aa;
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

	.forgot-link a:hover{
	color: #dc3545 !important;
	font-weight: bold;
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
				style="text-decoration: none; border:none;" target="_blank">
				<img alt="company-logo" src="${pageContext.request.contextPath}/assets/it_logo_2.jpg" 
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
		      <div class="col-md-8 mb-4" style="display:none;">
		        <div class="cards-container">
		          <div>
		            <h2 class="card-sub-title" style="color:black;">Innovate</h2>
		            <img class="card_img" src="${pageContext.request.contextPath}/assets/AIpicture.jpg" alt="AI" style="height: 240px;width: 240px;">
		          </div>
		          <div>
		            <h2 class="card-sub-title" style="color:black;">Elevate</h2>
		            <img class="card_img" src="${pageContext.request.contextPath}/assets/AIpicture1.jpg" style="height: 240px;width: 240px;">
		          </div>
		          <div>
		            <h2 class="card-sub-title" style="color: black;">Empower</h2>
		            <img class="card_img" src="${pageContext.request.contextPath}/assets/AIpicture2.jpg" alt="Empower" style="height: 240px;width: 240px;">
		          </div>
		        </div>
		      </div>
		
		      <!-- Login Form -->
		      <div class="col-12 col-md-6 col-lg-4">
		        <div class="login-container text-container">
		         <div class="text-center mb-3">
		                
		                <img src="data:image/jpeg;base64,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" class="img-fluid" alt="" style="height: 70px;width: 70px;border-radius: 50%;box-shadow: rgba(3, 102, 214, 0.3) 0px 0px 0px 3px;" >
		
		              </div>
		          <div class="login_title" style="color:#0372aa;"><h3>IIPMS LOGIN</h3> </div>
		          
		          <% if (session.getAttribute("errorMsg") != null) { %>
		        <div class="error-message"><%= session.getAttribute("errorMsg") %></div>
		        <% session.removeAttribute("errorMsg"); %>
		    <% } %>
		
		
		
		
		    <form method="post" action="login.jsp">
		        <div class="mb-3">
		            <input type="email" class="input-field" name="email" placeholder="Enter Email" required />
		        </div>
		        <div class="mb-3">
		            <input type="password" class="input-field" name="password" placeholder="Enter Password" required />
		        </div>
		        <div class="mb-3">
		            <button type="submit" name="login" class="btn-custom">Login</button>
		        </div>
		        <div class="text-center forgot-link">
		            <span style="color:white;">Forgot Password?</span> 
		            <a href="forgot_password.jsp" style="text-decoration:none;color:#ffffff;">Click Here!</a>
		        </div>
		    </form>
		        </div>
		      </div>
		    </div>
		  </div>
		 
</body>
</html>

