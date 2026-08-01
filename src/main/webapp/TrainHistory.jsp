<%@ page import="java.util.List, java.util.Map" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if(adminId == null) response.sendRedirect("AdminLogin.jsp");
    String adminName = (String) session.getAttribute("adminName");
    
    List<Map<String, Object>> allAudit = (List<Map<String, Object>>) request.getAttribute("allAudit");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Train History - All Trains</title>
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

        table { 
            width: calc(100% - 40px); 
            margin: 0 20px;
            background: rgba(44,44,46,0.92); 
            border-radius: 12px; 
            overflow: hidden; 
            border-collapse: collapse;
            border: 1px solid #3e3e40;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
        }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #3e3e40; color: #f0f0f0; }
        th { background: #1a1a1c; color: #f5a623; }
        tr:hover td { background: rgba(54,54,56,0.5); }
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
        .badge-update { 
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white; 
            padding: 3px 8px; 
            border-radius: 12px; 
            font-size: 11px; 
            display: inline-block; 
        }
        .badge-deactivate { 
            background: linear-gradient(135deg, #e8720c, #c1121f);
            color: white; 
            padding: 3px 8px; 
            border-radius: 12px; 
            font-size: 11px; 
            display: inline-block; 
        }
        .badge-activate { 
            background: linear-gradient(135deg, #5cb87a, #28a745);
            color: white; 
            padding: 3px 8px; 
            border-radius: 12px; 
            font-size: 11px; 
            display: inline-block; 
        }
        .old-value { color: #c1121f; text-decoration: line-through; }
        .new-value { color: #5cb87a; font-weight: bold; }
        .empty-message { 
            text-align: center; 
            padding: 40px; 
            color: #9a9a9a;
            background: rgba(44,44,46,0.92);
            border-radius: 12px;
            margin: 0 20px;
            border: 1px solid #3e3e40;
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
            <h1 class="page-title">Train History (All Trains)</h1>
            <div class="user-info">
                <span class="user-name">Welcome, <%= adminName %></span>
                <form method="post" action="AdminServlet" style="display: inline;">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </div>
        
        <button class="back-btn" onclick="history.back()">Back to Train Management</button>
        
        <% if(allAudit != null && !allAudit.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>Date & Time</th>
                        <th>Train ID</th>
                        <th>Train No</th>
                        <th>Train Name</th>
                        <th>Action Type</th>
                        <th>Old Fare</th>
                        <th>New Fare</th>
                        <th>Old Status</th>
                        <th>New Status</th>
                        <th>Changed By</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Map<String, Object> entry : allAudit) { 
                        String actionType = (String) entry.get("actionType");
                        String badgeClass = "badge-update";
                        if("DEACTIVATE".equals(actionType)) badgeClass = "badge-deactivate";
                        if("ACTIVATE".equals(actionType)) badgeClass = "badge-activate";
                    %>
                        <tr>
                            <td><%= entry.get("changedAt") %></td>
                            <td><%= entry.get("trainId") %></td>
                            <td><%= entry.get("trainNo") %></td>
                            <td><%= entry.get("trainName") %></td>
                            <td><span class="<%= badgeClass %>"><%= actionType %></span></td>
                            <td class="old-value">Rs. <%= String.format("%.2f", entry.get("oldFare")) %></td>
                            <td class="new-value">Rs. <%= String.format("%.2f", entry.get("newFare")) %></td>
                            <td><%= entry.get("oldStatus") != null ? entry.get("oldStatus") : "-" %></td>
                            <td><%= entry.get("newStatus") != null ? entry.get("newStatus") : "-" %></td>
                            <td><%= entry.get("changedBy") != null ? entry.get("changedBy") : "System" %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="empty-message">
                <p>No history records found.</p>
                <p>History is created when you update train fare or status.</p>
            </div>
        <% } %>
    </div>
</body>
</html>
