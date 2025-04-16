<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>
 
<%@ include file="db_connection.jsp" %>
<%@ page import="java.sql.*, java.time.*, java.time.format.*" %>


<%
Connection conn1 = (Connection) application.getAttribute("conn");

if (conn1 == null) {
    //out.println("<p style='color:red;'>Database connection failed!</p>");
} else {
    //out.println("<p style='color:green;'>Database connected successfully!</p>");
}

LocalDateTime now1 = LocalDateTime.now();
String formattedDateTime = now1.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

%>

<style>


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
    
}

#home-nav {
   
    font-weight: bold;
    
    cursor: pointer;
}

.workspace-nav {
    display: flex;
    gap: 10px;
    margin: 0;
    padding: 0;
}

.nav-btn {
    font-size: 0.7rem;
    border: none !important;
    color: black !important;
    background-color: transparent;
}

.form-control, .nav-btn:focus, .nav-btn:active {
    outline: none !important;
    box-shadow: none !important;
}

.sub-nav {
    display: none;
   
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
    font-size: 0.7rem;
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
    
    .navbar-brand2 {
        display: block;
        color: red;
        background-color: pink;
    }
}

/* ========== Active Button ========== */
.active-btn {
    color: red;
    font-weight: bold;
}
</style>


<div class="container-fluid p-2">

<div class="p-0">
    <div class="home-header">
        <span id="home-nav">
  <a href="emp_dashboard.jsp" class="btn btn-link" style="color: blue !important; font-weight: bold; text-decoration: none;">
    Home
  </a>
</span>
    </div>
</div>

<!-- Workspace Navigation -->
<div class="p-0 workspace-container">
    <div class="workspace-nav">
        <button type="button" class="nav-btn" id="workspace-btn1"><small>My Workspace</small></button>
        <button type="button" class="nav-btn" id="workspace-btn2"><small>My Hours Dashboard</small></button>
        <button type="button" class="nav-btn" id="workspace-btn3"><small>My Dashboards</small></button>
        <!-- <button type="button" class="ms-auto btn fw-bold " style="width: 180px; /* Adjust width as needed */
    height: 40px; font-size: 1rem !important; color: lime !important; background-color:black;"><small><%-- <%= formattedDateTime %> --%> </small></button>
         -->
         		 
		 
		 <button type="button" class="ms-auto btn fw-bold " style="width: 140px;  
    		height: 30px; font-size: 0.8rem !important; color: black !important; background-color:#FAF1E6 ;box-shadow: rgb(204, 219, 232) 3px 3px 6px 0px inset, rgba(255, 255, 255, 0.5) -3px -3px 6px 1px inset;"><small id="liveTime"></small>
    	</button>

    </div>        
         
    </div>


<!-- Workspace Content Sections -->
<div class=" workspace-content">
    <div class="sub-nav" id="workspace-content1">
        <button class="nav-btn content-btn" id="inbox-btn"><small>My Inbox</small></button>
        <button class="nav-btn content-btn" id="timesheet-btn" ><small>My Timesheet</small></button>
        <button class="nav-btn content-btn" id="approval-btn"><small>My Timesheets for Approval</small></button>
        <button class="nav-btn content-btn" id="calendar-btn"><small>My Calendar</small></button>
        <button class="nav-btn content-btn" id="apply-leave-btn"><small>Apply Leave</small></button>
        <button class="nav-btn content-btn" id="view-leave-btn"><small>View Leave Status</small></button>
         <!--  Leave Management Buttons
         
          <a href="emp_apply_leave.jsp" class="nav-btn" id="calendar-btn"><small>Apply Leave</small></a>
    <a href="emp_view_leave.jsp" class="nav-btn" id="calendar-btn"><small>View Leave Status</small></a>
      
          -->
     
    </div>
    <div class="sub-nav" id="workspace-content2">
        <button class="nav-btn content-btn" id="summary-btn"><small>My Hours Summary</small></button>
        <button class="nav-btn content-btn" id="reports-btn"><small>My Reports</small></button>
    </div>
    <div class="sub-nav" id="workspace-content3">
        <button class="nav-btn content-btn" id="overview-btn"><small>Project Overview</small></button>
        <button class="nav-btn content-btn" id="tasks-btn"><small>Task Management</small></button>
    </div>
</div>
</div>




<!-- Section to Load Content

<div id="dynamic-content"></div>
 -->


<script>

document.addEventListener("DOMContentLoaded", function () {
	
	
    const workspaceButtons = document.querySelectorAll(".workspace-nav .nav-btn");
    const contentButtons = document.querySelectorAll(".sub-nav .content-btn");
    const contents = document.querySelectorAll(".sub-nav");

    function showContent(contentId) {
        // Hide all contents
        contents.forEach(content => content.classList.remove("active-content"));

        // Show selected content
        const selectedContent = document.getElementById(contentId);
        if (selectedContent) {
            selectedContent.classList.add("active-content");
        }
    }

    // Attach event listeners to workspace buttons (Row 1)
    workspaceButtons.forEach(button => {
        button.addEventListener("click", function () {
            // Remove active class from all workspace buttons
            workspaceButtons.forEach(btn => btn.classList.remove("active-btn"));

            // Add active class to the clicked button
            this.classList.add("active-btn");

            // Show the relevant content section
            const contentId = this.getAttribute("id").replace("workspace-btn", "workspace-content");
            showContent(contentId);
        });
    });

    // Attach event listeners to content buttons (Row 2 and Row 3)
    contentButtons.forEach(button => {
        button.addEventListener("click", function () {
            // Check if it's a Row 3 button (nested under a Row 2 button)
            const parentRow = this.closest(".sub-nav");
            const isRow3Button = this.classList.contains("row3-btn");

            if (isRow3Button) {
                // Remove active class from only other Row 3 buttons in the same group
                parentRow.querySelectorAll(".row3-btn").forEach(btn => btn.classList.remove("active-btn"));
            } else {
                // Remove active class from all Row 2 buttons
                document.querySelectorAll(".row2-btn").forEach(btn => btn.classList.remove("active-btn"));
            }

            // Add active class to the clicked button
            this.classList.add("active-btn");

            // Ensure the Row 2 button remains blue when Row 3 is clicked
            if (isRow3Button) {
                const parentRow2Btn = parentRow.previousElementSibling?.querySelector(".row2-btn");
                if (parentRow2Btn) {
                    parentRow2Btn.classList.add("active-btn");
                }
            }
        });
    });

    // Show first section by default
    showContent("workspace-content1");

    // Function to load external content dynamically
    function loadContent(url, targetId) {
        fetch(url)
            .then(response => response.text())
            .then(data => {
                document.getElementById(targetId).innerHTML = data;
            })
            .catch(error => console.error(`Error loading ${url}:`, error));
    }

    // External page navigation for specific buttons
    const pageMappings = {
        "timesheet-btn": "emp_timesheet.jsp",
        "approval-btn": "approval.jsp",
        "calendar-btn": "calendar.jsp",
        "summary-btn": "emp_summary.jsp",
        "reports-btn": "reports.jsp",
        "overview-btn": "overview.jsp",
        "apply-leave-btn": "emp_apply_leave.jsp",
        "view-leave-btn": "emp_view_leave.jsp",
        "tasks-btn": "#"
    };

    Object.keys(pageMappings).forEach(btnId => {
        document.getElementById(btnId)?.addEventListener("click", function () {
            window.location.href = pageMappings[btnId];
        });
    });

    // Inbox button handling based on role
    document.getElementById("inbox-btn")?.addEventListener("click", function () {
    	 // Fetch the session attribute value from JSP and embed it in JavaScript
        const userCategory = "<%= session.getAttribute("category") %>".trim();

        console.log("User Category:", userCategory); // Debugging log to check the value

        document.addEventListener("DOMContentLoaded", function () {
            document.getElementById("inbox-btn")?.addEventListener("click", function() {
                if (userCategory === "Manager") {  
                    window.location.href = "inbox_manager.jsp";  
                } else {
                    window.location.href = "inbox.jsp";  
                }
            });
        });
    });
});

</script>

</body>
</html>