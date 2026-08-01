<%@ page import="model.AdminPojo, service.ConcurrencyService, java.util.List, java.util.Map" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if(adminId == null) {
        response.sendRedirect("AdminLogin.jsp");
        return;
    }
    String adminName = (String) session.getAttribute("adminName");
    
    AdminPojo stats = (AdminPojo) request.getAttribute("stats");
    if(stats == null) {
        response.sendRedirect("AdminServlet?action=dashboard");
        return;
    }
    
    List<Map<String, Object>> recentActivities = (List<Map<String, Object>>) request.getAttribute("recentActivities");
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <title>Admin Dashboard</title>
    <meta charset="UTF-8">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }


        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /* left-to-right gradient: lighter grey → darker charcoal */
            background: linear-gradient(to right, #2e2e30 0%, #242426 40%, #1a1a1c 100%);
            min-height: 100vh;
            display: flex;
            margin: 0;
            padding: 0;
        }

        /* ── Sidebar ── */
        .sidebar {
            width: 280px;
            background: #272729;
            color: #f0f0f0;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            overflow-y: auto;
            margin: 0;
            border-right: 1px solid #3e3e40;
            /* slight inner shadow to lift sidebar off the gradient bg */
            box-shadow: 2px 0 12px rgba(0,0,0,0.35);
        }
        .sidebar-header {
            padding: 25px 20px;
            text-align: center;
            border-bottom: 1px solid #3e3e40;
        }
        .sidebar-header h2 { font-size: 20px; margin-bottom: 5px; color: #f5a623; }
        .sidebar-header p  { font-size: 12px; color: #9a9a9a; }

        .sidebar-menu { padding: 20px 0; }
        .menu-item {
            padding: 12px 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #9a9a9a;
            text-decoration: none;
            transition: 0.3s;
        }
        .menu-item:hover,
        .menu-item.active {
            background: #363638;
            color: #f5a623;
            border-left: 3px solid #f5a623;
        }
        .menu-icon { font-size: 18px; width: 30px; }

        /* ── Main Content ── */
        .main-content {
            margin-left: 280px;
            flex: 1;
            padding: 0 0 20px 0;
        }

        /* ── Navbar ── */
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
        .page-title { font-size: 24px; font-weight: 600; color: #f5a623; margin: 0; }
        .user-info  { display: flex; align-items: center; gap: 15px; margin-left: auto; }
        .user-name  { color: #9a9a9a; font-weight: 500; font-size: 14px; }
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

        /* ── Chart Row ── */
        .charts-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
            padding: 0 20px;
        }
        .chart-card {
            /* cards are slightly lighter than the darkest bg area — gives depth */
            background: rgba(44,44,46,0.92);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
            backdrop-filter: blur(2px);
        }
        .chart-card h3 {
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f5a623;
            color: #f0f0f0;
            text-align: center;
        }
        canvas { max-height: 250px; width: 100%; }

        /* ── Two Columns ── */
        .two-columns {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
            padding: 0 20px;
        }
        .card {
            background: rgba(44,44,46,0.92);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
        }
        .card h3 {
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f5a623;
            color: #f0f0f0;
        }
        .activity-item    { padding: 12px 0; border-bottom: 1px solid #3e3e40; }
        .activity-description { font-weight: 500; color: #e8e8e8; }
        .activity-time    { font-size: 12px; color: #9a9a9a; margin-top: 5px; }
        .metric-row       { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #3e3e40; }
        .metric-label     { color: #9a9a9a; }
        .metric-value     { font-weight: bold; color: #f5a623; }

        /* ── Alerts ── */
        .message {
            background: #1e3020; color: #5cb87a;
            padding: 12px; border-radius: 8px;
            margin: 0 20px 20px; border: 1px solid #2d4a33;
        }
        .error {
            background: #2e1a1a; color: #e8720c;
            padding: 12px; border-radius: 8px;
            margin: 0 20px 20px; border: 1px solid #4a2a2a;
        }

        /* ── Legend ── */
        .chart-legend {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 15px;
            font-size: 12px;
            flex-wrap: wrap;
            color: #9a9a9a;
        }
        .legend-color {
            width: 12px; height: 12px;
            display: inline-block;
            border-radius: 2px;
            margin-right: 5px;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>TRS</h2>
            <p>Train Reservation System</p>
        </div>
        <div class="sidebar-menu">
            <a href="AdminServlet?action=dashboard" class="menu-item active">
                <i class="fas fa-tachometer-alt menu-icon"></i>
                <span>Dashboard</span>
            </a>
            <a href="AdminServlet?action=manageTrains" class="menu-item">
                <i class="fas fa-train menu-icon"></i>
                <span>Train Management</span>
            </a>
            <a href="AdminServlet?action=bookings" class="menu-item">
                <i class="fas fa-ticket-alt menu-icon"></i>
                <span>Bookings</span>
            </a>
            <a href="AdminServlet?action=users" class="menu-item">
                <i class="fas fa-users menu-icon"></i>
                <span>Users</span>
            </a>
            <a href="AdminServlet?action=reports" class="menu-item">
                <i class="fas fa-chart-line menu-icon"></i>
                <span>Reports</span>
            </a>
            <a href="AdminServlet?action=adminProfile" class="menu-item">
                <i class="fas fa-user-circle menu-icon"></i>
                <span>Profile</span>
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">

        <!-- Navbar -->
        <div class="top-navbar">
            <h1 class="page-title">Dashboard</h1>
            <div class="user-info">
                <span class="user-name">Welcome, <%= adminName %></span>
                <form method="post" action="AdminServlet">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </div>

        <% if(request.getAttribute("message") != null) { %>
            <div class="message"><%= request.getAttribute("message") %></div>
        <% } %>
        <% if(request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <!-- Charts Row -->
        <div class="charts-row">
            <!-- Left: Bar Chart -->
            <div class="chart-card">
                <h3>System Overview</h3>
                <canvas id="overviewChart"></canvas>
                <div class="chart-legend">
                    <span><span class="legend-color" style="background:#f5a623;"></span> Total Users</span>
                    <span><span class="legend-color" style="background:#2ec4b6;"></span> Total Trains</span>
                    <span><span class="legend-color" style="background:#8a5cf6;"></span> Total Bookings</span>
                    <span><span class="legend-color" style="background:#c1121f;"></span> Today's Bookings</span>
                </div>
            </div>

            <!-- Right: Donut Chart -->
            <div class="chart-card">
                <h3>Revenue Distribution</h3>
                <canvas id="revenueChart"></canvas>
                <div class="chart-legend">
                    <span><span class="legend-color" style="background:#f5a623;"></span> Today's Revenue: Rs. <%= String.format("%.2f", stats.getTodaysRevenue()) %></span>
                    <span><span class="legend-color" style="background:#c1121f;"></span> Total Revenue: Rs. <%= String.format("%.2f", stats.getTotalRevenue()) %></span>
                </div>
            </div>
        </div>

        <!-- Two Columns: Concurrency Metrics + Recent Activities -->
        <div class="two-columns">

            <!-- Concurrency Metrics -->
            <div class="card">
                <h3>Concurrency Metrics</h3>
                <div class="metric-row">
                    <span class="metric-label">Active Booking Threads:</span>
                    <span class="metric-value"><%= ConcurrencyService.getActiveBookingCount() %></span>
                </div>
                <div class="metric-row">
                    <span class="metric-label">Booking Queue Size:</span>
                    <span class="metric-value"><%= ConcurrencyService.getQueueSize() %></span>
                </div>
                <div class="metric-row">
                    <span class="metric-label">Active Threads (Pool):</span>
                    <span class="metric-value"><%= ConcurrencyService.getActiveThreadCount() %></span>
                </div>
                <div class="metric-row">
                    <span class="metric-label">Locked Seats:</span>
                    <span class="metric-value"><%= ConcurrencyService.getSeatLockCount() %></span>
                </div>
                <div class="metric-row">
                    <span class="metric-label">Completed Tasks:</span>
                    <span class="metric-value"><%= ConcurrencyService.getCompletedTaskCount() %></span>
                </div>
                <div class="metric-row">
                    <span class="metric-label">Today's Bookings:</span>
                    <span class="metric-value"><%= ConcurrencyService.getTodaysBookingCount() %></span>
                </div>
            </div>

            <!-- Recent Activities -->
            <div class="card">
                <h3>Recent Activities</h3>
                <% if(recentActivities != null && !recentActivities.isEmpty()) {
                    for(Map<String, Object> activity : recentActivities) { %>
                        <div class="activity-item">
                            <div class="activity-description"><%= activity.get("description") %></div>
                            <div class="activity-time"><%= activity.get("time") %></div>
                        </div>
                <% } } else { %>
                    <div style="text-align:center; padding:20px; color:#9a9a9a;">No recent activities</div>
                <% } %>
            </div>

        </div>
    </div>

    <script>
        // ── Data from server-side (unchanged) ─────────────────────────
        const totalUsers    = <%= stats.getTotalUsers() %>;
        const totalTrains   = <%= stats.getTotalTrains() %>;
        const totalBookings = <%= stats.getTotalBookings() %>;
        const todaysBookings= <%= stats.getTodaysBookings() %>;
        const totalRevenue  = <%= stats.getTotalRevenue() %>;
        const todaysRevenue = <%= stats.getTodaysRevenue() %>;

        const gridColor = '#3e3e40';
        const tickColor = '#9a9a9a';

        // ── Bar Chart: System Overview ─────────────────────────────────
        const overviewCtx = document.getElementById('overviewChart').getContext('2d');
        new Chart(overviewCtx, {
            type: 'bar',
            data: {
                labels: ['Total Users', 'Total Trains', 'Total Bookings', "Today's Bookings"],
                datasets: [{
                    label: 'Count',
                    data: [totalUsers, totalTrains, totalBookings, todaysBookings],
                    backgroundColor: ['#f5a623', '#2ec4b6', '#8a5cf6', '#c1121f'],
                    borderRadius: 8,
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(context) { return context.raw.toLocaleString(); }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: 'Count', color: tickColor },
                        ticks: { color: tickColor },
                        grid:  { color: gridColor }
                    },
                    x: {
                        ticks: { font: { size: 11 }, color: tickColor },
                        grid:  { color: gridColor }
                    }
                }
            }
        });

        // ── Donut Chart: Revenue Distribution ─────────────────────────
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        new Chart(revenueCtx, {
            type: 'doughnut',
            data: {
                labels: ["Today's Revenue", 'Total Revenue'],
                datasets: [{
                    data: [todaysRevenue, totalRevenue],
                    backgroundColor: ['#f5a623', '#c1121f'],
                    borderWidth: 0,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const value = context.raw;
                                const total = todaysRevenue + totalRevenue;
                                const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                                return 'Rs. ' + value.toLocaleString() + ' (' + percentage + '%)';
                            }
                        }
                    }
                },
                cutout: '60%'
            }
        });
    </script>
</body>
</html>
