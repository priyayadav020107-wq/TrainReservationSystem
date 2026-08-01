<%@ page import="java.util.List, model.TrainPojo" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if(adminId == null) response.sendRedirect("AdminLogin.jsp");
    String adminName = (String) session.getAttribute("adminName");
    
    List<TrainPojo> trains = (List<TrainPojo>) request.getAttribute("trains");
    if(trains == null) {
        TrainPojo pojo = new TrainPojo();
        trains = pojo.getAllTrains();
    }
    
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Trains</title>
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

        .add-form { 
            background: rgba(44,44,46,0.92); 
            padding: 20px; 
            border-radius: 12px; 
            margin: 0 20px 30px 20px;
            border: 1px solid #3e3e40;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
        }
        .add-form h3 { color: #f5a623; margin-bottom: 15px; }
        .form-group { display: inline-block; margin-right: 15px; margin-bottom: 10px; }
        input, select { 
            padding: 8px; 
            border: 1px solid #3e3e40; 
            border-radius: 5px; 
            width: 150px; 
            background: #1a1a1c;
            color: #f0f0f0;
        }
        input::placeholder { color: #9a9a9a; }
        input:focus, select:focus { outline: none; border-color: #f5a623; }
        select option { background: #1a1a1c; color: #f0f0f0; }
        button { 
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white; 
            padding: 8px 20px; 
            border: none; 
            border-radius: 5px; 
            cursor: pointer;
            transition: opacity 0.3s;
        }
        button:hover { opacity: 0.85; }
        
        table { 
            width: calc(100% - 40px); 
            margin: 0 20px;
            background: rgba(44,44,46,0.92); 
            border-radius: 12px; 
            overflow: hidden;
            border-collapse: collapse;
            border: 1px solid #3e3e40;
        }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #3e3e40; color: #f0f0f0; }
        th { background: #1a1a1c; color: #f5a623; }
        tr:hover td { background: rgba(54,54,56,0.5); }
        .edit-btn { 
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white; 
            padding: 5px 10px; 
            border: none; 
            border-radius: 3px; 
            cursor: pointer;
            font-size: 12px;
            transition: opacity 0.3s;
        }
        .edit-btn:hover { opacity: 0.85; }
        .delete-btn { 
            background: linear-gradient(135deg, #e8720c, #c1121f);
            color: white; 
            padding: 5px 10px; 
            border: none; 
            border-radius: 3px; 
            cursor: pointer;
            font-size: 12px;
            transition: opacity 0.3s;
        }
        .delete-btn:hover { opacity: 0.85; }
        .view-seats-btn { 
            background: linear-gradient(135deg, #f5a623, #ff6b35);
            color: white; 
            padding: 5px 10px; 
            border: none; 
            border-radius: 3px; 
            cursor: pointer;
            font-size: 12px;
            transition: opacity 0.3s;
        }
        .view-seats-btn:hover { opacity: 0.85; }
        .history-btn { 
            background: #363638; 
            color: #9a9a9a; 
            padding: 5px 10px; 
            border: 1px solid #3e3e40; 
            border-radius: 3px; 
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s;
        }
        .history-btn:hover { background: #f5a623; color: white; border-color: #f5a623; }
        
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
        
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.7); }
        .modal-content { 
            background: #272729; 
            margin: 10% auto; 
            padding: 25px; 
            width: 400px; 
            border-radius: 12px;
            border: 1px solid #3e3e40;
            box-shadow: 0 5px 20px rgba(0,0,0,0.5);
        }
        .modal-content h3 { color: #f5a623; margin-bottom: 15px; }
        .modal-content label { color: #9a9a9a; display: block; margin-top: 10px; margin-bottom: 3px; font-size: 13px; }
        .modal-content input, .modal-content select { width: 95%; padding: 10px; margin: 5px 0; }
        .modal-content button { background: linear-gradient(135deg, #f5a623, #e8720c); width: 95%; margin-top: 15px; padding: 10px; }
        .close { float: right; font-size: 24px; cursor: pointer; color: #9a9a9a; }
        .close:hover { color: #f0f0f0; }
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
            <a href="AdminServlet?action=dashboard" class="menu-item ">
                <i class="fas fa-tachometer-alt menu-icon"></i>
                <span>Dashboard</span>
            </a>
            <a href="AdminServlet?action=manageTrains" class="menu-item active">
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
    
    <div class="main-content">
        <div class="top-navbar">
            <h1 class="page-title">Train Management</h1>
            <div class="user-info">
                <span class="user-name">Welcome, <%= adminName %></span>
                <form method="post" action="AdminServlet">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </div>
        
        <% if(message != null) { %>
            <div class="message"><%= message %></div>
        <% } %>
        <% if(error != null) { %>
            <div class="error"><%= error %></div>
        <% } %>
        
        <!-- Add Train Form -->
        <div class="add-form">
            <h3>Add New Train</h3>
            <form method="post" action="AdminServlet">
                <input type="hidden" name="action" value="addTrain">
                <div class="form-group"><input type="text" name="trainNo" placeholder="Train Number" required></div>
                <div class="form-group"><input type="text" name="trainName" placeholder="Train Name" required></div>
                <div class="form-group">
                    <select name="sourceStation" required>
                        <option value="">Source</option><option value="1">Delhi</option><option value="2">Ahmedabad</option>
                        <option value="3">Mumbai</option><option value="5">Kanpur</option><option value="6">Lucknow</option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="destinationStation" required>
                        <option value="">Destination</option><option value="1">Delhi</option><option value="2">Ahmedabad</option>
                        <option value="3">Mumbai</option><option value="5">Kanpur</option><option value="6">Lucknow</option>
                    </select>
                </div>
                <div class="form-group"><input type="time" name="departureTime" required></div>
                <div class="form-group"><input type="time" name="arrivalTime" required></div>
                <div class="form-group"><input type="number" name="totalSeats" placeholder="Seats" required></div>
                <div class="form-group"><input type="number" step="0.01" name="fare" placeholder="Fare" required></div>
                <button type="submit">Add Train</button>
            </form>
        </div>
        
        <!-- Trains Table -->
        <table>
            <thead>
                <tr><th>ID</th><th>Train No</th><th>Name</th><th>Departure</th><th>Arrival</th><th>Seats</th><th>Fare</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
                <% for(TrainPojo t : trains) { %>
                <tr>
                    <td><%= t.getTrainId() %></td>
                    <td><%= t.getTrainNo() %></td>
                    <td><%= t.getTrainName() %></td>
                    <td><%= t.getDepartureTime() %></td>
                    <td><%= t.getArrivalTime() %></td>
                    <td><%= t.getAvailableSeats() %>/<%= t.getTotalSeats() %></td>
                    <td>Rs. <%= t.getFare() %></td>
                    <td><%= t.getStatus() %></td>
                    <td class="actions-cell">
                        <button class="edit-btn" onclick="openUpdateModal(<%= t.getTrainId() %>, '<%= t.getTrainNo() %>', '<%= t.getTrainName() %>', <%= t.getFare() %>, '<%= t.getStatus() %>')">Edit</button>
                        <form method="post" action="AdminServlet" style="display:inline;">
                            <input type="hidden" name="action" value="removeTrain">
                            <input type="hidden" name="trainId" value="<%= t.getTrainId() %>">
                            <button type="submit" class="delete-btn" onclick="return confirm('Deactivate this train?')">Deactivate</button>
                        </form>
                        <button type="button" class="view-seats-btn" onclick="viewSeats(<%= t.getTrainId() %>)">View Seats</button>
                        <!-- NEW HISTORY BUTTON - ADDED WITHOUT DISTURBING EXISTING CODE -->
                        <button type="button" class="history-btn" onclick="viewHistory()">History</button>  
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    
    <!-- Update Modal -->
    <div id="updateModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h3>Update Train</h3>
            <form method="post" action="AdminServlet">
                <input type="hidden" name="action" value="updateTrain">
                <input type="hidden" name="trainId" id="updateTrainId">
                <label>Train No:</label><input type="text" id="updateTrainNo" disabled style="background:#1a1a1c; opacity:0.7;">
                <label>Train Name:</label><input type="text" id="updateTrainName" disabled style="background:#1a1a1c; opacity:0.7;">
                <label>Fare (Rs.):</label><input type="number" step="0.01" name="fare" id="updateFare" required>
                <label>Status:</label>
                <select name="status" id="updateStatus">
                    <option value="ACTIVE">ACTIVE</option>
                    <option value="INACTIVE">INACTIVE</option>
                </select>
                <button type="submit">Update Train</button>
            </form>
        </div>
    </div>
    
    <script>
        function openUpdateModal(id, no, name, fare, status) {
            document.getElementById("updateTrainId").value = id;
            document.getElementById("updateTrainNo").value = no;
            document.getElementById("updateTrainName").value = name;
            document.getElementById("updateFare").value = fare;
            document.getElementById("updateStatus").value = status;
            document.getElementById("updateModal").style.display = "block";
        }
        
        function closeModal() {
            document.getElementById("updateModal").style.display = "none";
        }
        
        // ✅ CHANGED: no longer hardcodes tomorrow's date on the client side.
        // Just passes trainId - AdminServlet.viewSeats() now decides the
        // default date (that train's most recent booking's journey date,
        // falling back to tomorrow only if the train has no bookings yet).
        function viewSeats(trainId) {
            window.location.href = "AdminServlet?action=viewSeats&trainId=" + trainId;
        }
        
        // NEW VIEW HISTORY FUNCTION
        function viewHistory() {
            window.location.href = "AdminServlet?action=trainHistoryAll";
        }
        
        window.onclick = function(event) {
            if(event.target == document.getElementById("updateModal")) {
                closeModal();
            }
        }
    </script>
</body>
</html>