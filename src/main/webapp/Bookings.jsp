<%@ page import="java.util.List, model.UserPojo" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if(adminId == null) response.sendRedirect("AdminLogin.jsp");
    String adminName = (String) session.getAttribute("adminName");
    
    List<UserPojo> bookings = (List<UserPojo>) request.getAttribute("bookings");
    UserPojo singleBooking = (UserPojo) request.getAttribute("singleBooking");
    String searchPnr = request.getParameter("searchPnr");
    String searchError = (String) request.getAttribute("searchError");

    // ✅ NEW: pagination attributes
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bookings - Admin</title>
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
        
        .main-content { margin-left: 280px; flex: 1; padding: 0 0 20px 0; }

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

        .search-box { 
            background: rgba(44,44,46,0.92); 
            padding: 20px; 
            border-radius: 12px; 
            margin: 0 20px 25px 20px; 
            display: flex; 
            gap: 10px; 
            align-items: center; 
            flex-wrap: wrap; 
            border: 1px solid #3e3e40;
        }
        .search-box input { 
            padding: 10px; 
            border: 1px solid #3e3e40; 
            border-radius: 8px; 
            width: 300px; 
            font-size: 14px; 
            background: #1a1a1c;
            color: #f0f0f0;
        }
        .search-box input::placeholder { color: #9a9a9a; }
        .search-box input:focus { outline: none; border-color: #f5a623; }
        .search-box button { 
            background: linear-gradient(135deg, #e8720c, #c1121f);
            color: white; 
            padding: 10px 25px; 
            border: none; 
            border-radius: 8px; 
            cursor: pointer; 
            font-size: 14px; 
            transition: opacity 0.3s;
        }
        .search-box button:hover { opacity: 0.85; }
        
        table { 
            width: calc(100% - 40px); 
            margin: 0 20px;
            background: rgba(44,44,46,0.92); 
            border-radius: 12px; 
            overflow: hidden; 
            border-collapse: collapse; 
            border: 1px solid #3e3e40;
        }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #3e3e40; color: #f0f0f0; }
        th { background: #1a1a1c; color: #f5a623; }
        tr:hover td { background: rgba(54,54,56,0.5); }
        .status-confirmed { color: #5cb87a; font-weight: bold; }
        .status-cancelled { color: #e8720c; font-weight: bold; }
        .status-waiting { color: #f5a623; font-weight: bold; } /* ✅ NEW */
        .btn-view { 
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white; 
            padding: 5px 12px; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            margin-right: 5px; 
            font-size: 12px;
            transition: opacity 0.3s;
        }
        .btn-view:hover { opacity: 0.85; }
        .btn-cancel { 
            background: linear-gradient(135deg, #e8720c, #c1121f);
            color: white; 
            padding: 5px 12px; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 12px;
            transition: opacity 0.3s;
        }
        .btn-cancel:hover { opacity: 0.85; }
        
        .message { 
            background: #1e3020; 
            color: #5cb87a; 
            padding: 12px; 
            border-radius: 8px; 
            margin: 0 20px 20px 20px;
            border: 1px solid #2d4a33;
        }
        .error { 
            background: #2e1a1a; 
            color: #e8720c; 
            padding: 12px; 
            border-radius: 8px; 
            margin: 0 20px 20px 20px;
            border: 1px solid #4a2a2a;
        }
        .search-result-header { 
            background: rgba(44,44,46,0.92); 
            padding: 10px 15px; 
            border-radius: 8px; 
            margin: 15px 20px 10px 20px; 
            font-weight: bold; 
            color: #f5a623; 
            border: 1px solid #3e3e40;
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.7);
        }
        .modal-content {
            background: #272729;
            margin: 5% auto;
            padding: 25px;
            width: 500px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.5);
            border: 1px solid #3e3e40;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f5a623;
        }
        .modal-header h3 { color: #f0f0f0; }
        .close {
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            color: #9a9a9a;
        }
        .close:hover { color: #f0f0f0; }
        .passenger-detail { 
            margin-bottom: 15px; 
            padding: 10px; 
            background: rgba(26,26,28,0.8); 
            border-radius: 8px; 
            border-left: 3px solid #f5a623; 
        }
        .passenger-detail p { margin: 5px 0; color: #f0f0f0; }
        .detail-label { font-weight: bold; color: #9a9a9a; width: 100px; display: inline-block; }
        .not-found-message { 
            background: #2e2a1a; 
            color: #f5a623; 
            padding: 15px; 
            border-radius: 8px; 
            text-align: center; 
            margin: 0 20px 20px 20px; 
            border-left: 4px solid #f5a623; 
        }

        h3 { color: #f0f0f0; margin: 0 20px 15px 20px; }

        /* ✅ NEW: pagination controls */
        .pagination-controls {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin: 20px;
        }
        .pagination-controls a {
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
        }
        .pagination-controls a:hover { opacity: 0.85; }
        .pagination-controls span {
            color: #9a9a9a;
            padding: 8px 12px;
            font-size: 13px;
        }
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
            <a href="AdminServlet?action=bookings" class="menu-item active">
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
            <h1 class="page-title">Bookings Management</h1>
            <form method="post" action="AdminServlet">
                <input type="hidden" name="action" value="logout">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
        
        <!-- Search Box -->
        <div class="search-box">
            <input type="text" id="pnrSearchInput" placeholder="Enter PNR to search..." value="<%= searchPnr != null ? searchPnr : "" %>">
            <button onclick="searchByPNR()">Search by PNR</button>
            <button onclick="showAllBookings()">Show All Bookings</button>
        </div>
        
        <% if(request.getAttribute("message") != null) { %>
            <div class="message"><%= request.getAttribute("message") %></div>
        <% } %>
        <% if(request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <!-- Search Result Not Found Message -->
        <% if(searchError != null && searchError.equals("not_found")) { %>
            <div class="not-found-message">
                <strong>No booking found for PNR: <%= searchPnr %></strong><br>
                Please check the PNR number and try again.
            </div>
        <% } %>
        
        <!-- Search Result Section (Single Booking) -->
        <% if(singleBooking != null) { %>
            <div class="search-result-header">
                Search Result for PNR: <%= singleBooking.getPnr() %>
            </div>
            <table style="margin-bottom: 30px;">
                <thead>
                    <tr>
                        <th>PNR</th>
                        <th>User</th>
                        <th>Train</th>
                        <th>Journey Date</th>
                        <th>Passengers</th>
                        <th>Fare</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><%= singleBooking.getPnr() %></td>
                        <td><%= singleBooking.getName() != null ? singleBooking.getName() : "User " + singleBooking.getUserId() %></td>
                        <td><%= singleBooking.getTrainName() != null ? singleBooking.getTrainName() : "Train " + singleBooking.getTrainId() %></td>
                        <td><%= singleBooking.getJourneyDate() %></td>
                        <td><%= singleBooking.getTotalPassengers() %></td>
                        <td>Rs. <%= singleBooking.getTotalFare() %></td>
                        <td class="status-<%= singleBooking.getBookingStatus().toLowerCase() %>"><%= singleBooking.getBookingStatus() %></td>
                        <td>
                            <button class="btn-view" onclick="viewBookingDetails('<%= singleBooking.getPnr() %>')">View Details</button>
                            <% if("CONFIRMED".equals(singleBooking.getBookingStatus())) { %>
                                <button class="btn-cancel" onclick="cancelBooking('<%= singleBooking.getBookingId() %>')">Cancel Booking</button>
                            <% } %>
                        </td>
                    </tr>
                </tbody>
            </table>
        <% } %>
        
        <!-- All Bookings Table -->
        <h3>All Bookings</h3>
        <table>
            <thead>
                <tr>
                    <th>PNR</th>
                    <th>User</th>
                    <th>Train</th>
                    <th>Journey Date</th>
                    <th>Passengers</th>
                    <th>Fare</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if(bookings != null && !bookings.isEmpty()) { 
                    for(UserPojo b : bookings) { 
                %>
                <tr>
                    <td><%= b.getPnr() != null ? b.getPnr() : "-" %></td>
                    <td><%= b.getName() != null ? b.getName() : "User " + b.getUserId() %></td>
                    <td><%= b.getTrainName() != null ? b.getTrainName() : "Train " + b.getTrainId() %></td>
                    <td><%= b.getJourneyDate() != null ? b.getJourneyDate() : "-" %></td>
                    <td><%= b.getTotalPassengers() %></td>
                    <td>Rs. <%= b.getTotalFare() %></td>
                    <td class="status-<%= b.getBookingStatus() != null ? b.getBookingStatus().toLowerCase() : "confirmed" %>">
                        <%= b.getBookingStatus() != null ? b.getBookingStatus() : "CONFIRMED" %>
                    </td>
                    <td class="actions-cell">
                        <button class="btn-view" onclick="viewBookingDetails('<%= b.getPnr() %>')">View Details</button>
                        <% if("CONFIRMED".equals(b.getBookingStatus())) { %>
                            <button class="btn-cancel" onclick="cancelBooking('<%= b.getBookingId() %>')">Cancel Booking</button>
                        <% } %>
                    </td>
                </tr>
                <% } } else { %>
                    <tr><td colspan="8" style="text-align:center; padding:40px; color:#9a9a9a;">No bookings found</td></tr>
                <% } %>
            </tbody>
        </table>

        <!-- ✅ NEW: pagination controls -->
        <% if(totalPages != null && totalPages > 1) { %>
        <div class="pagination-controls">
            <% if(currentPage > 1) { %>
                <a href="AdminServlet?action=bookings&page=<%= currentPage - 1 %>">← Previous</a>
            <% } %>
            <span>Page <%= currentPage %> of <%= totalPages %></span>
            <% if(currentPage < totalPages) { %>
                <a href="AdminServlet?action=bookings&page=<%= currentPage + 1 %>">Next →</a>
            <% } %>
        </div>
        <% } %>
    </div>
    
    <!-- View Details Modal -->
    <div id="viewDetailsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Booking Details</h3>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <div id="modalContent">
                <div style="text-align:center; padding:20px; color:#9a9a9a;">Loading...</div>
            </div>
        </div>
    </div>
    
    <script>
        function searchByPNR() {
            let pnr = document.getElementById('pnrSearchInput').value.trim();
            if(pnr) {
                window.location.href = 'AdminServlet?action=bookings&pnr=' + encodeURIComponent(pnr);
            } else {
                alert('Please enter a PNR to search');
            }
        }
        
        function showAllBookings() {
            window.location.href = 'AdminServlet?action=bookings';
        }
        
        function viewBookingDetails(pnr) {
            document.getElementById("viewDetailsModal").style.display = "block";
            document.getElementById("modalContent").innerHTML = '<div style="text-align:center; padding:20px; color:#9a9a9a;">Loading passenger details...</div>';
            
            fetch('AdminServlet?action=getBookingDetails&pnr=' + encodeURIComponent(pnr))
                .then(response => response.json())
                .then(data => {
                    if(data && data.length > 0) {
                        if(data[0].status === 'CANCELLED') {
                            let html = '<div style="text-align:center; padding:20px;">';
                            html += '<div style="background:#2e1a1a; color:#e8720c; padding:15px; border-radius:8px; border-left:4px solid #c1121f;">';
                            html += '<strong>⚠️ Booking Cancelled</strong><br>';
                            html += 'This booking has been CANCELLED. No passenger details are available.';
                            html += '</div>';
                            html += '</div>';
                            document.getElementById("modalContent").innerHTML = html;
                            return;
                        }
                        
                        let html = '<div style="max-height: 400px; overflow-y: auto;">';
                        html += '<p style="margin-bottom:15px; color:#f0f0f0;"><strong>PNR:</strong> ' + pnr + '</p>';
                        html += '<h4 style="margin-bottom:10px; color:#f5a623;">Passenger Details:</h4>';
                        
                        data.forEach((passenger, index) => {
                            html += '<div class="passenger-detail">';
                            html += '<p><span class="detail-label">Passenger ' + (index + 1) + ':</span></p>';
                            html += '<p><span class="detail-label">Name:</span> ' + (passenger.name || '-') + '</p>';
                            html += '<p><span class="detail-label">Age:</span> ' + (passenger.age || '-') + '</p>';
                            html += '<p><span class="detail-label">Gender:</span> ' + (passenger.gender || '-') + '</p>';
                            html += '<p><span class="detail-label">Seat Number:</span> ' + (passenger.seatNumber || '-') + '</p>';
                            html += '<p><span class="detail-label">Coach:</span> ' + (passenger.coachNo || '-') + '</p>';
                            html += '</div>';
                        });
                        html += '</div>';
                        document.getElementById("modalContent").innerHTML = html;
                    } else {
                        document.getElementById("modalContent").innerHTML = '<div style="text-align:center; padding:20px; color:#9a9a9a;">No passenger details found for this booking.</div>';
                    }
                })
                .catch(error => {
                    document.getElementById("modalContent").innerHTML = '<div style="text-align:center; padding:20px; color:#e8720c;">Error loading passenger details</div>';
                });
        }        
        function cancelBooking(bookingId) {
            if(confirm('Are you sure you want to cancel this booking?')) {
                window.location.href = 'AdminServlet?action=cancelBooking&bookingId=' + bookingId;
            }
        }
        
        function closeModal() {
            document.getElementById("viewDetailsModal").style.display = "none";
        }
        
        window.onclick = function(event) {
            if (event.target == document.getElementById("viewDetailsModal")) {
                closeModal();
            }
        }
    </script>
</body>
</html>