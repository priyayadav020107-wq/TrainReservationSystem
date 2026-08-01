<%@ page import="model.AdminPojo" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if(adminId == null) {
        response.sendRedirect("AdminLogin.jsp");
        return;
    }
    String adminName = (String) session.getAttribute("adminName");
    
    AdminPojo adminProfile = (AdminPojo) request.getAttribute("adminProfile");
    if(adminProfile == null) {
        response.sendRedirect("AdminServlet?action=adminProfile");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Profile</title>
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

        .profile-card {
            background: rgba(44,44,46,0.92);
            border-radius: 12px;
            padding: 30px;
            max-width: 600px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
            margin: 0 20px;
        }
        .profile-card h3 {
            margin-bottom: 20px;
            color: #f0f0f0;
            border-bottom: 2px solid #f5a623;
            padding-bottom: 10px;
        }
        .profile-field {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #3e3e40;
        }
        .field-label {
            font-weight: bold;
            color: #9a9a9a;
            width: 100px;
        }
        .field-value {
            color: #f0f0f0;
            flex: 1;
            margin-left: 20px;
        }
        .field-actions {
            display: flex;
            gap: 10px;
        }
        .edit-btn {
            background: linear-gradient(135deg, #e8720c, #c1121f);
            color: white;
            border: none;
            padding: 5px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
            transition: opacity 0.3s;
        }
        .edit-btn:hover { opacity: 0.85; }
        
        .message { 
            background: #1e3020; 
            color: #5cb87a; 
            padding: 10px; 
            border-radius: 5px; 
            margin-bottom: 15px;
            border: 1px solid #2d4a33;
            display: none;
        }
        .error {
            background: #2e1a1a;
            color: #e8720c;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            border: 1px solid #4a2a2a;
            display: none;
        }
        
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
            margin: 10% auto;
            padding: 25px;
            width: 400px;
            border-radius: 12px;
            border: 1px solid #3e3e40;
            box-shadow: 0 5px 20px rgba(0,0,0,0.5);
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            border-bottom: 2px solid #f5a623;
            padding-bottom: 10px;
        }
        .modal-header h3 { margin: 0; color: #f0f0f0; }
        .close {
            font-size: 24px;
            cursor: pointer;
            color: #9a9a9a;
        }
        .close:hover { color: #f0f0f0; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #9a9a9a; font-size: 13px; }
        .form-group input { 
            width: 100%; 
            padding: 8px; 
            border: 1px solid #3e3e40; 
            border-radius: 5px; 
            background: #1a1a1c;
            color: #f0f0f0;
        }
        .form-group input:focus { outline: none; border-color: #f5a623; }
        .modal-btn {
            background: linear-gradient(135deg, #e8720c, #c1121f);
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            margin-top: 10px;
            transition: opacity 0.3s;
        }
        .modal-btn:hover { opacity: 0.85; }
        .error-text { color: #e8720c; font-size: 12px; margin-top: 10px; text-align: center; }
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
            <a href="AdminServlet?action=users" class="menu-item ">
                <i class="fas fa-users menu-icon"></i>
                <span>Users</span>
            </a>
            <a href="AdminServlet?action=reports" class="menu-item ">
                <i class="fas fa-chart-line menu-icon"></i>
                <span>Reports</span>
            </a>
            <a href="AdminServlet?action=adminProfile" class="menu-item active">
                <i class="fas fa-user-circle menu-icon"></i>
                <span>Profile</span>
            </a>
        </div>
    </div>
 
    <div class="main-content">
        <div class="top-navbar">
            <h1 class="page-title">Admin Profile</h1>
            <div class="user-info">
                <span class="user-name">Welcome, <%= adminName %></span>
                <form method="post" action="AdminServlet" style="display: inline;">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </div>
        
        <div class="profile-card">
            <h3>My Profile</h3>
            
            <div id="successMsg" class="message"></div>
            <div id="errorMsg" class="error"></div>
            
            <div class="profile-field">
                <div class="field-label">Admin ID:</div>
                <div class="field-value"><%= adminProfile.getAdminId() %></div>
                <div class="field-actions"></div>
            </div>
            
            <div class="profile-field">
                <div class="field-label">Name:</div>
                <div class="field-value" id="displayName"><%= adminProfile.getName() %></div>
                <div class="field-actions">
                    <button class="edit-btn" onclick="openEditNameModal()">Edit</button>
                </div>
            </div>
            
            <div class="profile-field">
                <div class="field-label">Email:</div>
                <div class="field-value" id="displayEmail"><%= adminProfile.getEmail() %></div>
                <div class="field-actions">
                    <button class="edit-btn" onclick="openEditEmailModal()">Edit</button>
                </div>
            </div>
            
            <div class="profile-field">
                <div class="field-label">Password:</div>
                <div class="field-value">******</div>
                <div class="field-actions">
                    <button class="edit-btn" onclick="openPasswordModal()">Change</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal 1: Edit Name -->
    <div id="editNameModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Name</h3>
                <span class="close" onclick="closeEditNameModal()">&times;</span>
            </div>
            <div>
                <div class="form-group">
                    <label>New Name</label>
                    <input type="text" id="newName" value="<%= adminProfile.getName() %>">
                </div>
                <button class="modal-btn" onclick="updateName()">Update Name</button>
                <div id="nameError" class="error-text"></div>
            </div>
        </div>
    </div>
    
    <!-- Modal 2: Edit Email -->
    <div id="editEmailModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Email</h3>
                <span class="close" onclick="closeEditEmailModal()">&times;</span>
            </div>
            <div>
                <div class="form-group">
                    <label>Current Email</label>
                    <input type="email" id="currentEmail" value="<%= adminProfile.getEmail() %>" readonly style="background:#1a1a1c; opacity:0.7;">
                </div>
                <div class="form-group">
                    <label>New Email</label>
                    <input type="email" id="newEmail" placeholder="Enter new email">
                </div>
                <button class="modal-btn" onclick="updateEmail()">Update Email</button>
                <div id="emailError" class="error-text"></div>
            </div>
        </div>
    </div>
    
    <!-- Modal 3: Change Password -->
    <div id="passwordModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Change Password</h3>
                <span class="close" onclick="closePasswordModal()">&times;</span>
            </div>
            <div>
                <div class="form-group">
                    <label>Current Password</label>
                    <input type="password" id="oldPassword" placeholder="Enter current password">
                </div>
                <div class="form-group">
                    <label>New Password</label>
                    <input type="password" id="newPassword" placeholder="Enter new password (min 6 chars)">
                </div>
                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password" id="confirmPassword" placeholder="Confirm new password">
                </div>
                <button class="modal-btn" onclick="changePassword()">Change Password</button>
                <div id="passwordError" class="error-text"></div>
            </div>
        </div>
    </div>
    
    <script>
        function showMessage(msg, isError) {
            if(isError) {
                document.getElementById('errorMsg').innerHTML = msg;
                document.getElementById('errorMsg').style.display = 'block';
                setTimeout(() => {
                    document.getElementById('errorMsg').style.display = 'none';
                }, 3000);
            } else {
                document.getElementById('successMsg').innerHTML = msg;
                document.getElementById('successMsg').style.display = 'block';
                setTimeout(() => {
                    document.getElementById('successMsg').style.display = 'none';
                }, 3000);
            }
        }
        
        // ========== NAME EDIT (Separate API call) ==========
        function openEditNameModal() {
            document.getElementById('editNameModal').style.display = 'block';
            document.getElementById('nameError').innerHTML = '';
        }
        function closeEditNameModal() {
            document.getElementById('editNameModal').style.display = 'none';
        }
        function updateName() {
            let newName = document.getElementById('newName').value.trim();
            if(!newName) {
                document.getElementById('nameError').innerHTML = 'Name cannot be empty';
                return;
            }
            // ✅ Only name is sent, email is NOT touched
            fetch('AdminServlet?action=updateAdminName', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'name=' + encodeURIComponent(newName)
            })
            .then(response => response.json())
            .then(data => {
                if(data.success) {
                    document.getElementById('displayName').innerText = newName;
                    document.querySelector('.user-name').innerText = 'Welcome, ' + newName;
                    showMessage('Name updated successfully!', false);
                    closeEditNameModal();
                } else {
                    document.getElementById('nameError').innerHTML = data.message;
                }
            })
            .catch(error => {
                document.getElementById('nameError').innerHTML = 'Error updating name';
            });
        }
        
        // ========== EMAIL EDIT (Separate API call) ==========
        function openEditEmailModal() {
            document.getElementById('editEmailModal').style.display = 'block';
            document.getElementById('emailError').innerHTML = '';
            document.getElementById('newEmail').value = '';
        }
        function closeEditEmailModal() {
            document.getElementById('editEmailModal').style.display = 'none';
        }
        function updateEmail() {
            let newEmail = document.getElementById('newEmail').value.trim();
            if(!newEmail) {
                document.getElementById('emailError').innerHTML = 'Email cannot be empty';
                return;
            }
            if(!newEmail.includes('@')) {
                document.getElementById('emailError').innerHTML = 'Invalid email format';
                return;
            }
            // ✅ Only email is sent, name is NOT touched
            fetch('AdminServlet?action=updateAdminEmail', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'email=' + encodeURIComponent(newEmail)
            })
            .then(response => response.json())
            .then(data => {
                if(data.success) {
                    document.getElementById('displayEmail').innerText = newEmail;
                    showMessage('Email updated successfully!', false);
                    closeEditEmailModal();
                } else {
                    document.getElementById('emailError').innerHTML = data.message;
                }
            })
            .catch(error => {
                document.getElementById('emailError').innerHTML = 'Error updating email';
            });
        }
        
        // ========== PASSWORD CHANGE ==========
        function openPasswordModal() {
            document.getElementById('passwordModal').style.display = 'block';
            document.getElementById('passwordError').innerHTML = '';
            document.getElementById('oldPassword').value = '';
            document.getElementById('newPassword').value = '';
            document.getElementById('confirmPassword').value = '';
        }
        function closePasswordModal() {
            document.getElementById('passwordModal').style.display = 'none';
        }
        function changePassword() {
            let oldPassword = document.getElementById('oldPassword').value;
            let newPassword = document.getElementById('newPassword').value;
            let confirmPassword = document.getElementById('confirmPassword').value;
            
            if(!oldPassword || !newPassword || !confirmPassword) {
                document.getElementById('passwordError').innerHTML = 'All fields are required';
                return;
            }
            if(newPassword !== confirmPassword) {
                document.getElementById('passwordError').innerHTML = 'New passwords do not match';
                return;
            }
            if(newPassword.length < 6) {
                document.getElementById('passwordError').innerHTML = 'Password must be at least 6 characters';
                return;
            }
            fetch('AdminServlet?action=changeAdminPassword', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'currentPassword=' + encodeURIComponent(oldPassword) + '&newPassword=' + encodeURIComponent(newPassword)
            })
            .then(response => response.json())
            .then(data => {
                if(data.success) {
                    showMessage('Password changed successfully! Please login again.', false);
                    setTimeout(() => {
                        window.location.href = 'AdminLogin.jsp';
                    }, 2000);
                } else {
                    document.getElementById('passwordError').innerHTML = data.message;
                }
            })
            .catch(error => {
                document.getElementById('passwordError').innerHTML = 'Error changing password';
            });
        }
        
        window.onclick = function(event) {
            if(event.target == document.getElementById('editNameModal')) closeEditNameModal();
            if(event.target == document.getElementById('editEmailModal')) closeEditEmailModal();
            if(event.target == document.getElementById('passwordModal')) closePasswordModal();
        }
    </script>
</body>
</html>
