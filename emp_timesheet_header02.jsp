<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*, java.text.*" %>
<%@ page import="java.sql.*, java.util.Calendar" %>
<%@ page import="java.util.Date, java.text.SimpleDateFormat, java.util.TimeZone" %>

<%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return; // Stop further execution
    }
%>

<%
    // Get the current date and time
    Date now = new Date();

    // Create a SimpleDateFormat instance with the desired format
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    SimpleDateFormat sdfCompare = new SimpleDateFormat("yyyy-MM-dd");

    // Set the timezone to IST (Asia/Kolkata)
    sdf.setTimeZone(TimeZone.getTimeZone("Asia/Kolkata"));

    // Format the date to IST
    String istTime = sdf.format(now);
    //out.println(istTime);
    
%>
<%
    // Ensure the user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return;
    }

    
%>

<%
//Get week offset from request
int weekOffset = request.getParameter("weekOffset") != null ? Integer.parseInt(request.getParameter("weekOffset")) : 0;

// Initialize Calendar for week calculation
Calendar tempCal = Calendar.getInstance();
tempCal.add(Calendar.WEEK_OF_YEAR, weekOffset);
tempCal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY); // Ensure it starts from Monday

// Get the dynamic week number
int weekNumber = tempCal.get(Calendar.WEEK_OF_YEAR);

// Define date format
SimpleDateFormat sdf2 = new SimpleDateFormat("dd MMM yy");
SimpleDateFormat sdfCompare2 = new SimpleDateFormat("MM/dd/yyyy"); // For holiday comparison

// Get today's date in "dd MMM yy" format
Calendar todayCal = Calendar.getInstance();
String todayDate = sdf.format(todayCal.getTime());

// Array to store week dates
String[] weekDays = new String[7];
Calendar tempWeekCal = (Calendar) tempCal.clone(); // Clone to preserve the original tempCal state

for (int i = 0; i < 7; i++) {
    weekDays[i] = sdf.format(tempWeekCal.getTime());
    tempWeekCal.add(Calendar.DAY_OF_MONTH, 1);
}

// Define a list of festival holidays (MM/dd/yyyy format)
List<String> holidays = Arrays.asList(
		
		"01/01/2025", "03/25/2025", "12/25/2025"
		
		);

// Array of day names
String[] days = {"MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"};

//Store total hours of the week
int totalHours = 0;

// Loop to calculate total working hours
for (int i = 0; i < 7; i++) {
    String formattedDate = sdfCompare.format(tempWeekCal.getTime()); // Convert date to "MM/dd/yyyy" for holiday check

    // Check if it's a weekend or a holiday
    boolean isWeekend = (tempWeekCal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || tempWeekCal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY);
    boolean isHoliday = holidays.contains(formattedDate);

    // Assign daily hours
    int dailyHours = (isWeekend || isHoliday) ? 0 : 9; // 9 hours for working days, 0 for holidays/weekends
    totalHours += dailyHours; // Add to total week hours

    // Move to the next day
    tempWeekCal.add(Calendar.DAY_OF_MONTH, 1);
}




SimpleDateFormat outputFormat = new SimpleDateFormat("dd-MMM"); // Format to 'dd-MMM'

String[] formattedDate2 = new String[7]; // Store formatted dates

for (int i = 0; i < 7; i++) { 
    Date date = sdf.parse(weekDays[i]); // Parse full date
    formattedDate2[i] = outputFormat.format(date); // Convert to 'dd-MMM'
}
	
%>

<style>


* {
    box-sizing: border-box;
}

.row-1 {
    background-color: #293d3d !important;
    color: white;
}

.row-2 th, .row-3 {
    color: black !important;
}

.timesheet-container {
    display: flex;
    align-items: center;
    justify-content: space-between;
    min-height: 50px;
}

.table-data, .table-head {
    font-size: 0.7rem;
    word-wrap: break-word;
    white-space: normal;
    max-width: 200px;
}

.left, .right {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 50%;
}

button {
    background: none;
    border: 1px solid white;
    padding: 5px 10px;
    cursor: pointer;
    color: white !important;
    font-size: 0.8rem !important;
}

.table {
    width: 100%;
    margin: 0 !important;
    padding: 0 !important;
    border-collapse: collapse;
}

#weekRange {
    font-size: 0.7rem !important;
    font-weight: bold;
}

.total-hours {
    text-align: center;
    line-height: 0.5rem !important;
}

.total-hours span {
    display: block;
    font-weight: bold;
}

.row-1 .table thead, 
.row-1 .table tbody, 
.row-1 .table th, 
.row-1 .table td {
    background-color: inherit !important;
    color: white;
    line-height: 0.6rem !important;
    font-weight: bold;
}

.row-1 .table td {
    font-size: 0.6rem !important;
}

.green {
    background-color: green;
    color: white;
}

.red {
    background-color: red;
    color: white;
}

.row-3 .table thead, 
.row-3 .table tbody, 
.row-3 .table th, 
.row-3 .table td {
    background-color: inherit !important;
    color: black;
}

.icon {
    color: white !important;
    border-radius: 50%;
}



.legends {
    color: black !important;
    background-color: white;
    padding: 2px;
}

/* Responsive Styles */
@media (min-width: 200px) and (max-width: 760px) {
    .row-1 table tbody td {
        font-size: 0.1rem !important;
        padding: 5px;
    }
    .row-1 th {
        font-size: 0.5rem !important;
    }
    .row-1 .table thead, 
    .row-1 .table tbody, 
    .row-1 .table th, 
    .row-1 .table td {
        line-height: 0.3rem !important;
    }
}

@media (min-width: 760px) and (max-width: 800px) {
    .row-1 .table tbody td {
        font-size: 0.4rem !important;
        padding: 4px !important;
    }
}

/* Search Box Styles */
.search-box {
    font-size: 0.7rem;
    width: 100px;
}

@media (min-width: 768px) {
    .search-box {
        width: 150px;
    }
}

@media (min-width: 1024px) {
    .search-box {
        width: 400px;
    }
}

/* Time Input Container */
.input-container {
    display: inline-flex;
    align-items: center;
    position: relative;
}

.time-input {
    font-size: 0.7rem;
    width: 70px;
    text-align: center;
    padding: 0;
    border: 1px solid #ccc;
    height: 25px;
}

/* Vertical Line */
.vertical-line {
    height: 100px;
    position: absolute;
    right: 5px;
    font-size: 1rem;
    font-weight: bold;
    color: black;
    display: none;
}

    
    
    
    .circle-btn {
    width: 20px;
    height: 20px;
    border: none;
    border-radius: 50%;
    background-color: inherit; /* Circle color */
    color: white; /* Icon color */
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: background 0.3s;
    border: 1px solid white;
    font-size: 0.9rem; /* Keep button's text size normal */
}

.circle-btn i {

    font-size: 0.9rem; /* Increase the icon size separately */
}

.circle-btn:hover {
    background-color: #444; /* Darker hover effect */
}
        
       
</style>
<div class="container-fluid">
<div class="row timesheet-container row-1 mt-4" style="border-right: 1px solid green;">
        <div class="col-6 left d-flex justify-content-between align-items-center" style="border-right: 1px solid white;">
            <div class="d-flex align-items-center">
            <button class="circle-btn me-2" onclick="changeWeek(-1)"><i class="fa fa-chevron-left"></i></button>
                
                 <!-- 
                 <button onclick="changeWeek(-1)" class="me-2 icon"><i class="fa-solid fa-less-than"></i></button>
                 <span id="weekRange">W<%= weekNumber %> <span style="background-color: #3d5c5c;" class="p-1"><%= weekDays[0] %> - <%= weekDays[6] %></span> </span>  
                 
                 -->                
                <span id="weekRange">
			        W<%= weekNumber %> 
			        <span style="background-color: #3d5c5c;" class="p-1">
			            <%= weekDays[0].split(" ")[0] %> - <%= weekDays[6].split(" ")[0] %>
			        </span>
			    </span> 
			    <button class="circle-btn ms-2 me-2" onclick="changeWeek(1)"><i class="fa fa-chevron-right"></i></button>
			    <!-- 
			    <button onclick="changeWeek(1)" class="ms-2 me-2 icon"><i class="fa-solid fa-greater-than"></i></button>
			    
			     -->           
               </div>
            <!-- Total Hours (aligned to the right) -->
		    <div class="total-hours">
		        <span id="weekRange">TOTAL HOURS</span> <br>
		        <span id="weekRange"><%= totalHours %> : 00</span>
		    </div>
        </div>
        
        <div class="col-6 right">
            <table class="table table-borderless">
                <thead>
                
                    
                 <tr>
	    				<% 
					        for (int i = 0; i < 7; i++) { 
					            String currentDate = sdf.format(tempCal.getTime());
					            boolean isToday = currentDate.equals(todayDate);
					
					            // Get the day of the week (1=Sunday, 2=Monday, ..., 7=Saturday)
					            int dayOfWeek = tempCal.get(Calendar.DAY_OF_WEEK);
					            
					            // Default text color
					            String textColor = "";
					
					            // If it's Saturday or Sunday, set text color to orange
					            if (dayOfWeek == Calendar.SATURDAY || dayOfWeek == Calendar.SUNDAY) {
					                textColor = "color: orange;";
					            }
					
					            // If it's a holiday, override color to red
					            if (holidays.contains(currentDate)) {
					                textColor = "color: red;";
					            }
					    %>
					        <th style="<%= textColor %>">
					            <%= isToday ? "TODAY" : days[i] %>
					        </th>
					    <% 
					        tempCal.add(Calendar.DAY_OF_MONTH, 1); 
					    } 
					    %>
					
					    <th rowspan="2" style="vertical-align: middle;">Legends</th>
				</tr>
                    
                </thead>
                <tbody>
                    <tr>
                        <% for (int i = 0; i < 7; i++) { %>
                            <td><%= formattedDate2[i] %></td>
                        <% } %>
                        
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    
    
    <div class="row timesheet-container row-2">
    <div class="col-6 left"  >
        <div class="d-flex align-items-center justify-content-between w-100">
            <div class="d-flex align-items-center">
                <input type="text" class="search-box" placeholder="Search.." style="font-size: 0.7rem;">
            </div>
            <div>
                <button class="btn btn-primary plus" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasWithForm" style="font-size: 0.7rem; color: white !important; border-radius: 50%; display: none;"><i class="fa-solid fa-plus"></i></button>
                 <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-plus-circle fw-bold" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasWithForm"  viewBox="0 0 16 16" style="color:#0372aa; font-size:2rem;">
						  <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
						  <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
				</svg>
                <button type="submit" class="btn btn-dark" style="font-size: 0.7rem; display: none; color: white !important;">Submit</button>
            </div>
        </div>
    </div>
    <div class="col-6 right">
       <table class="table table-borderless" style="background-color: inherit;">
    <thead>
        <tr>
            <% 
                // Clone tempCal to avoid modifying the original calendar reference
                Calendar weekCal = (Calendar) tempCal.clone(); 
                
                for (int i = 0; i < 7; i++) { 
                    // Get formatted date for holiday comparison
                    String formattedDate = sdfCompare.format(weekCal.getTime());

                    // Check if it's a weekend or a holiday
                    boolean isWeekend = (weekCal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || weekCal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY);
                    boolean isHoliday = holidays.contains(formattedDate);

                    // Assign hours display
                    String hoursDisplay = (isWeekend || isHoliday) ? "0:00" : "9:00";
            %>
                <td style="background-color: inherit;"><%= hoursDisplay %></td>
            <% 
                    // Move to the next day
                    weekCal.add(Calendar.DAY_OF_MONTH, 1);
                } 
            %>
            <td style="background-color: #f5f5f0;">AHR</td>
        </tr>
    </thead>
</table>

    </div>
</div>

</div>



<!-- Add Task Offcanvas -->
<div class="offcanvas offcanvas-start" tabindex="-1" id="offcanvasWithForm" aria-labelledby="offcanvasFormLabel">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title" id="offcanvasFormLabel">Add Task Details</h5>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
  </div>
  <div class="offcanvas-body">
    <form id="timesheetForm">

      <input type="hidden" id="empId" name="empId" value="<%= session.getAttribute("emp_id") %>">

      <div class="mb-3">
        <label for="category" class="form-label">Task Category</label>
        <input type="text" class="form-control" id="category" name="category" required>
      </div>

      <div class="mb-3">
        <label for="taskTitle" class="form-label">Task Title</label>
        <input type="text" class="form-control" id="taskTitle" name="taskTitle" required>
      </div>

      <div class="mb-3">
        <label for="taskDescription" class="form-label">Task Description</label>
        <textarea class="form-control" id="taskDescription" name="taskDescription" rows="3" required></textarea>
      </div>

      <div class="mb-3">
        <label for="percentComplete" class="form-label">% Complete</label>
        <input type="number" class="form-control" id="percentComplete" name="percentComplete" min="0" max="100" value="0" required>
      </div>

      <div class="mb-3">
        <label for="taskAssignedBy" class="form-label">Assigned By</label>
        <input type="text" class="form-control" id="taskAssignedBy" name="taskAssignedBy" required>
      </div>

      <button type="submit" class="btn btn-success">Submit</button>
    </form>
  </div>
</div>

<!-- AJAX Script -->
<script>
$(document).ready(function () {
  $("#timesheetForm").on("submit", function (e) {
    e.preventDefault(); // Prevent default form submission

    $.ajax({
      url: "emp_task_create.jsp", // Your JSP handler
      type: "POST",
      data: $(this).serialize(),
      success: function (response) {
        if (response.trim() === "success") {
          alert("Task added successfully!");

          // Reset the form
          $("#timesheetForm")[0].reset();

          // Hide the offcanvas
          const offcanvasElement = document.getElementById("offcanvasWithForm");
          const offcanvasInstance = bootstrap.Offcanvas.getInstance(offcanvasElement);
          if (offcanvasInstance) {
            offcanvasInstance.hide();
          }
        } else {
          alert("Error: " + response);
        }
      },
      error: function (xhr, status, error) {
        alert("AJAX error: " + error);
        console.log("Error details:", xhr.responseText);
      }
    });
  });
});
</script>





<script>
var empId = "<%= session.getAttribute("emp_id") %>";
console.log("🔵 Logged-in Employee ID: ", empId);
function toggleStopwatch(id) {
    console.log("Toggling stopwatch for ID:", id);
}
document.addEventListener("DOMContentLoaded", function () {
	
	
    // Select all table cells that contain dates
    let dateCells = document.querySelectorAll("td");

    dateCells.forEach(cell => {
        let text = cell.innerText.trim();
        let parts = text.split(" "); // Split based on space (e.g., "22 Mar 25")
        
        if (parts.length === 3) {
            let formattedDate = parts[0] + " " + parts[1]; // Keep only "dd MM"
            cell.innerText = formattedDate;
        }
    });
});
function changeWeek(direction) {
    let url = new URL(window.location.href);
    let weekOffset = parseInt(url.searchParams.get("weekOffset")) || 0;
    weekOffset += direction;
    url.searchParams.set("weekOffset", weekOffset);

    // 🔥 Reset total time when switching weeks
    localStorage.removeItem("totalSecondsWorked");

    window.location.href = url.toString();
}


</script>



