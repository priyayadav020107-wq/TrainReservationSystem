<%@ page import="java.util.List, model.UserPojo" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if(adminId == null) response.sendRedirect("AdminLogin.jsp");
    String adminName = (String) session.getAttribute("adminName");
    
    List<UserPojo> users = (List<UserPojo>) request.getAttribute("users");

    // ✅ NEW: pagination attributes
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Users - Admin</title>
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

        .user-table {
            width: calc(100% - 40px);
            margin: 0 20px;
            background: rgba(44,44,46,0.92);
            border-radius: 12px;
            overflow: hidden;
            border-collapse: collapse;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
        }
        .user-table th, .user-table td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #3e3e40;
            color: #f0f0f0;
        }
        .user-table th {
            background: #1a1a1c;
            color: #f5a623;
            font-weight: 600;
        }
        .user-table tr:hover td {
            background: rgba(54,54,56,0.5);
        }
        .status-active {
            color: #5cb87a;
            font-weight: bold;
        }
        .status-inactive {
            color: #e8720c;
            font-weight: bold;
        }
        .btn-view {
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white;
            padding: 6px 14px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 5px;
            font-size: 12px;
            transition: opacity 0.3s;
        }
        .btn-view:hover { opacity: 0.85; }
        .btn-deactivate {
            background: linear-gradient(135deg, #e8720c, #c1121f);
            color: white;
            padding: 6px 14px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: opacity 0.3s;
        }
        .btn-deactivate:hover { opacity: 0.85; }
        .btn-activate {
            background: linear-gradient(135deg, #5cb87a, #28a745);
            color: white;
            padding: 6px 14px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: opacity 0.3s;
        }
        .btn-activate:hover { opacity: 0.85; }
        .message {
            background: #1e3020;
            color: #5cb87a;
            padding: 12px;
            border-radius: 8px;
            margin: 0 20px 20px 20px;
            border: 1px solid #2d4a33;
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
            width: 550px;
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
        .modal-header h3 {
            color: #f0f0f0;
        }
        .close {
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            color: #9a9a9a;
        }
        .close:hover {
            color: #f0f0f0;
        }
        .history-table {
            width: 100%;
            border-collapse: collapse;
        }
        .history-table th, .history-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #3e3e40;
            color: #f0f0f0;
        }
        .history-table th {
            background: #1a1a1c;
            color: #f5a623;
        }
        .history-table tr:hover td { background: rgba(54,54,56,0.5); }
        .no-data {
            text-align: center;
            padding: 20px;
            color: #9a9a9a;
        }

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
            <a href="AdminServlet?action=bookings" class="menu-item ">
                <i class="fas fa-ticket-alt menu-icon"></i>
                <span>Bookings</span>
            </a>
            <a href="AdminServlet?action=users" class="menu-item active">
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
            <h1 class="page-title">User Management</h1>
            <form method="post" action="AdminServlet">
                <input type="hidden" name="action" value="logout">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
        
        <% if(request.getAttribute("message") != null) { %>
            <div class="message"><%= request.getAttribute("message") %></div>
        <% } %>
        
        <table class="user-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Status</th>
                    <th>Registered On</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if(users != null && !users.isEmpty()) {
                    for(UserPojo u : users) { 
                        String currentStatus = u.getIsActive();
                        boolean isActive = "Active".equals(currentStatus);
                    %>
                        <tr>
                            <td><%= u.getUserId() %></td>
                            <td><%= u.getName() %></td>
                            <td><%= u.getEmail() %></td>
                            <td><%= u.getPhone() %></td>
                            <td class="status-<%= isActive ? "active" : "inactive" %>">
                                <%= currentStatus != null ? currentStatus : "Active" %>
                            </td>
                            <td><%= u.getCreatedAt() != null ? u.getCreatedAt() : "-" %></td>
                            <td>
                                <button class="btn-view" onclick="showLoginHistory(<%= u.getUserId() %>, '<%= u.getName() %>')">Login History</button>
                                
                                <form method="post" action="AdminServlet" style="display:inline;">
                                    <% if(isActive) { %>
                                        <input type="hidden" name="action" value="deactivateUser">
                                        <button type="submit" class="btn-deactivate" onclick="return confirm('Deactivate this user?')">Deactivate</button>
                                    <% } else { %>
                                        <input type="hidden" name="action" value="activateUser">
                                        <button type="submit" class="btn-activate" onclick="return confirm('Activate this user?')">Activate</button>
                                    <% } %>
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                </form>
                            </td>
                        </tr>
                <% } } else { %>
                    <tr>
                        <td colspan="7" style="text-align:center; padding:40px; color:#9a9a9a;">No users found</td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <!-- ✅ NEW: pagination controls -->
        <% if(totalPages != null && totalPages > 1) { %>
        <div class="pagination-controls">
            <% if(currentPage > 1) { %>
                <a href="AdminServlet?action=users&page=<%= currentPage - 1 %>">← Previous</a>
            <% } %>
            <span>Page <%= currentPage %> of <%= totalPages %></span>
            <% if(currentPage < totalPages) { %>
                <a href="AdminServlet?action=users&page=<%= currentPage + 1 %>">Next →</a>
            <% } %>
        </div>
        <% } %>
    </div>
    
    <!-- Login History Modal -->
    <div id="loginHistoryModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Login History - <span id="modalUserName"></span></h3>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <div id="modalContent">
                <div style="text-align:center; padding:20px; color:#9a9a9a;">Loading...</div>
            </div>
        </div>
    </div>
    
    <script>
        function showLoginHistory(userId, userName) {
            document.getElementById("modalUserName").innerText = userName;
            document.getElementById("loginHistoryModal").style.display = "block";
            document.getElementById("modalContent").innerHTML = '<div style="text-align:center; padding:20px; color:#9a9a9a;">Loading...</div>';
            
            fetch('AdminServlet?action=getLoginHistory&userId=' + userId)
                .then(response => response.json())
                .then(data => {
                    if(data && data.length > 0) {
                        let html = '<table class="history-table">';
                        html += '<thead><tr><th>Login Time</th><th>Logout Time</th></tr></thead><tbody>';
                        data.forEach(entry => {
                            html += '<tr>';
                            html += '<td>' + entry.loginTime + '</td>';
                            html += '<td>' + (entry.logoutTime || 'Still Logged In') + '</td>';
                            html += '</tr>';
                        });
                        html += '</tbody></table>';
                        document.getElementById("modalContent").innerHTML = html;
                    } else {
                        document.getElementById("modalContent").innerHTML = '<div class="no-data">No login history found for this user</div>';
                    }
                })
                .catch(error => {
                    document.getElementById("modalContent").innerHTML = '<div class="no-data">Error loading login history</div>';
                });
        }
        
        function closeModal() {
            document.getElementById("loginHistoryModal").style.display = "none";
        }
        
        window.onclick = function(event) {
            if (event.target == document.getElementById("loginHistoryModal")) {
                closeModal();
            }
        }
    </script>
</body>
</html>