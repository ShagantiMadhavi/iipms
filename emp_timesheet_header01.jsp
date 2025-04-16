<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- Add this CSS inside <style> or in a <style> tag -->
<style>
    .sub-nav {
      display: none;
      animation: fadeIn 0.5s ease-in-out;
    }

    .sub-nav.active-tab {
      display: block;
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(10px) scale(0.98);
      }
      to {
        opacity: 1;
        transform: translateY(0) scale(1);
      }
    }

    .nav-btn.active {
      background-color: #0d3b66 !important;
      color: white !important;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .content-btn.active-btn {
      background-color: #0d3b66 !important;
      color: white !important;
      box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
    }
  </style>

<div class="container-fluid p-3" style="background: linear-gradient(to right, #eaf4fb, #ffffff); box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-radius: 10px;">

  <!-- Header Navigation -->
  <div class="d-flex align-items-center justify-content-between mb-3 px-2" style="background-color: #11B5E4; height: 50px; border-radius: 8px; color: white;">
    <a href="emp_dashboard.jsp" class="btn btn-sm fw-bold text-white" style="text-decoration: none;color:white !important;">🏠 Home</a>
    <button type="button" class="btn fw-bold text-dark" style="width: 160px; height: 30px; font-size: 0.85rem; background-color: #fff3cd; box-shadow: inset 2px 2px 5px rgba(0,0,0,0.05); border: 1px solid #ffeeba;">
      <small id="liveTime"></small>
    </button>
  </div>

  <!-- Workspace Navigation -->
  <div class="d-flex gap-3 flex-wrap px-2 mb-3" style="background: #ffffff; padding: 10px; border-radius: 8px; box-shadow: inset 0 2px 6px rgba(0, 0, 0, 0.05);">
    <button type="button" class="btn nav-btn" id="workspace-btn1" style="border-radius: 20px; font-weight: 500;background-color:#dc3545;color:white !important;">My Workspace</button>
    <button type="button" class="btn nav-btn" id="workspace-btn2" style="border-radius: 20px; font-weight: 500;background-color:#dc3545;color:white !important;">My Hours Dashboard</button>
    <button type="button" class="btn nav-btn" id="workspace-btn3" style="border-radius: 20px; font-weight: 500;background-color:#dc3545;color:white !important;">My Dashboards</button>
  </div>

  <!-- Workspace Content Sections -->
  <div class="workspace-content">

    <!-- Section 1 -->
    <div class="sub-nav" id="workspace-content1" style="padding: 10px; border-radius: 10px; box-shadow: inset 0 0 10px rgba(0,0,0,0.05);">
      <button class="btn  border content-btn fw-bold" id="inbox-btn" style="margin: 4px; background-color:#0D3B66;color:white !important;">📥 My Inbox</button>
      <button class="btn  border content-btn fw-bold" id="timesheet-btn" style="margin: 4px; background-color:#0D3B66;color:white !important;">🕒 My Timesheet</button>
      <button class="btn  border content-btn fw-bold" id="approval-btn" style="margin: 4px;display:none; background-color:#0D3B66;color:white !important;" >✅ My Timesheets for Approval</button>
      <button class="btn  border content-btn fw-bold" id="calendar-btn" style="margin: 4px;background-color:#0D3B66;color:white !important;">📅 My Calendar</button>
      <button class="btn  border content-btn fw-bold" id="apply-leave-btn" style="margin: 4px;background-color:#0D3B66;color:white !important;">📝 Apply Leave</button>
      <button class="btn  border content-btn fw-bold" id="view-leave-btn" style="margin: 4px;background-color:#0D3B66;color:white !important;">👁️ View Leave Status</button>
    </div>

    <!-- Section 2 -->
    <div class="sub-nav" id="workspace-content2" style="padding: 10px; border-radius: 10px; background: linear-gradient(to right, #e6f7ff, #ffffff);">
      <button class="btn  content-btn fw-bold" id="summary-btn " style="margin: 4px;background-color:#0D3B66;color:white !important;">📊 My Hours Summary</button>
      <button class="btn  content-btn fw-bold" id="reports-btn" style="margin: 4px;background-color:#0D3B66;color:white !important;">📈 My Reports</button>
    </div>

    <!-- Section 3 -->
    <div class="sub-nav" id="workspace-content3" style="padding: 10px; border-radius: 10px; background: linear-gradient(to right, #f5f0ff, #ffffff);">
      <button class="btn  content-btn fw-bold" id="overview-btn" style="margin: 4px;background-color:#0D3B66;color:white !important;">🧭 Project Overview</button>
      <button class="btn  content-btn fw-bold" id="tasks-btn" style="margin: 4px;background-color:#0D3B66;color:white !important;">🧰 Task Management</button>
    </div>

  </div>
</div>

<!-- JavaScript -->
<script>
  // Live Clock
  setInterval(() => {
    document.getElementById("liveTime").innerText = new Date().toLocaleTimeString();
  }, 1000);

  // Tab Handling with Animation
  document.addEventListener("DOMContentLoaded", function () {
    const workspaceButtons = document.querySelectorAll(".workspace-nav .nav-btn, .nav-btn");
    const contentButtons = document.querySelectorAll(".sub-nav .content-btn");
    const contents = document.querySelectorAll(".sub-nav");

    function showContent(contentId) {
      contents.forEach(content => {
        content.classList.remove("active-tab");
      });
      const selectedContent = document.getElementById(contentId);
      if (selectedContent) {
        selectedContent.classList.add("active-tab");
      }
    }

    workspaceButtons.forEach(button => {
      button.addEventListener("click", function () {
        workspaceButtons.forEach(btn => btn.classList.remove("active"));
        this.classList.add("active");

        const contentId = this.getAttribute("id").replace("workspace-btn", "workspace-content");
        showContent(contentId);
      });
    });

    contentButtons.forEach(button => {
      button.addEventListener("click", function () {
        contentButtons.forEach(btn => btn.classList.remove("active-btn"));
        this.classList.add("active-btn");
      });
    });

    // Show default first tab on load
    showContent("workspace-content1");

    // Redirection logic
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

    // Inbox logic
    document.getElementById("inbox-btn")?.addEventListener("click", function () {
      const userCategory = "Employee"; // change dynamically based on actual session/user
      if (userCategory === "Manager") {
        window.location.href = "inbox_manager.jsp";
      } else {
        window.location.href = "inbox.jsp";
      }
    });
  });
</script>

</body>
</html>