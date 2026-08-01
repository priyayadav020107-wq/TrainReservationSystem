<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.TrainPojo, model.UserPojo, java.util.List, java.util.Map, java.util.ArrayList" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    
    if(userId == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    UserPojo userPojo = new UserPojo();
    List<Map<String, Object>> stations = userPojo.getStations();
    
    List<TrainPojo> searchResults = (List<TrainPojo>) request.getAttribute("trains");
    String journeyDate = (String) request.getAttribute("journeyDate");
    String sourceStationParam = request.getParameter("sourceStation");
    String destinationStationParam = request.getParameter("destinationStation");
    
    TrainPojo allTrainsPojo = new TrainPojo();
    List<TrainPojo> allTrains = allTrainsPojo.getAllTrains();
    List<TrainPojo> mainTrains = new ArrayList<>();
    for(TrainPojo t : allTrains) {
        if("ACTIVE".equals(t.getStatus())) {
            mainTrains.add(t);
        }
    }
    
    String fromStationName = "";
    String toStationName = "";
    for(Map<String, Object> s : stations) {
        if(String.valueOf(s.get("id")).equals(sourceStationParam)) {
            fromStationName = (String) s.get("name");
        }
        if(String.valueOf(s.get("id")).equals(destinationStationParam)) {
            toStationName = (String) s.get("name");
        }
    }
    
    boolean searchPerformed = (sourceStationParam != null && !sourceStationParam.isEmpty() && 
                               destinationStationParam != null && !destinationStationParam.isEmpty());
    
    String searchMessage = (String) request.getAttribute("searchMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Trains</title>
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
        
        .search-card {
            background: rgba(44,44,46,0.92);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
        }
        .search-card h3 { color: #f0f0f0; margin-bottom: 15px; }
        .search-form { display: flex; gap: 15px; flex-wrap: wrap; align-items: flex-end; }
        .form-group { display: flex; flex-direction: column; gap: 5px; }
        .form-group label { font-size: 12px; color: #9a9a9a; }
        .form-group select, .form-group input { 
            padding: 8px; 
            border: 1px solid #3e3e40; 
            border-radius: 5px; 
            width: 160px; 
            background: #272729;
            color: #e8e8e8;
        }
        .search-btn {
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .search-btn:hover { opacity: 0.85; }
        
        .search-result-section {
            background: rgba(44,44,46,0.92);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 25px;
            border-left: 4px solid #f5a623;
            border: 1px solid #3e3e40;
        }
        .search-result-section h4 {
            margin-bottom: 10px;
            color: #f0f0f0;
        }
        .search-result-section p { color: #9a9a9a; }
        .search-result-table {
            width: 100%;
            border-collapse: collapse;
            background: #272729;
            border-radius: 8px;
            overflow: hidden;
            margin-top: 10px;
        }
        .search-result-table th, .search-result-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #3e3e40;
            font-size: 13px;
            color: #e8e8e8;
        }
        .search-result-table th {
            background: linear-gradient(135deg, #e8720c, #c1121f);
            color: white;
        }
        
        .main-table-section {
            margin-top: 10px;
        }
        .main-table-section h3 {
            margin-bottom: 15px;
            color: #f0f0f0;
        }
        
        table { width: 100%; border-collapse: collapse; background: rgba(44,44,46,0.92); border-radius: 10px; overflow: hidden; border: 1px solid #3e3e40; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #3e3e40; font-size: 14px; color: #e8e8e8; }
        th { background: #272729; color: #f5a623; }
        .book-btn {
            background: #5cb87a;
            color: white;
            border: none;
            padding: 5px 15px;
            border-radius: 4px;
            cursor: pointer;
        }
        .book-btn:hover { opacity: 0.85; }
        
        .success-message {
            background: #1e3020;
            color: #5cb87a;
            border-left: 4px solid #5cb87a;
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .error-message {
            background: #2e1a1a;
            color: #e8720c;
            border-left: 4px solid #c1121f;
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-size: 14px;
        }
        
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
            margin: 5% auto;
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
            border-bottom: 2px solid #f5a623;
            padding-bottom: 10px;
        }
        .modal-header h3 { color: #f0f0f0; }
        .close { font-size: 24px; cursor: pointer; color: #9a9a9a; }
        .close:hover { color: #f5a623; }
        .form-group-modal { margin-bottom: 15px; }
        .form-group-modal label { font-weight: bold; display: block; margin-bottom: 5px; font-size: 13px; color: #9a9a9a; }
        .form-group-modal input, .form-group-modal select { 
            width: 100%; 
            padding: 8px; 
            border: 1px solid #3e3e40; 
            border-radius: 4px; 
            background: #272729;
            color: #e8e8e8;
        }
        .modal-btn { 
            background: linear-gradient(135deg, #f5a623, #e8720c); 
            color: white; 
            padding: 10px; 
            border: none; 
            border-radius: 5px; 
            cursor: pointer; 
            width: 100%; 
        }
        .modal-btn:hover { opacity: 0.85; }
        .payment-option { margin: 10px 0; color: #e8e8e8; }
        .payment-option input { margin-right: 10px; }
        .ticket-preview { background: #272729; padding: 12px; border-radius: 6px; margin-bottom: 15px; color: #e8e8e8; }

        /* ✅ NEW: waitlist notice box, styled to match error/success message boxes */
        .waitlist-notice {
            background: #2e2a1a;
            color: #f5a623;
            border-left: 4px solid #f5a623;
            padding: 10px 12px;
            border-radius: 5px;
            font-size: 13px;
            margin-bottom: 12px;
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
            <a href="SearchTrain.jsp" class="menu-item active"><span class="menu-icon">🔍</span><span>Search Trains</span></a>
            <a href="MyBookings.jsp" class="menu-item"><span class="menu-icon">📋</span><span>My Bookings</span></a>
            <a href="Profile.jsp" class="menu-item"><span class="menu-icon">👤</span><span>Profile</span></a>
        </div>
    </div>
    
    <div class="main-content">
        <div class="search-card">
            <h3>Search Trains</h3>
            <form method="get" action="UserServlet" class="search-form" id="searchForm">
                <input type="hidden" name="action" value="searchTrain">
                <div class="form-group">
                    <label>From Station</label>
                    <select name="sourceStation" id="sourceStation">
                        <option value="">Select</option>
                        <% for(Map<String, Object> s : stations) { %>
                            <option value="<%= s.get("id") %>"><%= s.get("name") %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>To Station</label>
                    <select name="destinationStation" id="destinationStation">
                        <option value="">Select</option>
                        <% for(Map<String, Object> s : stations) { %>
                            <option value="<%= s.get("id") %>"><%= s.get("name") %></option>
                        <% } %>
                    </select>
                </div>
                <button type="submit" class="search-btn">Search Trains</button>
            </form>
        </div>
        
        <% if(searchMessage != null && !searchMessage.isEmpty()) { 
            String msgClass = searchMessage.contains("✅") ? "success-message" : "error-message";
        %>
            <div class="<%= msgClass %>"><%= searchMessage %></div>
        <% } %>
        
        <!-- ========== SEARCH RESULTS SECTION ========== -->
        <% if(searchPerformed) { %>
            <div class="search-result-section">
                <h4>🔍 Search Results: <%= fromStationName %> → <%= toStationName %></h4>
                <% if(searchResults != null && !searchResults.isEmpty()) { %>
                    <p>Found <%= searchResults.size() %> train(s) for this route on <%= journeyDate %></p>
                    <table class="search-result-table">
                        <thead>
                            <tr>
                                <th>Train No</th>
                                <th>Train Name</th>
                                <th>Departure</th>
                                <th>Arrival</th>
                                <th>Seats</th>
                                <th>Fare</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(TrainPojo train : searchResults) { %>
                                <tr>
                                    <td><%= train.getTrainNo() %></td>
                                    <td><%= train.getTrainName() %></td>
                                    <td><%= train.getDepartureTime() %></td>
                                    <td><%= train.getArrivalTime() %></td>
                                    <td><%= train.getAvailableSeats() %></td>
                                    <td>Rs. <%= train.getFare() %></td>
                                    <td><button class="book-btn" onclick="openBookingModal(<%= train.getTrainId() %>, '<%= train.getTrainName() %>', <%= train.getFare() %>)">Book Ticket</button></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <p>No trains found for this route. Please try different stations.</p>
                <% } %>
            </div>
        <% } %>
        
        <!-- ========== MAIN TRAINS TABLE ========== -->
        <div class="main-table-section">
            <h3>🚂 All Available Trains</h3>
            <table>
                <thead>
                    <tr>
                        <th>Train No</th>
                        <th>Train Name</th>
                        <th>Departure</th>
                        <th>Arrival</th>
                        <th>Seats</th>
                        <th>Fare</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(TrainPojo train : mainTrains) { %>
                        <tr>
                            <td><%= train.getTrainNo() %></td>
                            <td><%= train.getTrainName() %></td>
                            <td><%= train.getDepartureTime() %></td>
                            <td><%= train.getArrivalTime() %></td>
                            <td><%= train.getAvailableSeats() %></td>
                            <td>Rs. <%= train.getFare() %></td>
                            <td><button class="book-btn" onclick="openBookingModal(<%= train.getTrainId() %>, '<%= train.getTrainName() %>', <%= train.getFare() %>)">Book Ticket</button></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Booking Modal (Single Passenger) -->
    <div id="bookingModal" class="modal">
        <div class="modal-content" style="width: 450px;">
            <div class="modal-header">
                <h3>Book Ticket</h3>
                <span class="close" onclick="closeBookingModal()">&times;</span>
            </div>
            <div>
                <div class="form-group-modal">
                    <label>Journey Date</label>
                    <input type="date" id="modalJourneyDate" required>
                </div>
                
                <div class="form-group-modal">
                    <label>Passenger Name</label>
                    <input type="text" id="modalPassengerName" required>
                </div>
                <div class="form-group-modal">
                    <label>Age</label>
                    <input type="number" id="modalAge" required>
                </div>
                <div class="form-group-modal">
                    <label>Gender</label>
                    <select id="modalGender">
                        <option value="MALE">Male</option>
                        <option value="FEMALE">Female</option>
                        <option value="OTHER">Other</option>
                    </select>
                </div>
                <div class="form-group-modal">
                    <label>Seat Number</label>
                    <select id="modalSeatNumber" required>
                        <option value="">Select Seat</option>
                    </select>
                </div>

                <!-- ✅ NEW: shown only when no seats are available for the selected date -->
                <div class="form-group-modal" id="waitlistSection" style="display:none;">
                    <div class="waitlist-notice">
                        No seats available for this date. You can join the waitlist instead —
                        if a seat opens up (via a cancellation), it will be automatically
                        assigned to you in the order you joined.
                    </div>
                </div>
                
                <button class="modal-btn" onclick="proceedToPaymentFromModal()" id="proceedBtn">Proceed To Payment</button>
                <button class="modal-btn" onclick="joinWaitlistFromModal()" id="waitlistBtn"
                        style="display:none; margin-top:10px; background:linear-gradient(135deg, #9a9a9a, #6a6a6a);">Join Waitlist</button>
            </div>
        </div>
    </div>
    
    <!-- Payment Modal -->
    <div id="paymentModal" class="modal">
        <div class="modal-content">
            <div class="modal-header"><h3>Payment Details</h3><span class="close" onclick="closePaymentModal()">&times;</span></div>
            <div id="paymentInfo">
                <div class="ticket-preview">
                    <p><strong>Train:</strong> <span id="previewTrainName"></span></p>
                    <p><strong>Journey Date:</strong> <span id="previewJourneyDate"></span></p>
                    <p><strong>Amount:</strong> Rs. <span id="previewAmount"></span></p>
                </div>
                <div class="payment-option"><input type="radio" name="paymentMethod" value="UPI" checked> UPI</div>
                <div class="payment-option"><input type="radio" name="paymentMethod" value="CARD"> Card</div>
                <div class="payment-option"><input type="radio" name="paymentMethod" value="NETBANKING"> Net Banking</div>
                <button class="modal-btn" onclick="processPayment()" id="payBtn">Pay Now</button>
            </div>
        </div>
    </div>
    
    <!-- Success Modal -->
    <div id="successModal" class="modal">
        <div class="modal-content" style="text-align:center;">
            <div class="modal-header"><h3>Booking Successful</h3><span class="close" onclick="closeSuccessModal()">&times;</span></div>
            <div style="padding:20px;">
                <p style="color:#5cb87a; font-size:18px;">Payment Successful</p>
                <p style="color:#e8e8e8;"><strong>PNR:</strong> <span id="successPNR"></span></p>
                <p style="color:#e8e8e8;"><strong>Seat:</strong> <span id="successSeat"></span></p>
                <button onclick="window.location.href='MyBookings.jsp'" style="background:#5cb87a; color:white; border:none; padding:8px 16px; border-radius:5px; margin-top:15px; cursor:pointer;">View Booking</button>
                <button onclick="window.location.href='UserDashboard.jsp'" style="background:linear-gradient(135deg, #f5a623, #e8720c); color:white; border:none; padding:8px 16px; border-radius:5px; margin-top:15px; margin-left:10px; cursor:pointer;">Go to Dashboard</button>
            </div>
        </div>
    </div>
    
    <script>
    let selectedTrainId, selectedTrainName, selectedFare;
    
    function getTomorrowDate() {
        let tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        let year = tomorrow.getFullYear();
        let month = String(tomorrow.getMonth() + 1).padStart(2, '0');
        let day = String(tomorrow.getDate()).padStart(2, '0');
        return year + '-' + month + '-' + day;
    }
    
    function openBookingModal(trainId, trainName, fare) {
        selectedTrainId = trainId;
        selectedTrainName = trainName;
        selectedFare = fare;
        
        document.getElementById('modalJourneyDate').value = getTomorrowDate();
        document.getElementById('modalPassengerName').value = '';
        document.getElementById('modalAge').value = '';
        document.getElementById('modalGender').value = 'MALE';

        // ✅ NEW: reset waitlist UI state each time the modal opens
        document.getElementById('waitlistSection').style.display = 'none';
        document.getElementById('proceedBtn').style.display = 'block';
        document.getElementById('waitlistBtn').style.display = 'none';
        
        let journeyDate = document.getElementById('modalJourneyDate').value;
        loadAvailableSeats(trainId, journeyDate);
        
        document.getElementById('bookingModal').style.display = 'block';
    }
    
    function loadAvailableSeats(trainId, journeyDate) {
        let seatSelect = document.getElementById('modalSeatNumber');
        seatSelect.innerHTML = '<option value="">Loading seats...</option>';
        
        fetch('UserServlet?action=getAvailableSeats&trainId=' + trainId + '&journeyDate=' + journeyDate)
            .then(response => response.json())
            .then(data => {
                seatSelect.innerHTML = '<option value="">Select Seat</option>';
                if(data && data.length > 0) {
                    data.forEach(seat => {
                        let option = document.createElement('option');
                        option.value = seat.seatId;
                        option.text = seat.seatNumber + ' (Coach: ' + seat.coachNo + ', Type: ' + seat.seatType + ')';
                        seatSelect.appendChild(option);
                    });
                    // ✅ NEW: seats available - normal booking flow
                    document.getElementById('waitlistSection').style.display = 'none';
                    document.getElementById('proceedBtn').style.display = 'block';
                    document.getElementById('waitlistBtn').style.display = 'none';
                    seatSelect.disabled = false;
                } else {
                    seatSelect.innerHTML = '<option value="">No seats available</option>';
                    // ✅ NEW: train full for this date - offer waitlist instead
                    document.getElementById('waitlistSection').style.display = 'block';
                    document.getElementById('proceedBtn').style.display = 'none';
                    document.getElementById('waitlistBtn').style.display = 'block';
                    seatSelect.disabled = true;
                }
            })
            .catch(error => {
                seatSelect.innerHTML = '<option value="">Error loading seats</option>';
            });
    }
    
    // Reload seats when journey date changes
    document.getElementById('modalJourneyDate').addEventListener('change', function() {
        let journeyDate = this.value;
        if(journeyDate && selectedTrainId) {
            loadAvailableSeats(selectedTrainId, journeyDate);
        }
    });
    
    function closeBookingModal() {
        document.getElementById('bookingModal').style.display = 'none';
    }
    
    function proceedToPaymentFromModal() {
        let journeyDate = document.getElementById('modalJourneyDate').value;
        let passengerName = document.getElementById('modalPassengerName').value.trim();
        let age = document.getElementById('modalAge').value;
        let gender = document.getElementById('modalGender').value;
        let seatSelect = document.getElementById('modalSeatNumber');
        let seatId = seatSelect.value;
        let seatText = seatSelect.options[seatSelect.selectedIndex]?.text || '';
        
        if(!journeyDate) {
            alert('Please select journey date');
            return;
        }
        if(!passengerName) {
            alert('Please enter passenger name');
            return;
        }
        if(!age || age < 1 || age > 120) {
            alert('Please enter valid age (1-120)');
            return;
        }
        if(!seatId) {
            alert('Please select a seat');
            return;
        }
        
        let seatNumber = seatText.split(' ')[0];
        
        sessionStorage.setItem('passengerName', passengerName);
        sessionStorage.setItem('age', age);
        sessionStorage.setItem('gender', gender);
        sessionStorage.setItem('seatNumber', seatNumber);
        sessionStorage.setItem('seatId', seatId);
        sessionStorage.setItem('trainId', selectedTrainId);
        sessionStorage.setItem('journeyDate', journeyDate);
        sessionStorage.setItem('fare', selectedFare);
        
        document.getElementById('previewTrainName').innerText = selectedTrainName;
        document.getElementById('previewJourneyDate').innerText = journeyDate;
        document.getElementById('previewAmount').innerText = selectedFare;
        
        closeBookingModal();
        document.getElementById('paymentModal').style.display = 'block';
    }

    // ✅ NEW FUNCTION - joins the waitlist when the train is full
    function joinWaitlistFromModal() {
        let journeyDate = document.getElementById('modalJourneyDate').value;
        let passengerName = document.getElementById('modalPassengerName').value.trim();
        let age = document.getElementById('modalAge').value;
        let gender = document.getElementById('modalGender').value;

        if(!journeyDate) {
            alert('Please select journey date');
            return;
        }
        if(!passengerName) {
            alert('Please enter passenger name');
            return;
        }
        if(!age || age < 1 || age > 120) {
            alert('Please enter valid age (1-120)');
            return;
        }

        let waitlistBtn = document.getElementById('waitlistBtn');
        waitlistBtn.innerHTML = 'Joining Waitlist...';
        waitlistBtn.disabled = true;

        fetch('UserServlet?action=joinWaitlist', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'trainId=' + selectedTrainId + '&journeyDate=' + encodeURIComponent(journeyDate) +
                  '&passengerName=' + encodeURIComponent(passengerName) +
                  '&age=' + age + '&gender=' + gender
        })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
                closeBookingModal();
                alert('You have been added to the waitlist!\nPNR: ' + data.pnr + '\nYou will be automatically confirmed if a seat becomes available.');
                window.location.href = 'MyBookings.jsp';
            } else {
                alert('Failed to join waitlist: ' + data.message);
            }
            waitlistBtn.innerHTML = 'Join Waitlist';
            waitlistBtn.disabled = false;
        })
        .catch(error => {
            alert('Error joining waitlist: ' + error);
            waitlistBtn.innerHTML = 'Join Waitlist';
            waitlistBtn.disabled = false;
        });
    }
    
    function closePaymentModal() {
        document.getElementById('paymentModal').style.display = 'none';
    }
    
    function processPayment() {
        let paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
        let payBtn = document.getElementById('payBtn');
        payBtn.innerHTML = 'Processing...';
        payBtn.disabled = true;
        
        let passengerName = sessionStorage.getItem('passengerName');
        let age = sessionStorage.getItem('age');
        let gender = sessionStorage.getItem('gender');
        let seatId = sessionStorage.getItem('seatId');
        let trainId = sessionStorage.getItem('trainId');
        let journeyDate = sessionStorage.getItem('journeyDate');
        let fare = sessionStorage.getItem('fare');
        
        fetch('UserServlet?action=confirmBooking', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'trainId=' + trainId + '&journeyDate=' + encodeURIComponent(journeyDate) + 
                  '&passengerName=' + encodeURIComponent(passengerName) + 
                  '&age=' + age + '&gender=' + gender + 
                  '&seatId=' + seatId +
                  '&passengerCount=1&fare=' + fare + '&paymentMethod=' + paymentMethod
        })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
                document.getElementById('paymentModal').style.display = 'none';
                document.getElementById('successPNR').innerText = data.pnr;
                document.getElementById('successSeat').innerText = sessionStorage.getItem('seatNumber');
                document.getElementById('successModal').style.display = 'block';
            } else {
                alert('Booking failed: ' + data.message);
            }
            payBtn.innerHTML = 'Pay Now';
            payBtn.disabled = false;
        })
        .catch(error => {
            alert('Booking failed: ' + error);
            payBtn.innerHTML = 'Pay Now';
            payBtn.disabled = false;
        });
    }
    
    function closeSuccessModal() {
        document.getElementById('successModal').style.display = 'none';
        window.location.href = 'MyBookings.jsp';
    }
    
    window.onclick = function(event) {
        if(event.target == document.getElementById('bookingModal')) closeBookingModal();
        if(event.target == document.getElementById('paymentModal')) closePaymentModal();
        if(event.target == document.getElementById('successModal')) closeSuccessModal();
    }
    </script>
</body>
</html>