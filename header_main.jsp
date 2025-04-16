<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="db_connection.jsp" %>
<%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>
<%@ page import="java.sql.*" %>

<%

    String fullName = (String) session.getAttribute("name"); // Retrieve user name from session
    String firstLetter = (fullName != null && !fullName.isEmpty()) ? fullName.substring(0, 1) : "";

    // Validate database connection
    if (conn == null) {
       // out.println("<h2 style='color: red;'>Database Connection Failed! ❌</h2>");
    } else {
        try {
            // Sample query to fetch emp_id (modify according to your logic)
            String query = "SELECT emp_id FROM employee74 WHERE name = ?";
            try (PreparedStatement pst = conn.prepareStatement(query)) {
                pst.setString(1, fullName); // Use the logged-in user's name dynamically

                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        session.setAttribute("emp_id", rs.getString("emp_id")); // Store emp_id in session
                    }
                }
            }

           // out.println("<h2 style='color: green;'>Database Connection Successful! ✅</h2>");
        } catch (SQLException e) {
        	
        	e.printStackTrace();
           // out.println("<h2 style='color: red;'>Database Query Failed! ❌</h2>");
           // out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
%>



<%
    String roleType = (String) session.getAttribute("role_type");

    String dashboardLink = "#"; // default fallback
    if ("Manager".equalsIgnoreCase(roleType)) {
        dashboardLink = "manager_dashboard.jsp";
    } else if ("Employee".equalsIgnoreCase(roleType)) {
        dashboardLink = "emp_dashboard.jsp";
    } else if ("Admin".equalsIgnoreCase(roleType)) {
        dashboardLink = "admin_dashboard.jsp";
    }
%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>IIPMS</title>


<!-- Bootstrap 5.3.3 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap Icons (optional) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

<!-- Font Awesome (optional, for icons) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />

<!-- jQuery (required) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap JS (bundle includes Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Bootstrap Table CSS (latest stable) -->
<link rel="stylesheet" href="https://unpkg.com/bootstrap-table@1.21.2/dist/bootstrap-table.min.css">

<!-- Bootstrap Table JS (latest stable) -->
<script src="https://unpkg.com/bootstrap-table@1.21.2/dist/bootstrap-table.min.js"></script>

<!-- TableExport (required for export functionality) -->
<script src="https://unpkg.com/tableexport.jquery.plugin@1.10.24/tableExport.min.js"></script>

<!-- Bootstrap Table Export Extension -->
<script src="https://unpkg.com/bootstrap-table@1.21.2/dist/extensions/export/bootstrap-table-export.min.js"></script>

<!-- Bootstrap Table Filter Control Extension -->
<script src="https://unpkg.com/bootstrap-table@1.21.2/dist/extensions/filter-control/bootstrap-table-filter-control.min.js"></script>

  <link rel="icon" type="image/svg+xml" href="https://www.intellisurgetechnologies.com/images/icon-logo.svg">

 <style>
 @charset "UTF-8";

 /* ========== Global Styles ========== */
* {
    box-sizing: border-box;
}

a {
    text-decoration: none;
    color: black;
}


/* ========== Navbar ========== */
.navbar-brand {
    color: black !important;
}

.navbar-brand2 {
    display: none;
}

.navbar-brand2:focus,
.navbar-brand2:active {
    outline: none !important;
    border: none !important;
}
.nav-link{
    color: black !important;
    font-weight: bold;
}

.btn{
	color: black !important;
	font-size: 0.7rem !important; 
}
/*
.brand-name{
	
	font-size: 1.4rem !important;
}
 */

/*
nav-link:hover, .advanced:hover {
    color: rgb(240, 192, 35);
}
 */ 

.toggle-btn {
    color: red;
}

.nav-btn.active-btn {
    color: blue;
    background-color: white;
    border: 1px solid blue;
}


/* ========== Header ========== */
.header {
    
    
    box-shadow: rgba(0, 0, 0, 0.1) 0px 10px 50px;
}

/* ========== Search & Dropdown ========== */
.custom-search {
    width: 300px !important;
    height: 30px !important;
    font-size: 12px;
    border-radius: 0 !important;
}

.custom-search-icon {
    height: 30px !important;
    width: 30px;
    padding: 5px;
    font-size: 10px;
    border-radius: 0 !important;
    border-left: none !important;
    border-top-right-radius: 15px !important;
    border-bottom-right-radius: 15px !important;
    box-shadow: rgba(27, 31, 35, 0.04) 0px 1px 0px, rgba(255, 255, 255, 0.25) 0px 1px 0px inset;
}

.dropdown {
    
    height: 30px !important;
    width: 50px;
    padding: 4px;
    font-size: 12px;
    border-radius: 0;
    border-top-left-radius: 15px;
    border-bottom-left-radius: 15px;
    border-left: none;
    text-align: center;
    box-shadow: rgba(27, 31, 35, 0.04) 0px 1px 0px, rgba(255, 255, 255, 0.25) 0px 1px 0px inset !important;
}

.advanced {
    width: 60px;
    height: 30px !important;
    font-size: 12px;
    border: none;
    color: black;
    cursor: pointer;
        
    
}

a{
	text-decoration: none;
	
}

/* ========== Offcanvas & Accordion ========== */
.my-offcanvas .offcanvas {
    top: 55px !important;
    overflow-y: scroll;
}

.accordion-button::after {
    background-image: url("data:image/svg+xml,%3csvg viewBox='0 0 16 16' fill='%23333' xmlns='http://www.w3.org/2000/svg'%3e%3cpath fill-rule='evenodd' d='M8 0a1 1 0 0 1 1 1v6h6a1 1 0 1 1 0 2H9v6a1 1 0 1 1-2 0V9H1a1 1 0 0 1 0-2h6V1a1 1 0 0 1 1-1z' clip-rule='evenodd'/%3e%3c/svg%3e");
    transform: scale(.7) !important;
}

.accordion-button:not(.collapsed)::after {
    background-image: url("data:image/svg+xml,%3csvg viewBox='0 0 16 16' fill='%23333' xmlns='http://www.w3.org/2000/svg'%3e%3cpath fill-rule='evenodd' d='M0 8a1 1 0 0 1 1-1h14a1 1 0 1 1 0 2H1a1 1 0 0 1-1-1z' clip-rule='evenodd'/%3e%3c/svg%3e");
}

.accordion-button:focus {
    box-shadow: none !important;
    outline: none !important;
}

/* ========== Profile ========== */


/* ========== Sections ========== */
.home-container, .workspace-container, .workspace-content {
    margin: 0;
    padding: 0;
}

.home-header {
    height: 30px;
    width: 100%;
    padding-left: 20px;
    align-items: center;
    background-color: transparent !important;
}

#home-nav {
    font-size: 0.75rem;
    font-weight: bold;
    background-color: transparent !important;
    cursor: pointer;
}

.workspace-nav {
    display: flex;
    gap: 10px;
    margin: 0;
    padding: 0;
}

.nav-btn {
    font-size: 0.75rem;
    border: none !important;
    
    background-color: transparent;
}

.form-control, .nav-btn:focus, .nav-btn:active {
    outline: none !important;
    box-shadow: none !important;
}

.sub-nav {
    display: none;
    background-color: white;
    border-radius: 5px;
}

.active-content {
    display: block;
}

/* ========== Table Styles ========== */
.table-container {
    width: 100%;
    overflow-x: auto;
    white-space: nowrap;
}
table {
    margin: 0 !important; 
    padding: 0 !important; 
    border-collapse: collapse;
    width: 100%; /* Ensure it takes full width */
}

.table {
    width: 100%;
    table-layout: fixed;
}

.table th, .table td {
    text-align: center;
    font-size: 0.75rem;
    padding: 4px;
    min-width: 50px;
}

/* ========== Responsive Styles ========== */
@media (max-width: 768px) {
    .table-container {
        display: block;
        overflow-x: auto;
    }

    .table th {
        font-size: 0.6rem;
        min-width: 60px;
    }
}

@media only screen and (max-width: 500px) {
    .custom-search {
        width: 200px !important;
        font-size: 16px;
    }
    
    .navbar-brand {
        display: none;
    }
    
   
}

/* ========== Active Button ========== */
.active-btn {
    color: red;
    font-weight: bold;
}

 @media (max-width: 576px) {
    .profile-dropdown {
      min-width: 220px !important;
      padding: 12px !important;
      font-size: 0.75rem !important;
    }

    .profile-avatar {
      width: 40px !important;
      height: 40px !important;
      font-size: 1rem !important;
      line-height: 40px !important;
    }
  }

  @media (max-width: 350px) {
    .profile-dropdown {
      min-width: 180px !important;
    }

    .dropdown-item span {
      word-break: break-word;
    }
  }
 </style>
 
</head>
<body onload="updateTime()" >

	<div class="header">
	
    		<nav class="navbar navbar-expand-lg">
    		
			        <div class="container-fluid">
			        
				          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarTogglerDemo03" aria-controls="navbarTogglerDemo03" aria-expanded="false" aria-label="Toggle navigation">
				            <span class="navbar-toggler-icon" style="color: white;"></span>
				          </button>
				          
				          <a class="navbar-brand fw-bold"  data-bs-toggle="offcanvas" href="#offcanvasExample" role="button" aria-controls="offcanvasExample" style="display:none;">☰</a>
				          
				         <!-- 
				         
				          <a class="navbar-brand2 fw-bold d-flex align-items-center" href="header_main.jsp" style=" text-decoration: none;">
				    			<img alt="company-logo" src="https://www.intellisurgetechnologies.com/images/logo-final.svg" id="company-logo" class="me-2" style="height: 40px;">
				    			<span style="font-size:1.2rem;" class="ms-4 mt-3" >
				    				<span class="" style="margin-right:-6px; color:orange !important;"><i>i</i></span>
				    				<span style="font-size:1.2rem;color:#0372aa !important; font-family:'Roboto';"><span><i>IPMS</i></span> </span>
				    			
				    			</span> 
				    					
				    		</a>
				          -->
				          
				          <!-- 
				          <a class="navbar-brand2 fw-bold d-flex align-items-center" 
							  href="<%= "Admin".equals(session.getAttribute("category")) ? "admin_dashboard.jsp" : 
					            ("Manager".equals(session.getAttribute("category")) ? "manager_dashboard.jsp" : "emp_dashboard.jsp") %>"
					 
												   style="text-decoration: none;">
												    <img alt="company-logo" src="https://www.intellisurgetechnologies.com/images/logo-final.svg" 
												         id="company-logo" class="me-2" style="height: 40px;outline: none !important;
					    border: none !important;">
												    <span style="font-size:1.2rem;" class="ms-4 mt-3">
												        <span style="margin-right:-6px; color:orange !important;"><i>i</i></span>
												        <span style="font-size:1.2rem;color:#0372aa !important; font-family:'Roboto';">
												            <span><i title="IntelliSurge Integrated Project Management System">IPMS</i></span>
												        </span>
												    </span>
							</a>
				           -->
				    		 <a class="navbar-brand2 fw-bold d-flex align-items-center" 
							  href="https://www.intellisurgetechnologies.com/"
 
							   style="text-decoration: none;" target="_blank">
							    <img alt="company-logo" src="${pageContext.request.contextPath}/assets/it_logo_2.jpg" 
							         id="company-logo" class="me-2" style="height: 40px;outline: none !important;border: none !important;">
							   
							</a>
							 <!-- 
							 <span style="font-size:1.2rem;cursor:pointer;font-weight:bold;" class="ms-4 mt-3">
							        <span style="margin-right:-6px; color:orange !important;"><i>i</i></span>
							        <span style="font-size:1.2rem;color:#0372aa !important; font-family:'Roboto';">
							            <span><i title="IntelliSurge Integrated Project Management System">IPMS</i></span>
							        </span>
							  </span>
							 
							  -->
							  
							  <a class="navbar-brand2 fw-bold d-flex align-items-center" 
							  href="<%= "Admin".equals(session.getAttribute("role_type")) ? "admin_dashboard.jsp" : 
					            ("Manager".equals(session.getAttribute("role_type")) ? "manager_dashboard.jsp" : "emp_dashboard.jsp") %>"
					 
												   style="text-decoration: none;">
												   
												    <span style="font-size:1.2rem;" class="ms-4 mt-3">
												        <span style="margin-right:-6px; color:orange !important;"><i>i</i></span>
												        <span style="font-size:1.2rem;color:#0372aa !important; font-family:'Roboto';">
												            <span><i title="IntelliSurge Integrated Project Management System">IPMS</i></span>
												        </span>
												    </span>
							</a>
							  
							  
				    		
			
				          <div class="collapse navbar-collapse" id="navbarTogglerDemo03">
				          
					            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
						              <li class="nav-item" style="display: none;">
						               <a class="nav-link active fw-bold" aria-current="page" href="<%= dashboardLink %>" style="color: white;">iIPMS</a>
						              </li>
					             
					            </ul>
				           				            
					            <form class="d-flex justify-content-center" style="display: none !important;">
						                <span class="nav-item dropdown">
							                   
							                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">
							                      All
							                    </a>
							                   <!-- 
							                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">
												  <i class="fas fa-ellipsis-h"></i> <!-- Three dots icon 
												</a>
							                    -->
							                   
							                    <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink" style="display:none;">
							                     <li><a class="dropdown-item" href="#">About</a></li>
							                      <li><a class="dropdown-item" href="#">Leave Requests</a></li>
							                      <li><a class="dropdown-item" href="#">Timesheet</a></li>
							                     
							                    </ul>
						                  </span>
					              		  <input class="form-control custom-search" type="search" placeholder="Search" aria-label="Search">
					            			<span>
					                <button class="btn custom-search-icon p-0" type="submit"><i class="fa-solid fa-magnifying-glass" style="color: black !important;"></i></button>
					              	<span class="advanced">Advanced</span>
					            </span>
					            </form>
					            
					            
					            
					            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
					            
					                <li class="nav-item" style="display:none;">
					                  <a class="nav-link" href="#"><i class="fa-solid fa-chevron-up"></i></a>
					                </li>
					                <li class="nav-item" style="display:none;">
					                  <a class="nav-link" href="#"><i class="fa-regular fa-square-caret-down"></i></a>
					                </li>
					                <li class="nav-item" style="display:none;">
					                    <a class="nav-link" href="#"><i class="fa-solid fa-star"></i></a>
					                </li>
					                <li class="nav-item" style="display:none;">
					                    <a class="nav-link" href="#"><i class="fa-solid fa-house"></i></a>
					                </li>
					                <li class="nav-item" style="display:none;">
					                    <a class="nav-link" href="#"><i class="fa-solid fa-circle-question"></i></a>
					                </li>
					                <li class="nav-item">
									  <a class="nav-link  profile d-flex;" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false" style="border: none !important;">
									    <div class="d-flex align-items-center justify-content-center rounded-circle bg-black text-white" style="width: 25px; height: 25px; font-size: 1rem; padding: 2px;">
    										<%= firstLetter %>
										</div>
									  </a>
									  <!-- 
									  <ul class="dropdown-menu dropdown-menu-end">
										    <li class="dropdown-item profile-data">
										      <span style="font-size:0.8rem;"><strong>Employee ID:</strong> <span><%= session.getAttribute("emp_id") %></span></span>  
										    </li>
										    <li class="dropdown-item">
										      <span style="font-size:0.8rem;"><strong>Name:</strong> <span><%= session.getAttribute("name") %></span></span>  
										    </li>
										    <li class="dropdown-item">
										      <span style="font-size:0.8rem;"><strong>Role:</strong> <span><%= session.getAttribute("role") %></span></span>  
										    </li>
										     <li class="dropdown-item">
										        <span style="font-size:0.8rem;"><strong>Department:</strong> <span><%= session.getAttribute("department") %></span></span>
										    </li>
										     <li class="dropdown-item">
										        <span style="font-size:0.8rem;"><strong>RoleType:</strong> <span><%= session.getAttribute("role_type") %></span></span>
										    </li>
										     <li class="dropdown-item">
										        <span style="font-size:0.8rem;"><strong>PhoneNo:</strong> <span><%= session.getAttribute("phone_number") %></span></span>
										    </li>
										    
										    <%--
										    
										    <% if ("Employee".equals(session.getAttribute("role_type"))) { %>
											    <li class="dropdown-item">
											        <span style="font-size:0.8rem;"><strong>Manager Id:</strong> 
											            <span><%= session.getAttribute("manager_id") %></span>
											        </span>  
											    </li>
											<% } %> --%>

										    
										    <!-- Divider 
										    <hr class="dropdown-divider">
										
										    <li>
										       <span style="font-size:0.8rem;"><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></span> 
										    </li>
									</ul>
									   -->
									
									<ul class="dropdown-menu dropdown-menu-end profile-dropdown"
    style="min-width: 280px; padding: 16px; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); font-size: 0.875rem;">

  <!-- Avatar + Name -->
  <li class="dropdown-item text-center" style="border-bottom: 1px solid #dee2e6; padding-bottom: 12px;">
    <div class="profile-avatar"
         style="width: 48px; height: 48px; background-color: #0d6efd; color: #fff; font-weight: bold; font-size: 1.25rem; line-height: 48px; border-radius: 50%; margin: 0 auto 8px;">
      <%= session.getAttribute("name").toString().charAt(0) %>
    </div>
    <strong><%= session.getAttribute("name") %></strong>
  </li>

  <!-- Details -->
  <li class="dropdown-item" style="padding: 8px 0;"><i class="bi bi-person-badge-fill" style="margin-right: 8px; color: #6c757d;"></i><strong>Employee ID:</strong> <%= session.getAttribute("emp_id") %></li>
  <li class="dropdown-item" style="padding: 8px 0;"><i class="bi bi-person-fill" style="margin-right: 8px; color: #6c757d;"></i><strong>Role:</strong> <%= session.getAttribute("role") %></li>
  <li class="dropdown-item" style="padding: 8px 0;"><i class="bi bi-building" style="margin-right: 8px; color: #6c757d;"></i><strong>Department:</strong> <%= session.getAttribute("department") %></li>
  <li class="dropdown-item" style="padding: 8px 0;"><i class="bi bi-diagram-3-fill" style="margin-right: 8px; color: #6c757d;"></i><strong>RoleType:</strong> <%= session.getAttribute("role_type") %></li>
  <li class="dropdown-item" style="padding: 8px 0;"><i class="bi bi-telephone-fill" style="margin-right: 8px; color: #6c757d;"></i><strong>PhoneNo:</strong> <%= session.getAttribute("phone_number") %></li>

  <% if ("Employee".equals(session.getAttribute("role_type"))) { %>
    <li class="dropdown-item" style="padding: 8px 0;"><i class="bi bi-person-workspace" style="margin-right: 8px; color: #6c757d;"></i><strong>Manager Id:</strong> <%= session.getAttribute("manager_id") %></li>
  <% } %>

  <hr class="dropdown-divider">

  <!-- Logout -->
  <li>
    <a href="logout.jsp" class="dropdown-item text-danger" style="font-weight: 600; padding: 8px 0; transition: background-color 0.2s;"
       onmouseover="this.style.backgroundColor='#ffecec'"
       onmouseout="this.style.backgroundColor='transparent'">
      <i class="bi bi-box-arrow-right" style="margin-right: 8px;"></i>Logout
    </a>
  </li>
</ul>

									</li>
					                
						         
						         </ul>
						         
					       </div>
					       
			        </div>
			        
      		</nav>
      		
	</div>



</script>


<script>
        function updateTime() {
            let now = new Date();
            let formattedTime = now.getFullYear() + "-" +
                ("0" + (now.getMonth() + 1)).slice(-2) + "-" +
                ("0" + now.getDate()).slice(-2) + " " +
                ("0" + now.getHours()).slice(-2) + ":" +
                ("0" + now.getMinutes()).slice(-2) + ":" +
                ("0" + now.getSeconds()).slice(-2);
            document.getElementById("liveTime").innerHTML = formattedTime;
        }

        // Update time every second
        setInterval(updateTime, 1000);
    </script>
	
	
