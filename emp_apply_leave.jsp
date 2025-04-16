<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
    // Check if user is logged in
    if (session.getAttribute("emp_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%
    String empId = (String) session.getAttribute("emp_id");
%>

<jsp:include page="header_main.jsp" />
<jsp:include page="emp_timesheet_header01.jsp" />

<div class="container-fluid py-5 px-4" style="background-color: #eef2f7;">
    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-7">
            <div class="card shadow-lg border-0" style="border-radius: 16px; overflow: hidden; backdrop-filter: blur(6px); background-color: rgba(255,255,255,0.85);">
                <div class="card-header text-white" style="background: linear-gradient(90deg, #0d6efd, #6610f2); padding: 1.2rem 1.5rem;">
                    <h4 class="mb-0" style="font-weight: 600; letter-spacing: 0.5px;">
                        <i class="fas fa-plane-departure me-2"></i> Leave Application Form
                    </h4>
                </div>

                <div class="card-body" style="padding: 2rem;">
                    <form action="emp_submit_leave.jsp" method="post">
                        <input type="hidden" name="emp_id" value="<%= empId %>">

                        <!-- Leave Type -->
                        <div class="mb-4">
                            <label class="form-label" style="font-weight: 600; color: #495057;">Leave Type <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fas fa-clipboard-list text-primary"></i></span>
                                <select name="leave_type" class="form-select" required style="transition: border-color 0.3s;">
                                    <option value="">Select a leave type...</option>
                                    <option>Casual Leave</option>
									<option>Sick Leave</option>
									<option>Earned Leave</option>
									<option>Vacation Leave</option>
									<option>Maternity Leave</option>
									<option>Paternity Leave</option>
									<option>Bereavement Leave</option>
									<option>Personal Leave</option>
									<option>Marriage Leave</option>
									<option>Unpaid Leave</option>
									<option>Study Leave</option>
									<option>Compensatory Off</option>
									<option>Annual Leave</option>
									<option>Religious Leave</option>
									<option>Medical Leave</option>
									<option>Work From Home</option>
									<option>Half-Day Leave</option>
									<option>Training Leave</option>
									<option>Jury Duty</option>
									<option>Emergency Leave</option>
									<option>Others</option>
                                </select>
                            </div>
                        </div>

                        <!-- From Date -->
                        <div class="mb-4">
                            <label class="form-label" style="font-weight: 600; color: #495057;">From Date <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fas fa-calendar-alt text-primary"></i></span>
                                <input type="date" id="from_date" name="from_date" class="form-control" required style="transition: border-color 0.3s;">
                            </div>
                        </div>

                        <!-- To Date -->
                        <div class="mb-4">
                            <label class="form-label" style="font-weight: 600; color: #495057;">To Date <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fas fa-calendar-check text-primary"></i></span>
                                <input type="date" id="to_date" name="to_date" class="form-control" required style="transition: border-color 0.3s;">
                            </div>
                        </div>

                        <!-- Reason -->
                        <div class="mb-4">
                            <label class="form-label" style="font-weight: 600; color: #495057;">Reason <span class="text-danger">*</span></label>
                            <textarea name="reason" class="form-control" rows="4" placeholder="Briefly explain the reason for your leave..." required style="resize: none; transition: border-color 0.3s;"></textarea>
                        </div>

                        <!-- Button -->
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary" style="font-weight: 600; padding: 0.75rem; font-size: 1.05rem; transition: all 0.3s ease;">
                                <i class="fas fa-paper-plane me-2"></i> Submit Leave Request
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Info Note -->
            <div class="text-center mt-4" style="font-size: 0.92rem; color: #6c757d;">
                Please apply at least <strong>5 business days</strong> before your leave start date.
            </div>
        </div>
    </div>
</div>



<!-- Script to restrict date inputs to today or future -->
<script>
    const today = new Date().toISOString().split("T")[0];
    const fromDate = document.getElementById("from_date");
    const toDate = document.getElementById("to_date");

    // Set both dates' min to today
    fromDate.setAttribute("min", today);
    toDate.setAttribute("min", today);

    // Update "to_date" min when "from_date" changes
    fromDate.addEventListener("change", function () {
        const selectedFrom = fromDate.value;
        toDate.setAttribute("min", selectedFrom);
    });
</script>
<jsp:include page="footer_main.jsp" />
</body>
</html>
