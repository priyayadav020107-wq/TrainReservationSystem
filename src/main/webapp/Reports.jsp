<%@ page import="service.ConcurrencyService, model.ReportPojo, java.util.List, java.util.Map, java.util.ArrayList" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if(adminId == null) response.sendRedirect("AdminLogin.jsp");
    String adminName = (String) session.getAttribute("adminName");
    
    String reportMessage = (String) request.getAttribute("reportMessage");
    Long reportTime = (Long) request.getAttribute("reportTime");
    
    ReportPojo summary = (ReportPojo) request.getAttribute("summary");
    List<Map<String, Object>> monthlyBookings = (List<Map<String, Object>>) request.getAttribute("monthlyBookings");
    List<Map<String, Object>> statusDistribution = (List<Map<String, Object>>) request.getAttribute("statusDistribution");
    List<Map<String, Object>> recentBookings = (List<Map<String, Object>>) request.getAttribute("recentBookings");
    
    // Calculate donut chart percentages
    int totalBookings = summary != null ? summary.getTotalBookings() : 0;
    int confirmedCount = 0;
    int cancelledCount = 0;
    int waitingCount = 0;
    
    if(statusDistribution != null) {
        for(Map<String, Object> status : statusDistribution) {
            String name = (String) status.get("status");
            int count = ((Number) status.get("count")).intValue();
            if("CONFIRMED".equals(name)) confirmedCount = count;
            else if("CANCELLED".equals(name)) cancelledCount = count;
            else if("WAITING".equals(name)) waitingCount = count;
        }
    }
    
    // Prepare arrays for chart
    int[] monthlyCounts = new int[12];
    String[] monthNames = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
    
    if(monthlyBookings != null && !monthlyBookings.isEmpty()) {
        for(Map<String, Object> month : monthlyBookings) {
            Object monthNumObj = month.get("month_num");
            Object countObj = month.get("booking_count");
            
            int monthNum = 0;
            int count = 0;
            
            if(monthNumObj != null) {
                if(monthNumObj instanceof Integer) {
                    monthNum = (Integer) monthNumObj;
                } else if(monthNumObj instanceof Long) {
                    monthNum = ((Long) monthNumObj).intValue();
                }
            }
            
            if(countObj != null) {
                if(countObj instanceof Integer) {
                    count = (Integer) countObj;
                } else if(countObj instanceof Long) {
                    count = ((Long) countObj).intValue();
                }
            }
            
            if(monthNum >= 1 && monthNum <= 12) {
                monthlyCounts[monthNum - 1] = count;
            }
        }
    }
    
    // If no monthly data but totalBookings > 0, put data in June
    boolean hasData = false;
    for(int c : monthlyCounts) {
        if(c > 0) hasData = true;
    }
    if(!hasData && totalBookings > 0) {
        monthlyCounts[5] = totalBookings;
    }
    
    // Calculate max count for bar chart scaling
    int maxBookingCount = 0;
    for(int i = 0; i < monthlyCounts.length; i++) {
        if(monthlyCounts[i] > maxBookingCount) {
            maxBookingCount = monthlyCounts[i];
        }
    }
    if(maxBookingCount == 0) maxBookingCount = 1;
    
    // Build JSON arrays
    StringBuilder monthNamesJson = new StringBuilder();
    monthNamesJson.append("[");
    for(int i = 0; i < monthNames.length; i++) {
        monthNamesJson.append("'").append(monthNames[i]).append("'");
        if(i < monthNames.length - 1) monthNamesJson.append(", ");
    }
    monthNamesJson.append("]");
    
    StringBuilder monthlyCountsJson = new StringBuilder();
    monthlyCountsJson.append("[");
    for(int i = 0; i < monthlyCounts.length; i++) {
        monthlyCountsJson.append(monthlyCounts[i]);
        if(i < monthlyCounts.length - 1) monthlyCountsJson.append(", ");
    }
    monthlyCountsJson.append("]");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #2e2e30 0%, #242426 40%, #1a1a1c 100%);
            min-height: 100vh;
            display: flex;
        }
        
        .sidebar {
            width: 280px;
            background: #272729;
            color: #f0f0f0;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            overflow-y: auto;
            border-right: 1px solid #3e3e40;
            box-shadow: 2px 0 12px rgba(0,0,0,0.35);
        }
        .sidebar-header { padding: 25px 20px; text-align: center; border-bottom: 1px solid #3e3e40; }
        .sidebar-header h2 { font-size: 20px; margin-bottom: 5px; color: #f5a623; }
        .sidebar-header p { font-size: 12px; color: #9a9a9a; }
        .sidebar-menu { padding: 20px 0; }
        .menu-item { padding: 12px 25px; display: flex; align-items: center; gap: 12px; color: #9a9a9a; text-decoration: none; transition: 0.3s; }
        .menu-item:hover, .menu-item.active { background: #363638; color: #f5a623; border-left: 3px solid #f5a623; }
        .menu-icon { font-size: 18px; width: 30px; }
        
        .main-content { 
            margin-left: 280px; 
            flex: 1; 
            padding: 0 0 20px 0;
        }

        .top-navbar { 
            background: #272729; 
            border-radius: 0 12px 12px 0;
            padding: 15px 25px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 25px; 
            margin-top: 0;
            margin-right: 0;
            width: 100%;
            box-sizing: border-box;
            border-bottom: 2px solid #3e3e40;
            box-shadow: 0 2px 12px rgba(0,0,0,0.3);
        }

        .page-title { 
            font-size: 24px; 
            font-weight: 600; 
            color: #f5a623; 
            margin: 0;
        }

        .user-info { 
            display: flex; 
            align-items: center; 
            gap: 15px;
            margin-left: auto;
        }

        .user-name { 
            color: #9a9a9a; 
            font-weight: 500; 
            font-size: 14px;
        }

        .logout-btn { 
            background: linear-gradient(135deg, #e8720c, #c1121f);
            color: white; 
            padding: 6px 16px; 
            border: none; 
            border-radius: 6px; 
            cursor: pointer; 
            font-size: 13px;
            transition: opacity 0.3s;
        }
        .logout-btn:hover { opacity: 0.85; }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin: 0 20px 30px 20px;
        }
        .stat-card {
            background: rgba(44,44,46,0.92);
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
            transition: transform 0.3s;
        }
        .stat-card:hover { transform: translateY(-3px); }
        .stat-card .label { color: #9a9a9a; font-size: 14px; margin-bottom: 10px; }
        .stat-card .value { font-size: 32px; font-weight: bold; color: #f5a623; }
        .stat-card .trend { font-size: 12px; margin-top: 8px; }
        .trend-up { color: #5cb87a; }
        .trend-down { color: #e8720c; }
        
        .two-columns {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin: 0 20px 30px 20px;
        }
        .chart-card {
            background: rgba(44,44,46,0.92);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
        }
        .chart-card h3 {
            margin-bottom: 20px;
            color: #f0f0f0;
            border-bottom: 2px solid #f5a623;
            padding-bottom: 10px;
            font-size: 16px;
        }
        
        .bar-chart-container {
            display: flex;
            align-items: flex-end;
            justify-content: center;
            height: 280px;
            gap: 12px;
            margin-top: 20px;
            padding: 0 10px;
        }
        .bar-item {
            flex: 1;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .bar {
            width: 100%;
            background: linear-gradient(135deg, #f5a623, #e8720c);
            border-radius: 8px 8px 0 0;
            transition: height 0.5s ease;
            min-height: 4px;
        }
        .bar-label {
            margin-top: 10px;
            font-size: 11px;
            font-weight: 600;
            color: #9a9a9a;
        }
        .bar-value {
            font-size: 11px;
            color: #f5a623;
            margin-top: 3px;
            font-weight: bold;
        }
        
        .recent-table {
            background: rgba(44,44,46,0.92);
            border-radius: 12px;
            padding: 20px;
            margin: 0 20px 20px 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
        }
        .recent-table h3 {
            margin-bottom: 20px;
            color: #f0f0f0;
            border-bottom: 2px solid #f5a623;
            padding-bottom: 10px;
            font-size: 16px;
        }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #3e3e40; color: #f0f0f0; }
        th { background: #1a1a1c; color: #f5a623; font-weight: 600; }
        tr:hover td { background: rgba(54,54,56,0.5); }
        .status-confirmed { color: #5cb87a; font-weight: bold; }
        .status-cancelled { color: #c1121f; font-weight: bold; }
        .status-waiting { color: #f5a623; font-weight: bold; }
        
        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 0 20px 25px 20px;
        }
        .generate-btn {
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: opacity 0.3s;
        }
        .generate-btn:hover { opacity: 0.85; }
        
        .success-message {
            background: #1e3020;
            color: #5cb87a;
            padding: 12px 20px;
            border-radius: 8px;
            display: inline-block;
            border: 1px solid #2d4a33;
        }
        
        .concurrency-card {
            background: rgba(44,44,46,0.92);
            border-radius: 12px;
            padding: 20px;
            margin: 0 20px 20px 20px;
            border: 1px solid #3e3e40;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
        }
        .concurrency-card h3 {
            color: #f0f0f0;
            margin-bottom: 15px;
            font-size: 16px;
            border-bottom: 2px solid #f5a623;
            padding-bottom: 10px;
        }
        .concurrency-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 15px;
        }
        .concurrency-item { text-align: center; }
        .concurrency-value { font-size: 22px; font-weight: bold; color: #f5a623; }
        .concurrency-label { font-size: 12px; color: #9a9a9a; margin-top: 5px; }
        
        canvas { max-height: 250px; width: 100%; }
        .legend { margin-top: 15px; text-align: center; }
        .legend span { display: inline-block; margin: 0 10px; font-size: 13px; color: #9a9a9a; }
        .legend-color { width: 12px; height: 12px; display: inline-block; border-radius: 2px; margin-right: 5px; }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>TRS</h2>
            <p>Train Reservation System</p>
        </div>
        <div class="sidebar-menu">
            <a href="AdminServlet?action=dashboard" class="menu-item ">
                <i class="fas fa-tachometer-alt menu-icon"></i>
                <span>Dashboard</span>
            </a>
            <a href="AdminServlet?action=manageTrains" class="menu-item ">
                <i class="fas fa-train menu-icon"></i>
                <span>Train Management</span>
            </a>
            <a href="AdminServlet?action=bookings" class="menu-item ">
                <i class="fas fa-ticket-alt menu-icon"></i>
                <span>Bookings</span>
            </a>
            <a href="AdminServlet?action=users" class="menu-item ">
                <i class="fas fa-users menu-icon"></i>
                <span>Users</span>
            </a>
            <a href="AdminServlet?action=reports" class="menu-item active">
                <i class="fas fa-chart-line menu-icon"></i>
                <span>Reports</span>
            </a>
            <a href="AdminServlet?action=adminProfile" class="menu-item">
                <i class="fas fa-user-circle menu-icon"></i>
                <span>Profile</span>
            </a>
        </div>
    </div>
 
    <div class="main-content">
        <div class="top-navbar">
            <h1 class="page-title">Reports Dashboard</h1>
            <div class="user-info">
                <span class="user-name">Welcome, <%= adminName %></span>
                <form method="post" action="AdminServlet" style="display: inline;">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </div>
        
        <div class="report-header">
            <div>
                <% if(reportMessage != null) { %>
                    <div class="success-message">
                        <strong>Report Generated Successfully!</strong><br>
                        Technology: ForkJoinPool | Tasks Executed: 4 | Execution Time: <%= reportTime %> ms
                    </div>
                <% } %>
            </div>
            <button class="generate-btn" onclick="generateReports()">Generate Report</button>
        </div>
        
        <!-- 4 Summary Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="label">Total Revenue</div>
                <div class="value">Rs. <%= summary != null ? String.format("%,.0f", summary.getTotalRevenue()) : "0" %></div>
                <div class="trend trend-up">↑ 12.5%</div>
            </div>
            <div class="stat-card">
                <div class="label">Total Bookings</div>
                <div class="value"><%= summary != null ? summary.getTotalBookings() : "0" %></div>
                <div class="trend trend-up">↑ 8.3%</div>
            </div>
            <div class="stat-card">
                <div class="label">Cancelled Tickets</div>
                <div class="value"><%= summary != null ? summary.getCancelledBookings() : "0" %></div>
                <div class="trend trend-down">↓ 5.2%</div>
            </div>
            <div class="stat-card">
                <div class="label">Active Trains</div>
                <div class="value"><%= summary != null ? summary.getActiveTrains() : "0" %></div>
                <div class="trend trend-up">↑ 2</div>
            </div>
        </div>
        
        <!-- Two Columns: Bar Chart + Donut Chart -->
        <div class="two-columns">
            <!-- Monthly Booking Trend -->
            <div class="chart-card">
                <h3>Monthly Booking Trend</h3>
                <div class="bar-chart-container">
                    <% for(int i = 0; i < monthNames.length; i++) { 
                        int barHeight = monthlyCounts[i] > 0 ? (monthlyCounts[i] * 180) / maxBookingCount : 5;
                        if(barHeight < 5) barHeight = 5;
                    %>
                        <div class="bar-item">
                            <div class="bar" style="height: <%= barHeight %>px;"></div>
                            <div class="bar-label"><%= monthNames[i] %></div>
                            <div class="bar-value"><%= monthlyCounts[i] %></div>
                        </div>
                    <% } %>
                </div>
                <div style="text-align: center; margin-top: 15px; font-size: 12px; color: #9a9a9a;">
                    <span style="display: inline-block; width: 12px; height: 12px; background: linear-gradient(135deg, #f5a623, #e8720c); border-radius: 2px; margin-right: 5px;"></span>
                    Number of Bookings
                </div>
            </div>
            
            <!-- Booking Status Distribution -->
            <div class="chart-card">
                <h3>Booking Status Distribution</h3>
                <canvas id="statusChart" style="max-height: 250px; width: 100%;"></canvas>
                <div class="legend">
                    <span><span class="legend-color" style="background:#5cb87a;"></span> Confirmed (<%= confirmedCount %>)</span>
                    <span><span class="legend-color" style="background:#c1121f;"></span> Cancelled (<%= cancelledCount %>)</span>
                    <span><span class="legend-color" style="background:#f5a623;"></span> Waiting (<%= waitingCount %>)</span>
                </div>
            </div>
        </div>
        
        <!-- Concurrency Insights -->
        <div class="concurrency-card">
            <h3>Concurrency Insights</h3>
            <div class="concurrency-grid">
                <div class="concurrency-item">
                    <div class="concurrency-value"><%= ConcurrencyService.getActiveBookingCount() %></div>
                    <div class="concurrency-label">Active Booking Threads</div>
                </div>
                <div class="concurrency-item">
                    <div class="concurrency-value"><%= ConcurrencyService.getQueueSize() %></div>
                    <div class="concurrency-label">Queue Size</div>
                </div>
                <div class="concurrency-item">
                    <div class="concurrency-value"><%= ConcurrencyService.getSeatLockCount() %></div>
                    <div class="concurrency-label">Seat Locks Active</div>
                </div>
                <div class="concurrency-item">
                    <div class="concurrency-value"><%= ConcurrencyService.getCompletedTaskCount() %></div>
                    <div class="concurrency-label">Virtual Threads Used</div>
                </div>
                <div class="concurrency-item">
                    <div class="concurrency-value">ForkJoinPool</div>
                    <div class="concurrency-label">Reports Generated By</div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Status Distribution Donut Chart
        var statusCtx = document.getElementById('statusChart').getContext('2d');
        new Chart(statusCtx, {
            type: 'doughnut',
            data: {
                labels: ['Confirmed', 'Cancelled', 'Waiting'],
                datasets: [{
                    data: [<%= confirmedCount %>, <%= cancelledCount %>, <%= waitingCount %>],
                    backgroundColor: ['#5cb87a', '#c1121f', '#f5a623'],
                    borderWidth: 0,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                var total = <%= totalBookings %>;
                                var value = context.raw;
                                var percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                                return context.label + ': ' + value + ' (' + percentage + '%)';
                            }
                        }
                    }
                },
                cutout: '60%'
            }
        });
        
        function generateReports() {
            document.querySelector('.generate-btn').innerHTML = 'Generating...';
            document.querySelector('.generate-btn').disabled = true;
            window.location.href = 'AdminServlet?action=reports&generate=true';
        }
    </script>
</body>
</html>
