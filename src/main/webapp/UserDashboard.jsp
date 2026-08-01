<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserPojo, java.util.List, java.util.Map, java.util.Calendar, java.util.Date, java.text.SimpleDateFormat, java.util.concurrent.TimeUnit" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    
    if(userId == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    UserPojo pojo = new UserPojo();
    pojo.setUserId(userId);
    
    Map<String, Object> dashboardStats = pojo.getUserDashboardStats();
    List<Map<String, Object>> recentBookings = pojo.getUserRecentBookings();
    
    // Get all bookings for status distribution
    List<UserPojo> allBookings = pojo.getBookingHistory();
    
    // Count status distribution
    int confirmedCount = 0;
    int cancelledCount = 0;
    int expiredCount = 0;
    
    for(UserPojo booking : allBookings) {
        String status = booking.getBookingStatus();
        if("CONFIRMED".equals(status)) confirmedCount++;
        else if("CANCELLED".equals(status)) cancelledCount++;
        else if("EXPIRED".equals(status)) expiredCount++;
    }
    
    // Only get upcoming journey date and train name (no calculation here)
    String upcomingJourneyText = (String) dashboardStats.get("upcomingJourney");
    String upcomingTrainName = "";
    String upcomingDate = "";
    boolean hasUpcoming = false;
    
    if(upcomingJourneyText != null && !"No upcoming journey".equals(upcomingJourneyText) && !upcomingJourneyText.isEmpty()) {
        hasUpcoming = true;
        
        // Parse "Train Name on YYYY-MM-DD" - using regex to find date
        String datePattern = "\\d{4}-\\d{2}-\\d{2}";
        java.util.regex.Pattern p = java.util.regex.Pattern.compile(datePattern);
        java.util.regex.Matcher m = p.matcher(upcomingJourneyText);
        
        if(m.find()) {
            upcomingDate = m.group();
            int dateIndex = upcomingJourneyText.indexOf(upcomingDate);
            if(dateIndex > 0) {
                upcomingTrainName = upcomingJourneyText.substring(0, dateIndex).trim();
                if(upcomingTrainName.endsWith(" on")) {
                    upcomingTrainName = upcomingTrainName.substring(0, upcomingTrainName.length() - 3).trim();
                }
            }
        } else {
            int lastSpaceIndex = upcomingJourneyText.lastIndexOf(" on");
            if(lastSpaceIndex > 0) {
                upcomingTrainName = upcomingJourneyText.substring(0, lastSpaceIndex).trim();
                upcomingDate = upcomingJourneyText.substring(lastSpaceIndex + 4).trim();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Train Reservation</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #2e2e30 0%, #242426 40%, #1a1a1c 100%);
            min-height: 100vh;
        }
        
        /* Navbar - Same color as sidebar */
        .navbar {
            background: #272729;
            color: #f0f0f0;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
            box-shadow: 0 2px 12px rgba(0,0,0,0.3);
            border-bottom: 1px solid #3e3e40;
        }
        .navbar .logo { font-size: 20px; font-weight: bold; color: #f5a623; }
        .navbar .user-section { display: flex; align-items: center; gap: 15px; }
        .navbar .user-name { font-size: 14px; color: #9a9a9a; }
        .navbar .logout-icon {
            background: linear-gradient(135deg, #e8720c, #c1121f);
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            color: white;
            font-size: 13px;
        }
        .navbar .logout-icon:hover { opacity: 0.85; }
        
        /* Sidebar - Same color as navbar */
        .sidebar {
            width: 250px;
            background: #272729;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 60px;
            box-shadow: 2px 0 12px rgba(0,0,0,0.35);
            border-right: 1px solid #3e3e40;
        }
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
        .menu-item:hover, .menu-item.active {
            background: #363638;
            color: #f5a623;
            border-left: 3px solid #f5a623;
        }
        .menu-icon { font-size: 18px; width: 30px; }
        
        /* Main Content */
        .main-content { margin-left: 250px; margin-top: 60px; padding: 25px; }
        
        /* Two Columns Layout */
        .dashboard-two-columns {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        /* Donut Chart Card */
        .chart-card {
            background: rgba(44,44,46,0.92);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
        }
        .chart-card h3 {
            margin-bottom: 15px;
            color: #f0f0f0;
            border-bottom: 2px solid #f5a623;
            padding-bottom: 10px;
            font-size: 16px;
        }
        canvas { max-height: 200px; width: 100%; }
        .chart-legend {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 15px;
            font-size: 12px;
            color: #9a9a9a;
        }
        .legend-color { width: 12px; height: 12px; display: inline-block; border-radius: 2px; margin-right: 5px; }
        
        /* Countdown Timer Card */
        .countdown-card {
            background: rgba(44,44,46,0.92);
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
        }
        .countdown-card h3 {
            margin-bottom: 15px;
            color: #f0f0f0;
            border-bottom: 2px solid #f5a623;
            padding-bottom: 10px;
            font-size: 16px;
        }
        .train-name { font-size: 18px; font-weight: bold; color: #f5a623; margin-bottom: 10px; }
        .journey-date { color: #9a9a9a; margin-bottom: 15px; font-size: 14px; }
        .countdown-timer {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 15px;
        }
        .time-box {
            background: #272729;
            color: #f0f0f0;
            padding: 12px;
            border-radius: 10px;
            min-width: 70px;
            text-align: center;
            border: 1px solid #3e3e40;
        }
        .time-number {
            font-size: 28px;
            font-weight: bold;
            color: #f5a623;
        }
        .time-label {
            font-size: 10px;
            color: #9a9a9a;
            margin-top: 5px;
        }
        .no-upcoming {
            padding: 40px;
            color: #9a9a9a;
            text-align: center;
        }
        
        /* Recent Bookings Table */
        .recent-section {
            background: rgba(44,44,46,0.92);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
        }
        .recent-section h3 { margin-bottom: 15px; color: #f0f0f0; font-size: 16px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #3e3e40; font-size: 14px; color: #e8e8e8; }
        th { background: #272729; color: #f5a623; }
        .status-confirmed { color: #5cb87a; font-weight: bold; }
        .status-cancelled { color: #e8720c; font-weight: bold; }
        .status-expired { color: #9a9a9a; font-weight: bold; }
        .btn-view {
            background: linear-gradient(135deg, #e8720c, #c1121f);
            color: white;
            border: none;
            padding: 5px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        .btn-view:hover { opacity: 0.85; }
        
        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.6);
        }
        .modal-content {
            background: #2c2c2e;
            margin: 8% auto;
            padding: 25px;
            width: 450px;
            border-radius: 10px;
            border: 1px solid #3e3e40;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f5a623;
        }
        .modal-header h3 { color: #f0f0f0; }
        .close { font-size: 24px; cursor: pointer; color: #9a9a9a; }
        .close:hover { color: #f5a623; }
        .ticket-detail { margin: 8px 0; padding: 6px; background: #272729; border-radius: 4px; color: #e8e8e8; }
        .detail-label { font-weight: bold; width: 100px; display: inline-block; color: #f5a623; }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <div class="logo">Train Reservation System</div>
        <div class="user-section">
            <span class="user-name">Welcome, <%= userName %></span>
            <a href="UserServlet?action=logout" class="logout-icon">Logout</a>
        </div>
    </div>
    
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-menu">
            <a href="UserDashboard.jsp" class="menu-item active">
                <span class="menu-icon">📊</span>
                <span>Dashboard</span>
            </a>
            <a href="SearchTrain.jsp" class="menu-item">
                <span class="menu-icon">🔍</span>
                <span>Search Trains</span>
            </a>
            <a href="MyBookings.jsp" class="menu-item">
                <span class="menu-icon">📋</span>
                <span>My Bookings</span>
            </a>
            <a href="Profile.jsp" class="menu-item">
                <span class="menu-icon">👤</span>
                <span>Profile</span>
            </a>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <!-- Two Columns: Donut Chart + Countdown Timer -->
        <div class="dashboard-two-columns">
            <!-- Left: Donut Chart for Status Distribution -->
            <div class="chart-card">
                <h3>Booking Status Distribution</h3>
                <canvas id="statusChart"></canvas>
                <div class="chart-legend">
                    <span><span class="legend-color" style="background:#5cb87a;"></span> Confirmed (<%= confirmedCount %>)</span>
                    <span><span class="legend-color" style="background:#e8720c;"></span> Cancelled (<%= cancelledCount %>)</span>
                    <span><span class="legend-color" style="background:#9a9a9a;"></span> Expired (<%= expiredCount %>)</span>
                </div>
            </div>
            
            <!-- Right: Countdown Timer for Upcoming Journey -->
            <div class="countdown-card">
                <h3>Upcoming Journey</h3>
                <% if(hasUpcoming && upcomingDate != null && !upcomingDate.isEmpty()) { %>
                    <div class="train-name">🚆 <%= upcomingTrainName %></div>
                    <div class="journey-date">📅 <%= upcomingDate %></div>
                    <div class="countdown-timer">
                        <div class="time-box">
                            <div class="time-number" id="days">--</div>
                            <div class="time-label">Days</div>
                        </div>
                        <div class="time-box">
                            <div class="time-number" id="hours">--</div>
                            <div class="time-label">Hours</div>
                        </div>
                        <div class="time-box">
                            <div class="time-number" id="minutes">--</div>
                            <div class="time-label">Mins</div>
                        </div>
                        <div class="time-box">
                            <div class="time-number" id="seconds">--</div>
                            <div class="time-label">Secs</div>
                        </div>
                    </div>
                    <input type="hidden" id="upcomingDateHidden" value="<%= upcomingDate %>">
                <% } else { %>
                    <div class="no-upcoming">
                        🎫 No upcoming journey
                    </div>
                <% } %>
            </div>
        </div>
        
        <!-- Recent Bookings Table -->
        <div class="recent-section">
            <h3>Recent Bookings</h3>
            <table>
                <thead>
                    <tr>
                        <th>PNR</th>
                        <th>Train</th>
                        <th>Journey Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if(recentBookings != null && !recentBookings.isEmpty()) {
                        for(Map<String, Object> booking : recentBookings) { %>
                            <tr>
                                <td><%= booking.get("pnr") %></td>
                                <td><%= booking.get("trainName") %></td>
                                <td><%= booking.get("journeyDate") %></td>
                                <td class="status-<%= booking.get("bookingStatus").toString().toLowerCase() %>"><%= booking.get("bookingStatus") %></td>
                                <td><button class="btn-view" onclick="viewTicket('<%= booking.get("pnr") %>')">View Ticket</button></td>
                            </tr>
                    <% } } else { %>
                        <tr><td colspan="5" style="text-align:center;">No bookings found</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- View Ticket Modal -->
    <div id="ticketModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Ticket Details</h3>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <div id="ticketContent">Loading...</div>
        </div>
    </div>
    
    <script>
        // Donut Chart
        const ctx = document.getElementById('statusChart').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Confirmed', 'Cancelled', 'Expired'],
                datasets: [{
                    data: [<%= confirmedCount %>, <%= cancelledCount %>, <%= expiredCount %>],
                    backgroundColor: ['#5cb87a', '#e8720c', '#9a9a9a'],
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
                                const total = <%= confirmedCount + cancelledCount + expiredCount %>;
                                const value = context.raw;
                                const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                                return context.label + ': ' + value + ' (' + percentage + '%)';
                            }
                        }
                    }
                },
                cutout: '60%'
            }
        });
        
        // Countdown Timer - Counts down to end of the day (23:59:59)
        <% if(hasUpcoming && upcomingDate != null && !upcomingDate.isEmpty()) { %>
        const daysElement = document.getElementById('days');
        const hoursElement = document.getElementById('hours');
        const minutesElement = document.getElementById('minutes');
        const secondsElement = document.getElementById('seconds');
        
        function updateCountdown() {
            const journeyDateStr = document.getElementById('upcomingDateHidden').value;
            
            if(!journeyDateStr || journeyDateStr === '') {
                return;
            }
            
            // Countdown to END of the day (23:59:59)
            const journeyDateTime = new Date(journeyDateStr + 'T23:59:59').getTime();
            const now = new Date().getTime();
            const diff = journeyDateTime - now;
            
            if(diff > 0) {
                const days = Math.floor(diff / (1000 * 60 * 60 * 24));
                const hours = Math.floor((diff % (86400000)) / (3600000));
                const minutes = Math.floor((diff % (3600000)) / (60000));
                const seconds = Math.floor((diff % (60000)) / 1000);
                
                if(daysElement) daysElement.innerText = days;
                if(hoursElement) hoursElement.innerText = hours;
                if(minutesElement) minutesElement.innerText = minutes;
                if(secondsElement) secondsElement.innerText = seconds;
            } else {
                if(daysElement) daysElement.innerText = '0';
                if(hoursElement) hoursElement.innerText = '0';
                if(minutesElement) minutesElement.innerText = '0';
                if(secondsElement) secondsElement.innerText = '0';
            }
        }
        
        updateCountdown();
        setInterval(updateCountdown, 1000);
        <% } %>
        
        function viewTicket(pnr) {
            document.getElementById('ticketModal').style.display = 'block';
            document.getElementById('ticketContent').innerHTML = 'Loading...';
            
            fetch('UserServlet?action=getTicketDetails&pnr=' + pnr)
                .then(response => response.json())
                .then(data => {
                    let html = '<div class="ticket-detail"><span class="detail-label">PNR:</span> ' + data.pnr + '</div>';
                    html += '<div class="ticket-detail"><span class="detail-label">Train:</span> ' + data.trainName + '</div>';
                    html += '<div class="ticket-detail"><span class="detail-label">Passenger:</span> ' + data.passengerName + '</div>';
                    html += '<div class="ticket-detail"><span class="detail-label">Age:</span> ' + data.age + '</div>';
                    html += '<div class="ticket-detail"><span class="detail-label">Gender:</span> ' + data.gender + '</div>';
                    html += '<div class="ticket-detail"><span class="detail-label">Journey Date:</span> ' + data.journeyDate + '</div>';
                    html += '<div class="ticket-detail"><span class="detail-label">Seat:</span> ' + data.seatNumber + '</div>';
                    html += '<div class="ticket-detail"><span class="detail-label">Coach:</span> ' + data.coachNo + '</div>';
                    html += '<div class="ticket-detail"><span class="detail-label">Fare:</span> Rs. ' + data.fare + '</div>';
                    html += '<div class="ticket-detail"><span class="detail-label">Status:</span> ' + data.status + '</div>';
                    document.getElementById('ticketContent').innerHTML = html;
                })
                .catch(error => {
                    document.getElementById('ticketContent').innerHTML = '<div style="text-align:center;color:red;">Error loading ticket details</div>';
                });
        }
        
        function closeModal() {
            document.getElementById('ticketModal').style.display = 'none';
        }
        
        window.onclick = function(event) {
            if(event.target == document.getElementById('ticketModal')) closeModal();
        }
    </script>
</body>
</html>
