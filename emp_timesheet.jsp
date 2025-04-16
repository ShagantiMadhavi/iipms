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
<jsp:include page="emp_timesheet_header02.jsp" />
<%@ page import="java.util.*, java.text.*" %>
<%@ page import="java.sql.*, java.util.Calendar" %>
<%@ page import="java.util.Date, java.text.SimpleDateFormat, java.util.TimeZone" %>

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

 .stopwatch-btn {
        background-color: #df80ff !important;
        border-color: #df80ff !important;
        color: black !important;
        
        box-shadow: rgba(99, 99, 99, 0.2) 0px 2px 8px 0px;
    }
.green {
        background-color: #28a745 !important;
        color: white !important;
        border-color: #28a745 !important;
    }

    .red {
        background-color: #dc3545 !important;
        color: white !important;
        border-color: #dc3545 !important;
    }

    .btn-warning {
        background-color: #ffc107 !important;
        color: black !important;
        border-color: #ffc107 !important;
    }

.row-3 .table thead, 
.row-3 .table tbody, 
.row-3 .table th, 
.row-3 .table td {
    background-color: inherit !important;
    color: black;
}

.row-3 .table td {
    font-weight: normal !important;
}
.icon {
    color: white !important;
    border-radius: 50%;
}

#stopwatch-btn {
    font-weight: normal;
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


</style>





<div class="container-fluid" style="overflow-y: scroll;overflow-x: hidden;">
   
    

<div class="row timesheet-container align-items-start row-3">
    <div class="col-6 left" style="box-shadow: rgba(0, 0, 0, 0.15) 1.95px 1.95px 2.6px; padding-bottom:180px;">
    <table class="table table-bordered table-hover" style="box-shadow: rgba(0, 0, 0, 0.1) 0px 4px 12px; background-color:white;">
        <thead class="table-light text-center">
            <tr>
                <th scope="col" class="table-head">S.No</th>
                <th scope="col" class="table-head">Category</th>
                <th scope="col" class="table-head">TaskTitle</th>
                <th scope="col" class="table-head">TaskDesc</th>
                <th scope="col" class="table-head">%Complete</th>
                <th scope="col" class="table-head">CreatedAt</th>
                <th scope="col"class="table-head">CompletedDate</th>
                <th scope="col" class="table-head">Assigned By</th>
                <th scope="col" class="table-head">Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                // Retrieve existing database connection from session
                Connection conn = (Connection) session.getAttribute("conn");

                if (conn == null) {
                    out.print("❌ Error: Database connection is not available. Please log in again.");
                    return;
                }

                // Get Employee ID from session (set in login.jsp)
                String empId = (String) session.getAttribute("emp_id");

                if (empId == null || empId.trim().isEmpty()) {
                    out.print("❌ Error: Employee ID is missing. Please log in again.");
                    return;
                }

             // Query to fetch tasks for the logged-in employee
               String query = "SELECT id, category, task_title, task_description, percent_complete, created_at, task_completed_date, assigned_by FROM employee_tasks WHERE emp_id = ?";

                try (PreparedStatement ps = conn.prepareStatement(query)) {
                    ps.setString(1, empId);
                    ResultSet rs = ps.executeQuery();

                    // Serial number initialization
                    int serialNumber = 1;

                    while (rs.next()) {
                        int taskId = rs.getInt("id"); // ✅ Get actual task ID
                        String category = rs.getString("category");
                        String taskTitle = rs.getString("task_title");
                        String taskDescription = rs.getString("task_description");
                        int percentComplete = rs.getInt("percent_complete");
                        Timestamp createdAt = rs.getTimestamp("created_at"); // Fetching created_at column
                        Date completedDate = rs.getDate("task_completed_date");
                        String assignedBy = rs.getString("assigned_by");

                %>
                        <tr>
                            <!-- Serial Number Column -->
                            <td class="table-data"><%= serialNumber++ %></td>

                            <!-- Category Column -->
                            <td class="table-data"><%= category %></td>

                            <!-- Task Title Column -->
                            <td class="table-data"><%= taskTitle %></td>

                            <!-- Task Description Column -->
                            <td class="table-data"><%= taskDescription %></td>

                            <!-- Percent Complete Column -->
                            <td class="table-data"><%= percentComplete %>%</td>

                            <!-- Created At Column -->
                            <td class="table-data">
                                <%= createdAt != null ? createdAt.toString() : "N/A" %>
                            </td>
                            <td class="table-data">
							    <%= completedDate != null ? completedDate.toString() : "N/A" %>
							</td>
							<td class="table-data">
							    <%= assignedBy != null && !assignedBy.trim().isEmpty() ? assignedBy : "N/A" %>
							</td>
							

                            <!-- Actions Column -->
                            <td class="table-data text-center">
                                <div class="d-flex justify-content-center align-items-center">
                                    <button class="btn table-data p-1" id="<%= taskId %>" onclick="editEmpTask(this)" style="font-size:0.8rem !important;">
                                        <i class="fa-solid fa-pen-to-square" style="color:navy !important;"></i>
                                    </button>
                                    <button type="button" id="<%= taskId %>" onclick="delFun(this)" class="btn table-data fa p-1" style="color:red !important;font-size:0.8rem !important;">
                                        &#xf014;
                                    </button>
                                    <button type="button" id="<%= taskId %>" class="btn table-data fa p-1 d-flex" style="color:#615e57 !important;font-size:0.8rem !important;display:none !important;">
                                        <i class="fa-regular fa-user"></i> <span style="margin-left: -5px;margin-top:4px;">ⓘ</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.print("❌ Database Error: " + e.getMessage());
                }

            %>
        </tbody>
    </table>
</div>


    <div class="col-6 right d-flex align-items-start">
       <table class="table table-borderless mt-4">
    <thead>
        <tr>
            <%
                // Clone the calendar instance for row-3 calculation
                Calendar weekCalRow3 = (Calendar) tempCal.clone(); 

                // Variable to track total weekly hours
                int totalWeekMinutes = 0; 
                

                for (int i = 0; i < 7; i++) { 
                    // Get formatted date
                    String formattedDate = sdfCompare.format(weekCalRow3.getTime());

                    // Check if it's a weekend or a holiday
                    boolean isWeekend = (weekCalRow3.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || weekCalRow3.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY);
                    boolean isHoliday = holidays.contains(formattedDate);

                    // Assign default hours
                    int dailyMinutes = (isWeekend || isHoliday) ? 0 : 540; // 9 hours = 540 minutes
                    totalWeekMinutes += dailyMinutes; // Accumulate total weekly time

                    // Format total hours for display
                    String formattedDailyTime = String.format("%2d:%02d", dailyMinutes / 60, dailyMinutes % 60);

                    // Determine button properties
                    String buttonClass = dailyMinutes == 0 ? "btn btn-secondary rounded-0 disabled" : "btn rounded-0 stopwatch-btn";
                    String buttonStyle = dailyMinutes == 0 ? "" : "background-color: #e6ffff !important; border-color: #e6ffff !important; color: black !important;";
                    String buttonContent = dailyMinutes == 0 ? "<i class='fas fa-ban'></i>" : formattedDailyTime;
            %>
            	<th  style="font-weight: normal !important;color: black !important; vertical-align: middle; text-align: center;">
			      
			      <div class="d-flex justify-content-center">
			      
			      <button type="button" class="<%= buttonClass %> stopwatch-btn me-2 ms-4" 
					    data-id="<%= i %>" 
					    data-date="<%= formattedDate %>"
					    data-emp-id="<%= session.getAttribute("emp_id") %>"
					    onclick="toggleStopwatch(this)">
					    <%= buttonContent %>
					</button>
			    	
			                <span class="timer ms-4" data-id="<%= i %>" style="display: none;">00:00:00</span>
			      </div>
			     
			    	
			    </th>
            <%
                // Move to the next day
                weekCalRow3.add(Calendar.DAY_OF_MONTH, 1);
            } 

            // Convert total minutes into HH:MM format
            String formattedTotalWeekHours = String.format("%02d:%02d", totalWeekMinutes / 60, totalWeekMinutes % 60);
            %>
            <!-- 
            <th style="font-size: 0.7rem;">
            <button type="button" id="total-hours" style="color: black !important;"><%= formattedTotalWeekHours %>
                </button>
               
            </th>
             -->
            
            
            <th style="vertical-align: middle; text-align: end;" class="ms-4">00.00</th>
        </tr>
    </thead>
</table>

    </div>
</div>
    
</div>
<div class="container mt-5" style="display: none;">
    <h2>Employee Timesheet</h2>
    <p><strong>Employee ID:</strong> <%= session.getAttribute("emp_id") %></p>
    <p><strong>Name:</strong> <%= session.getAttribute("name") %></p>
    <p><strong>Email:</strong> <%= session.getAttribute("email") %></p>
    <p><strong>Role:</strong> <%= session.getAttribute("role") %></p>

    <!-- Check-in/Attendance button -->
    <button class="btn btn-success">Check-in</button>

    <a href="logout.jsp" class="btn btn-danger">Logout</a>
</div>


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


    
    function getISTTime() {
        let date = new Date(); // Current local time
        let options = { timeZone: "Asia/Kolkata", hour12: false, 
                        year: "numeric", month: "2-digit", day: "2-digit",
                        hour: "2-digit", minute: "2-digit", second: "2-digit" };
        let formatter = new Intl.DateTimeFormat("en-US", options);
        
        return formatter.format(date);
    }
    
 

let currentWeek = "<%= weekNumber %>";
let storedWeek = localStorage.getItem("storedWeek");

if (storedWeek !== currentWeek) {
    localStorage.clear(); 
    localStorage.setItem("storedWeek", currentWeek);
}

</script>


<script>
$(document).ready(function () {
    let timers = {};
    let intervals = {};
    let totalSecondsWorked = 0;
    let storedKey = "totalWorkedTime";

    $(".stopwatch-btn").click(function () {
        let btn = $(this);
        let id = btn.attr("data-id");
        let empId = btn.attr("data-emp-id");
        let date = btn.attr("data-date"); // 👈 get the button's date
        let timerSpan = $(".timer[data-id='" + id + "']");

        // ✅ Log the button info to console
       // console.log("🕒 Clicked button ID:", id);
      //  console.log("📅 Clicked date:", date);
      //  console.log("👤 Employee ID:", empId);

        if (!timers[id]) {
           // console.log("🟢 Timer Started for ID:", id);
            btn.addClass("green").removeClass("btn-warning red");
            timers[id] = { seconds: 0 };

            let checkInTime = getISTTime();

            $.post("emp_saveAttendance.jsp", {
                emp_id: empId,
                check_in_time: checkInTime,
                date: date // optional if you want to store this too
            }, function (response) {
               // console.log("✅ Server Response: " + response);
                alert(response);
            });

            intervals[id] = setInterval(() => {
                timers[id].seconds++;
                let hrs = Math.floor(timers[id].seconds / 3600);
                let mins = Math.floor((timers[id].seconds % 3600) / 60);
                let secs = timers[id].seconds % 60;
                timerSpan.text(
                    (hrs < 10 ? "0" : "") + hrs + ":" +
                    (mins < 10 ? "0" : "") + mins + ":" +
                    (secs < 10 ? "0" : "") + secs
                );
            }, 1000);
        } else {
           // console.log("🛑 Timer Stopped for ID:", id);
            btn.addClass("red").removeClass("green");
            clearInterval(intervals[id]);

            let checkOutTime = getISTTime();

            $.post("emp_saveAttendance.jsp", {
                emp_id: empId,
                check_out_time: checkOutTime,
                date: date // optional
            }, function (response) {
               // console.log("✅ Server Response: " + response);
                alert(response);
            });

            totalSecondsWorked += timers[id].seconds;
            localStorage.setItem(storedKey, totalSecondsWorked);

            delete timers[id];
            delete intervals[id];
        }
    });
});
</script>


<!-- edit form --> 
<div class="offcanvas offcanvas-start" data-bs-scroll="true" tabindex="-1" id="offcanvasWithFormEdit" aria-labelledby="offcanvasFormLabelEdit">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title" id="offcanvasFormLabelEdit">Edit Task Details</h5>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
  </div>
  <div class="offcanvas-body">
    <form id="timesheetFormEdit">
      <!-- Hidden field for Task ID (primary key) -->
      <div class="mb-3" style="display:none;">
        <label for="taskId_edit" class="form-label">Task ID</label>
        <input type="text" class="form-control" id="taskId_edit" name="taskId" readonly>
      </div>

      <!-- Hidden field for Employee ID -->
      <input type="hidden" id="empId_edit" name="empId" value="<%= session.getAttribute("emp_id") %>">

      <!-- Task Category -->
      <div class="mb-3">
        <label for="category_edit" class="form-label">Task Category</label>
        <input type="text" class="form-control" id="category_edit" name="category" required>
      </div>

      <!-- Task Title -->
      <div class="mb-3">
        <label for="taskTitle_edit" class="form-label">Task Title</label>
        <input type="text" class="form-control" id="taskTitle_edit" name="taskTitle" required>
      </div>

      <!-- Task Description -->
      <div class="mb-3">
        <label for="taskDescription_edit" class="form-label">Task Description</label>
        <textarea class="form-control" id="taskDescription_edit" name="taskDescription" rows="3" required></textarea>
      </div>

      <!-- Percent Complete -->
      <div class="mb-3">
        <label for="percentComplete_edit" class="form-label">% Complete</label>
        <input type="number" class="form-control" id="percentComplete_edit" name="percentComplete" min="0" max="100" value="0" required>
      </div>
      
      <!-- Task Completed Date -->
	<div class="mb-3">
	  <label for="taskCompletedDate_edit" class="form-label">Completed Date</label>
	  <input type="date" class="form-control" id="taskCompletedDate_edit" name="taskCompletedDate">
	</div>
	<div class="mb-3">
	  <label for="taskCompletedDate_edit" class="form-label">AssignedBy</label>
	  <input type="text" class="form-control" id="taskAssignedBy_edit" name="taskAssignedBy">
	</div>
      

      <button type="button" onclick="updateEmpTask()" class="btn btn-success">Submit</button>
    </form>
  </div>
</div>

<script>
document.getElementById("timesheetForm").addEventListener("submit", function(event) {
    event.preventDefault(); // Prevent default form submission

    let empId = document.getElementById("empId").value;
    let category = document.getElementById("category").value.trim();
    let taskTitle = document.getElementById("taskTitle").value.trim();
    let taskDescription = document.getElementById("taskDescription").value.trim();
    let percentComplete = document.getElementById("percentComplete").value.trim();
    let taskCompletedDate = document.getElementById("taskCompletedDate").value;

    if (!taskTitle) {
        alert("Task title is required!");
        return;
    }

    let formData = new URLSearchParams();
    formData.append("empId", empId);
    formData.append("category", category);
    formData.append("taskTitle", taskTitle);
    formData.append("taskDescription", taskDescription);
    formData.append("percentComplete", percentComplete);
    formData.append("taskCompletedDate", taskCompletedDate);

    fetch("emp_task_create.jsp", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: formData.toString()
    })
    .then(response => response.text())
    .then(data => {
        console.log("✅ Server Response:", data);
        alert(data);
        document.getElementById("timesheetForm").reset();
    })
    .catch(error => {
        console.error("❌ Fetch Error:", error);
        alert("❌ Error: Unable to save task.");
    });
});

function delFun(taskElement) {
    if (confirm("Are you sure you want to delete this task?")) {
        $.ajax({
            url: 'emp_task_del.jsp',
            type: 'POST',
            data: { id: taskElement.id },
            success: function(response) {
                if (response.trim() === "success") {
                    alert("Employee task deleted successfully!");
                    location.reload();
                } else {
                    alert("Error deleting task.");
                }
            },
            error: function() {
                alert("AJAX error occurred.");
            }
        });
    }
}

function editEmpTask(el) {
    $.ajax({
        url: 'emp_tasks.jsp',
        type: 'GET',
        data: { id: el.id },
        success: function(response) {
            let data = response.trim();
            console.log("Response:", data);

            if (data !== "") {
                let taskDetails = data.split("|");
                $("#taskId_edit").val(taskDetails[0]); // hidden input for task ID
                $("#empId_edit").val(taskDetails[1]);
                $("#category_edit").val(taskDetails[2]);
                $("#taskTitle_edit").val(taskDetails[3]);
                $("#taskDescription_edit").val(taskDetails[4]);
                $("#percentComplete_edit").val(taskDetails[5]);
                $("#taskCompletedDate_edit").val(taskDetails[6] || "");
                $("#taskAssignedBy_edit").val(taskDetails[7] || ""); 

                new bootstrap.Offcanvas(document.getElementById("offcanvasWithFormEdit")).show();
            } else {
                alert("No task found with the given ID.");
            }
        },
        error: function(xhr, status, error) {
            console.error("AJAX Error:", error);
        }
    });
}

function updateEmpTask() {
    let formData = $('#timesheetFormEdit').serialize();

    $.ajax({
        url: 'emp_update_task.jsp',
        type: 'POST',
        data: formData,
        success: function(response) {
            if (response.trim() === "success") {
                alert("Employee task updated successfully!");
                bootstrap.Offcanvas.getInstance(document.getElementById('offcanvasWithFormEdit')).hide();
                location.reload();
            } else {
                alert("Error updating task: " + response);
            }
        },
        error: function(xhr, status, error) {
            console.error("AJAX Error:", error);
        }
    });
}
</script>
<jsp:include page="footer_main.jsp" />


</body>
</html>