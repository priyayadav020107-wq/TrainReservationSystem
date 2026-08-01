<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserPojo, java.util.List, java.util.Map" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    
    if(userId == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    // ✅ NEW: pagination
    int pageSize = 5;
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if(pageParam != null) {
        try { currentPage = Integer.parseInt(pageParam); if(currentPage < 1)  currentPage= 1; } catch(NumberFormatException e) { currentPage = 1; }
    }
    
    UserPojo pojo = new UserPojo();
    pojo.setUserId(userId);
    
    int totalBookings = pojo.getBookingHistoryCount();
    int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
    if(totalPages < 1) totalPages = 1;
    if(currentPage > totalPages) currentPage = totalPages;
    int offset = (currentPage - 1) * pageSize;
    
    List<UserPojo> bookings = pojo.getBookingHistoryPaged(pageSize, offset);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Bookings</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #2e2e30 0%, #242426 40%, #1a1a1c 100%);
            min-height: 100vh;
        }
        
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
            border-bottom: 1px solid #3e3e40;
            box-shadow: 0 2px 12px rgba(0,0,0,0.3);
        }
        .navbar .logo { font-size: 20px; font-weight: bold; color: #f5a623; }
        .navbar .user-section { display: flex; align-items: center; gap: 15px; }
        .navbar .user-name { font-size: 14px; color: #9a9a9a; }
        .navbar .profile-icon, .navbar .logout-icon {
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            color: white;
            font-size: 13px;
        }
        .navbar .profile-icon { background: linear-gradient(135deg, #f5a623, #e8720c); }
        .navbar .logout-icon { background: linear-gradient(135deg, #e8720c, #c1121f); }
        
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

        .main-content { margin-left: 250px; margin-top: 60px; padding: 25px; }
        
        .bookings-card {
            background: rgba(44,44,46,0.92);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
        }
        .bookings-card h3 {
            color: #f0f0f0;
            border-bottom: 2px solid #f5a623;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #3e3e40; font-size: 14px; color: #e8e8e8; }
        th { background: #272729; color: #f5a623; }
        .status-confirmed { color: #5cb87a; font-weight: bold; }
        .status-cancelled { color: #e8720c; font-weight: bold; }
        .status-expired   { color: #9a9a9a; font-weight: bold; }
        .status-waiting   { color: #f5a623; font-weight: bold; } /* ✅ NEW */
        .btn-view, .btn-download, .btn-cancel {
            border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; margin: 2px;
            font-size: 12px;
            color: white;
        }
        .btn-view     { background: linear-gradient(135deg, #f5a623, #e8720c); }
        .btn-download { background: #5cb87a; }
        .btn-cancel   { background: linear-gradient(135deg, #e8720c, #c1121f); }
        
        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.6);
        }
        .modal-content {
            background: #2c2c2e;
            margin: 8% auto;
            padding: 25px;
            width: 500px;
            border-radius: 10px;
            max-height: 80vh;
            overflow-y: auto;
            border: 1px solid #3e3e40;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            color: #e8e8e8;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            border-bottom: 2px solid #f5a623;
            padding-bottom: 10px;
        }
        .modal-header h3 { color: #f0f0f0; }
        .close { font-size: 24px; cursor: pointer; color: #9a9a9a; }
        .close:hover { color: #f5a623; }
        .ticket-detail { margin: 8px 0; padding: 6px; background: #272729; border-radius: 4px; }
        .detail-label { font-weight: bold; width: 120px; display: inline-block; color: #f5a623; }
        .confirm-cancel {
            background: linear-gradient(135deg, #e8720c, #c1121f); color: white;
            padding: 8px 20px; border: none; border-radius: 5px; cursor: pointer;
        }

        /* Passenger card inside modal */
        .passenger-block {
            background: #272729;
            border: 1px solid #3e3e40;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 10px;
        }
        .passenger-block h5 {
            color: #f5a623;
            margin-bottom: 8px;
            font-size: 13px;
            border-bottom: 1px solid #3e3e40;
            padding-bottom: 5px;
        }
        .passenger-block .p-row {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            font-size: 13px;
        }
        .passenger-block .p-row span {
            background: #2c2c2e;
            border: 1px solid #3e3e40;
            border-radius: 4px;
            padding: 3px 8px;
            color: #e8e8e8;
        }
        .passenger-block .p-row .seat-badge {
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white;
            font-weight: bold;
        }

        /* ✅ NEW: pagination controls */
        .pagination-controls {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 20px;
        }
        .pagination-controls a {
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white;
            padding: 8px 16px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 13px;
        }
        .pagination-controls a:hover { opacity: 0.85; }
        .pagination-controls span {
            color: #9a9a9a;
            padding: 8px 12px;
            font-size: 13px;
        }

        /* Print styles */
        @media print {
            .modal-header .close,
            .no-print { display: none !important; }
            .modal-content { box-shadow: none; border: none; }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo">Train Reservation System</div>
        <div class="user-section">
            <span class="user-name">Welcome, <%= userName %></span>
            <a href="UserServlet?action=logout" class="logout-icon">Logout</a>
        </div>
    </div>
    
    <div class="sidebar">
        <div class="sidebar-menu">
            <a href="UserDashboard.jsp" class="menu-item"><span class="menu-icon">📊</span><span>Dashboard</span></a>
            <a href="SearchTrain.jsp"   class="menu-item"><span class="menu-icon">🔍</span><span>Search Trains</span></a>
            <a href="MyBookings.jsp"    class="menu-item active"><span class="menu-icon">📋</span><span>My Bookings</span></a>
            <a href="Profile.jsp"       class="menu-item"><span class="menu-icon">👤</span><span>Profile</span></a>
        </div>
    </div>
    
    <div class="main-content">
        <div class="bookings-card">
            <h3>My Bookings</h3>
            <table>
                <thead>
                    <tr>
                        <th>PNR</th>
                        <th>Train ID</th>
                        <th>Journey Date</th>
                        <th>Passengers</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if(bookings != null && !bookings.isEmpty()) {
                        for(UserPojo booking : bookings) { %>
                            <tr>
                                <td><%= booking.getPnr() %></td>
                                <td><%= booking.getTrainId() %></td>
                                <td><%= booking.getJourneyDate() %></td>
                                <td><%= booking.getTotalPassengers() %></td>
                                <td>Rs. <%= booking.getTotalFare() %></td>
                                <td class="status-<%= booking.getBookingStatus().toLowerCase() %>">
                                    <%= booking.getBookingStatus() %>
                                </td>
                                <td>
                                    <button class="btn-view"     onclick="viewBooking('<%= booking.getPnr() %>')">View</button>
                                    <button class="btn-download" onclick="downloadTicket('<%= booking.getPnr() %>')">Download</button>
                                    <% if("CONFIRMED".equals(booking.getBookingStatus()) || "WAITING".equals(booking.getBookingStatus())) { %>
                                        <button class="btn-cancel" onclick="confirmCancel(<%= booking.getBookingId() %>)">Cancel</button>
                                    <% } %>
                                </td>
                            </tr>
                    <% } } else { %>
                        <tr><td colspan="7" style="text-align:center;">No bookings found</td></tr>
                    <% } %>
                </tbody>
            </table>

            <!-- ✅ NEW: pagination controls -->
            <% if(totalPages > 1) { %>
            <div class="pagination-controls">
                <% if(currentPage > 1) { %>
                    <a href="MyBookings.jsp?page=<%= currentPage - 1 %>">← Previous</a>
                <% } %>
                <span>Page <%= currentPage %> of <%= totalPages %></span>
                <% if(currentPage < totalPages) { %>
                    <a href="MyBookings.jsp?page=<%= currentPage + 1 %>">Next →</a>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>
    
    <!-- View Booking Modal -->
    <div id="viewModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Booking Details</h3>
                <span class="close" onclick="closeViewModal()">&times;</span>
            </div>
            <div id="viewContent">Loading...</div>
        </div>
    </div>
    
    <!-- Cancel Confirmation Modal -->
    <div id="cancelModal" class="modal">
        <div class="modal-content" style="text-align:center;">
            <div class="modal-header">
                <h3>Confirm Cancellation</h3>
                <span class="close" onclick="closeCancelModal()">&times;</span>
            </div>
            <p style="margin:20px 0;">Are you sure you want to cancel this booking?</p>
            <button class="confirm-cancel" onclick="cancelBooking()">Yes, Cancel Booking</button>
            <button style="background:#3e3e40; color:white; padding:8px 20px; border:none; border-radius:5px; margin-left:10px; cursor:pointer;"
                    onclick="closeCancelModal()">No, Go Back</button>
            <input type="hidden" id="cancelBookingId">
        </div>
    </div>
    
    <script>

    function fetchTicketData(pnr) {
        return fetch('UserServlet?action=getTicketDetails&pnr=' + encodeURIComponent(pnr))
                .then(function(r) { return r.json(); });
    }

    function buildPassengersHTML(passengers) {
        if (!passengers || passengers.length === 0) {
            return '<div style="color:#888; font-size:13px;">No passenger details found.</div>';
        }

        let html = '';
        for (let i = 0; i < passengers.length; i++) {
            let p = passengers[i];
            html += '<div class="passenger-block">';
            html += '<h5>Passenger ' + (i + 1) + '</h5>';
            html += '<div class="p-row">';
            html += '<span><strong>Name:</strong> '   + p.name   + '</span>';
            html += '<span><strong>Age:</strong> '    + p.age    + '</span>';
            html += '<span><strong>Gender:</strong> ' + p.gender + '</span>';
            html += '<span class="seat-badge">Seat: ' + p.seatNumber + ' | Coach: ' + p.coachNo + '</span>';
            html += '</div>';
            html += '</div>';
        }
        return html;
    }

function viewBooking(pnr) {
    document.getElementById('viewModal').style.display = 'block';
    document.getElementById('viewContent').innerHTML = '<div style="text-align:center; padding:20px;">Loading ticket details...</div>';
    
    fetch('UserServlet?action=getTicketDetails&pnr=' + encodeURIComponent(pnr))
        .then(response => response.json())
        .then(data => {
            if(data.error) {
                document.getElementById('viewContent').innerHTML = '<div style="color:red;">' + data.error + '</div>';
                return;
            }
            
            let html = '<div class="ticket-detail"><span class="detail-label">PNR:</span> ' + (data.pnr || 'N/A') + '</div>';
            html += '<div class="ticket-detail"><span class="detail-label">Train:</span> ' + (data.trainName || 'N/A') + '</div>';
            html += '<div class="ticket-detail"><span class="detail-label">Journey Date:</span> ' + (data.journeyDate || 'N/A') + '</div>';
            html += '<div class="ticket-detail"><span class="detail-label">Status:</span> ' + (data.status || 'N/A') + '</div>';
            html += '<hr style="margin:12px 0; border-color:#3e3e40;">';
            html += '<h4 style="margin-bottom:10px; color:#f5a623;">Passenger Details</h4>';
            html += '<div class="passenger-block" style="background:#272729; border:1px solid #3e3e40; border-radius:8px; padding:12px; margin-bottom:10px;">';
            html += '<div class="p-row" style="display:flex; gap:8px; flex-wrap:wrap;">';
            html += '<span style="background:#2c2c2e; border:1px solid #3e3e40; border-radius:4px; padding:3px 8px; color:#e8e8e8;"><strong>Name:</strong> ' + (data.passengerName || 'N/A') + '</span>';
            html += '<span style="background:#2c2c2e; border:1px solid #3e3e40; border-radius:4px; padding:3px 8px; color:#e8e8e8;"><strong>Age:</strong> ' + (data.age || 'N/A') + '</span>';
            html += '<span style="background:#2c2c2e; border:1px solid #3e3e40; border-radius:4px; padding:3px 8px; color:#e8e8e8;"><strong>Gender:</strong> ' + (data.gender || 'N/A') + '</span>';
            html += '<span style="background:linear-gradient(135deg, #f5a623, #e8720c); color:white; border-radius:4px; padding:3px 8px; font-weight:bold;"><strong>Seat:</strong> ' + (data.seatNumber || 'N/A') + ' | Coach: ' + (data.coachNo || 'N/A') + '</span>';
            html += '</div></div>';
            html += '<div class="ticket-detail"><span class="detail-label">Fare:</span> Rs. ' + (data.fare || '0') + '</div>';
            
            document.getElementById('viewContent').innerHTML = html;
        })
        .catch(error => {
            console.error('viewBooking error:', error);
            document.getElementById('viewContent').innerHTML = '<div style="color:red;">Error loading ticket details</div>';
        });
}

function downloadTicket(pnr) {
    document.getElementById('viewModal').style.display = 'block';
    document.getElementById('viewContent').innerHTML = '<div style="text-align:center; padding:20px;">Loading ticket...</div>';
    
    fetch('UserServlet?action=getTicketDetails&pnr=' + encodeURIComponent(pnr))
        .then(response => response.json())
        .then(data => {
            if(data.error) {
                document.getElementById('viewContent').innerHTML = '<div style="color:red;">' + data.error + '</div>';
                return;
            }
            
            let html = '<div style="border:2px solid #f5a623; border-radius:10px; padding:20px;">';
            html += '<div style="text-align:center; border-bottom:2px solid #e8720c; padding-bottom:12px; margin-bottom:15px;">';
            html += '<h3 style="color:#f5a623; margin-bottom:4px;">🚂 Train Reservation Ticket</h3>';
            html += '<span style="font-size:22px; font-weight:bold; color:#e8720c; letter-spacing:2px;">' + (data.pnr || 'N/A') + '</span>';
            html += '</div>';
            html += '<div style="display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-bottom:15px;">';
            html += '<div class="ticket-detail"><span class="detail-label">Train:</span> ' + (data.trainName || 'N/A') + '</div>';
            html += '<div class="ticket-detail"><span class="detail-label">Journey Date:</span> ' + (data.journeyDate || 'N/A') + '</div>';
            html += '<div class="ticket-detail"><span class="detail-label">Status:</span> ' + (data.status || 'N/A') + '</div>';
            html += '</div>';
            html += '<h4 style="margin-bottom:10px; color:#f5a623;">Passenger Details</h4>';
            html += '<div class="passenger-block" style="background:#272729; border:1px solid #3e3e40; border-radius:8px; padding:12px; margin-bottom:10px;">';
            html += '<div class="p-row" style="display:flex; gap:8px; flex-wrap:wrap;">';
            html += '<span style="background:#2c2c2e; border:1px solid #3e3e40; border-radius:4px; padding:3px 8px; color:#e8e8e8;"><strong>Name:</strong> ' + (data.passengerName || 'N/A') + '</span>';
            html += '<span style="background:#2c2c2e; border:1px solid #3e3e40; border-radius:4px; padding:3px 8px; color:#e8e8e8;"><strong>Age:</strong> ' + (data.age || 'N/A') + '</span>';
            html += '<span style="background:#2c2c2e; border:1px solid #3e3e40; border-radius:4px; padding:3px 8px; color:#e8e8e8;"><strong>Gender:</strong> ' + (data.gender || 'N/A') + '</span>';
            html += '<span style="background:linear-gradient(135deg, #f5a623, #e8720c); color:white; border-radius:4px; padding:3px 8px; font-weight:bold;"><strong>Seat:</strong> ' + (data.seatNumber || 'N/A') + ' | Coach: ' + (data.coachNo || 'N/A') + '</span>';
            html += '</div></div>';
            html += '<div class="ticket-detail"><span class="detail-label">Fare:</span> Rs. ' + (data.fare || '0') + '</div>';
            html += '<div style="margin-top:15px; display:flex; gap:10px;" class="no-print">';
            html += '<button onclick="window.print()" style="background:#5cb87a; color:white; border:none; padding:8px 20px; border-radius:5px; cursor:pointer; flex:1;">🖨️ Print Ticket</button>';
            html += '<button onclick="closeViewModal()" style="background:#3e3e40; color:white; border:none; padding:8px 20px; border-radius:5px; cursor:pointer; flex:1;">Close</button>';
            html += '</div></div>';
            
            document.getElementById('viewContent').innerHTML = html;
        })
        .catch(error => {
            console.error('downloadTicket error:', error);
            document.getElementById('viewContent').innerHTML = '<div style="color:red;">Error loading ticket</div>';
        });
}

    function confirmCancel(bookingId) {
        document.getElementById('cancelBookingId').value = bookingId;
        document.getElementById('cancelModal').style.display = 'block';
    }

    function closeCancelModal() {
        document.getElementById('cancelModal').style.display = 'none';
    }

    function cancelBooking() {
        let bookingId = document.getElementById('cancelBookingId').value;

        fetch('UserServlet?action=cancelBookingJSON', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'bookingId=' + bookingId
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) {
                alert('Booking cancelled successfully');
                location.reload();
            } else {
                alert('Cancellation failed');
            }
        });
    }

    function closeViewModal() {
        document.getElementById('viewModal').style.display = 'none';
    }

    window.onclick = function(event) {
        if (event.target === document.getElementById('viewModal'))   closeViewModal();
        if (event.target === document.getElementById('cancelModal')) closeCancelModal();
    };
    </script>
</body>
</html>