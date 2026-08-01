<%@ page import="java.util.List, java.util.Map" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if(adminId == null) response.sendRedirect("AdminLogin.jsp");
    String adminName = (String) session.getAttribute("adminName");

    List<Map<String, Object>> seats = (List<Map<String, Object>>) request.getAttribute("seats");
    Integer trainId = (Integer) request.getAttribute("trainId");
    String journeyDate = (String) request.getAttribute("journeyDate");
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Seats - Train <%= trainId %></title>
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
            font-size: 22px;
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

        .seat-container {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin: 0 20px;
            background: rgba(44,44,46,0.92);
            padding: 20px;
            border-radius: 12px;
            border: 1px solid #3e3e40;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
        }
        .seat-card {
            width: 100px;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }
        .seat-available {
            background: rgba(28, 60, 32, 0.8);
            border: 2px solid #5cb87a;
            color: #5cb87a;
        }
        .seat-booked {
            background: rgba(60, 20, 20, 0.8);
            border: 2px solid #c1121f;
            color: #e8720c;
        }
        .seat-number {
            font-size: 18px;
            font-weight: bold;
        }
        .seat-coach {
            font-size: 12px;
            margin-top: 5px;
        }
        .seat-type {
            font-size: 11px;
            margin-top: 3px;
            color: #9a9a9a;
        }
        .back-btn {
            background: #363638;
            color: #9a9a9a;
            padding: 10px 20px;
            border: 1px solid #3e3e40;
            border-radius: 8px;
            cursor: pointer;
            margin: 0 20px 20px 20px;
            display: inline-block;
            transition: all 0.3s;
        }
        .back-btn:hover { background: #f5a623; color: white; border-color: #f5a623; }
        .info-box {
            background: rgba(44,44,46,0.92);
            padding: 15px;
            border-radius: 8px;
            margin: 0 20px 20px 20px;
            border-left: 4px solid #f5a623;
            color: #9a9a9a;
            border: 1px solid #3e3e40;
            border-left: 4px solid #f5a623;
        }
        .info-box strong { color: #f5a623; }
        .legend {
            display: flex;
            gap: 20px;
            margin: 0 20px 20px 20px;
            padding: 12px;
            background: rgba(44,44,46,0.92);
            border-radius: 8px;
            border: 1px solid #3e3e40;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #9a9a9a;
        }
        .legend-color {
            width: 20px;
            height: 20px;
            border-radius: 4px;
        }
        .legend-color.available { background: rgba(28, 60, 32, 0.8); border: 1px solid #5cb87a; }
        .legend-color.booked { background: rgba(60, 20, 20, 0.8); border: 1px solid #c1121f; }

        /* ✅ NEW: date-select box - styled to match the existing legend/info-box cards */
        .date-select-box {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin: 0 20px 20px 20px;
            padding: 15px;
            background: rgba(44,44,46,0.92);
            border-radius: 8px;
            border: 1px solid #3e3e40;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
        }
        .date-select-box label {
            color: #9a9a9a;
            font-size: 13px;
            font-weight: 600;
        }
        .date-select-box input[type="date"] {
            padding: 8px 10px;
            border: 1px solid #3e3e40;
            border-radius: 6px;
            background: #1a1a1c;
            color: #f0f0f0;
            font-size: 13px;
        }
        .date-select-box input[type="date"]:focus {
            outline: none;
            border-color: #f5a623;
        }
        .date-select-box button {
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            transition: opacity 0.3s;
        }
        .date-select-box button:hover { opacity: 0.85; }
    </style>
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

    <div class="main-content">
        <div class="top-navbar">
            <h1 class="page-title">Seat Layout - Train ID: <%= trainId %> | Journey Date: <%= journeyDate %></h1>
            <form method="post" action="AdminServlet">
                <input type="hidden" name="action" value="logout">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>

        <button class="back-btn" onclick="history.back()">Back to Train Management</button>

        <div class="info-box">
            <strong>Information:</strong> This shows seat availability for the selected journey date.
            Green = Available | Red = Already Booked
        </div>

        <!-- ✅ NEW: Date picker - defaults to this train's most recent booking date
             (or tomorrow if no bookings exist yet), and lets the admin pick any
             other date to view that date's seat layout instead. -->
        <div class="date-select-box">
            <form method="get" action="AdminServlet" style="display:flex; align-items:center; gap:15px; flex-wrap:wrap;">
                <input type="hidden" name="action" value="viewSeats">
                <input type="hidden" name="trainId" value="<%= trainId %>">
                <label for="journeyDatePicker">Journey Date:</label>
                <input type="date" id="journeyDatePicker" name="journeyDate" value="<%= journeyDate %>">
                <button type="submit">View Seats for this Date</button>
            </form>
        </div>

        <div class="legend">
            <div class="legend-item">
                <div class="legend-color available"></div>
                <span>Available</span>
            </div>
            <div class="legend-item">
                <div class="legend-color booked"></div>
                <span>Booked</span>
            </div>
        </div>

        <div class="seat-container">
            <% if(seats != null && !seats.isEmpty()) {
                for(Map<String, Object> seat : seats) {
                    String status = (String) seat.get("status");
                    String seatClass = "AVAILABLE".equals(status) ? "seat-available" : "seat-booked";
            %>
                <div class="seat-card <%= seatClass %>">
                    <div class="seat-number"><%= seat.get("seatNumber") %></div>
                    <div class="seat-coach">Coach: <%= seat.get("coachNo") %></div>
                    <div class="seat-type">Type: <%= seat.get("seatType") %></div>
                    <div class="seat-coach"><%= status %></div>
                </div>
            <% } } else { %>
                <div style="text-align:center; width:100%; padding:50px; color:#9a9a9a;">
                    No seats found for this train.
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>