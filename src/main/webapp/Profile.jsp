<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserPojo" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    
    if(userId == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    // ✅ MVC2 compliant - calling POJO method, no raw SQL
    UserPojo userPojo = new UserPojo();
    userPojo.setUserId(userId);
    userPojo.getUserDetails();  // This calls stored procedure via implementor
    
    // Now get values from POJO
    String userEmail = userPojo.getEmail();
    String userPhone = userPojo.getPhone();
    String createdAt = userPojo.getCreatedAt();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
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
        .navbar .logout-icon {
            background: linear-gradient(135deg, #e8720c, #c1121f);
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            color: white;
            font-size: 13px;
        }
        
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
        
        .profile-card {
            background: rgba(44,44,46,0.92);
            border-radius: 12px;
            padding: 30px;
            max-width: 600px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
            border: 1px solid #3e3e40;
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
            color: #e8e8e8;
            flex: 1;
            margin-left: 20px;
        }
        .field-actions {
            display: flex;
            gap: 10px;
        }
        .edit-btn {
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white;
            border: none;
            padding: 5px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
        }
        .edit-btn:hover { opacity: 0.85; }
        
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
            margin: 10% auto;
            padding: 25px;
            width: 400px;
            border-radius: 12px;
            border: 1px solid #3e3e40;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
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
        .close:hover { color: #f5a623; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #9a9a9a; }
        .form-group input { width: 100%; padding: 8px; border: 1px solid #3e3e40; border-radius: 5px; background: #272729; color: #e8e8e8; }
        .modal-btn {
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            margin-top: 10px;
        }
        .modal-btn:hover { opacity: 0.85; }
        .message { 
            background: #1e3020; 
            color: #5cb87a; 
            padding: 10px; 
            border-radius: 5px; 
            margin-bottom: 15px;
            display: none;
            border: 1px solid #2d4a33;
        }
        .error {
            background: #2e1a1a;
            color: #e8720c;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            display: none;
            border: 1px solid #4a2a2a;
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
            <a href="SearchTrain.jsp" class="menu-item"><span class="menu-icon">🔍</span><span>Search Trains</span></a>
            <a href="MyBookings.jsp" class="menu-item"><span class="menu-icon">📋</span><span>My Bookings</span></a>
            <a href="Profile.jsp" class="menu-item active"><span class="menu-icon">👤</span><span>Profile</span></a>
        </div>
    </div>
    
    <div class="main-content">
        <div class="profile-card">
            <h3>My Profile</h3>
            
            <div id="successMsg" class="message"></div>
            <div id="errorMsg" class="error"></div>
            
            <div class="profile-field">
                <div class="field-label">Name:</div>
                <div class="field-value" id="displayName"><%= userName %></div>
                <div class="field-actions">
                    <button class="edit-btn" onclick="openEditNameModal()">Edit</button>
                </div>
            </div>
            
            <div class="profile-field">
                <div class="field-label">Email:</div>
                <div class="field-value" id="displayEmail"><%= userEmail %></div>
                <div class="field-actions">
                    <button class="edit-btn" onclick="openEditEmailModal()">Edit</button>
                </div>
            </div>
            
            <div class="profile-field">
                <div class="field-label">Phone:</div>
                <div class="field-value" id="displayPhone"><%= userPhone %></div>
                <div class="field-actions">
                    <button class="edit-btn" onclick="openEditPhoneModal()">Edit</button>
                </div>
            </div>
            
            <div class="profile-field">
                <div class="field-label">Password:</div>
                <div class="field-value">••••••••</div>
                <div class="field-actions">
                    <button class="edit-btn" onclick="openPasswordModal()">Change</button>
                </div>
            </div>
            
            <div class="profile-field">
                <div class="field-label">Member Since:</div>
                <div class="field-value"><%= createdAt != null ? createdAt : "-" %></div>
                <div class="field-actions"></div>
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
                    <input type="text" id="newName" value="<%= userName %>">
                </div>
                <button class="modal-btn" onclick="updateName()">Update Name</button>
                <div id="nameError" style="color:#e8720c; font-size:12px; margin-top:10px;"></div>
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
                    <input type="email" id="currentEmail" value="<%= userEmail %>" readonly style="background:#1f1f21; color:#9a9a9a;">
                </div>
                <div class="form-group">
                    <label>New Email</label>
                    <input type="email" id="newEmail" placeholder="Enter new email">
                </div>
                <button class="modal-btn" onclick="updateEmail()">Update Email</button>
                <div id="emailError" style="color:#e8720c; font-size:12px; margin-top:10px;"></div>
            </div>
        </div>
    </div>
    
    <!-- Modal 3: Edit Phone -->
    <div id="editPhoneModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Phone</h3>
                <span class="close" onclick="closeEditPhoneModal()">&times;</span>
            </div>
            <div>
                <div class="form-group">
                    <label>Current Phone</label>
                    <input type="tel" id="currentPhone" value="<%= userPhone %>" readonly style="background:#1f1f21; color:#9a9a9a;">
                </div>
                <div class="form-group">
                    <label>New Phone</label>
                    <input type="tel" id="newPhone" placeholder="Enter new phone number">
                </div>
                <button class="modal-btn" onclick="updatePhone()">Update Phone</button>
                <div id="phoneError" style="color:#e8720c; font-size:12px; margin-top:10px;"></div>
            </div>
        </div>
    </div>
    
    <!-- Modal 4: Change Password -->
    <div id="passwordModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Change Password</h3>
                <span class="close" onclick="closePasswordModal()">&times;</span>
            </div>
            <div>
                <div class="form-group">
                    <label>Current Password</label>
                    <input type="password" id="oldPassword">
                </div>
                <div class="form-group">
                    <label>New Password</label>
                    <input type="password" id="newPassword">
                </div>
                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password" id="confirmPassword">
                </div>
                <button class="modal-btn" onclick="changePassword()">Change Password</button>
                <div id="passwordError" style="color:#e8720c; font-size:12px; margin-top:10px;"></div>
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
            fetch('UserServlet?action=updateName', {
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
            });
        }
        
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
            fetch('UserServlet?action=updateEmail', {
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
            });
        }
        
        function openEditPhoneModal() {
            document.getElementById('editPhoneModal').style.display = 'block';
            document.getElementById('phoneError').innerHTML = '';
            document.getElementById('newPhone').value = '';
        }
        function closeEditPhoneModal() {
            document.getElementById('editPhoneModal').style.display = 'none';
        }
        function updatePhone() {
            let newPhone = document.getElementById('newPhone').value.trim();
            if(!newPhone) {
                document.getElementById('phoneError').innerHTML = 'Phone number cannot be empty';
                return;
            }
            if(!/^\d{10}$/.test(newPhone)) {
                document.getElementById('phoneError').innerHTML = 'Enter valid 10-digit phone number';
                return;
            }
            fetch('UserServlet?action=updatePhone', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'phone=' + encodeURIComponent(newPhone)
            })
            .then(response => response.json())
            .then(data => {
                if(data.success) {
                    document.getElementById('displayPhone').innerText = newPhone;
                    showMessage('Phone number updated successfully!', false);
                    closeEditPhoneModal();
                } else {
                    document.getElementById('phoneError').innerHTML = data.message;
                }
            });
        }
        
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
            fetch('UserServlet?action=changePassword', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'oldPassword=' + encodeURIComponent(oldPassword) + '&newPassword=' + encodeURIComponent(newPassword)
            })
            .then(response => response.json())
            .then(data => {
                if(data.success) {
                    showMessage('Password changed successfully!', false);
                    closePasswordModal();
                } else {
                    document.getElementById('passwordError').innerHTML = data.message;
                }
            });
        }
        
        window.onclick = function(event) {
            if(event.target == document.getElementById('editNameModal')) closeEditNameModal();
            if(event.target == document.getElementById('editEmailModal')) closeEditEmailModal();
            if(event.target == document.getElementById('editPhoneModal')) closeEditPhoneModal();
            if(event.target == document.getElementById('passwordModal')) closePasswordModal();
        }
    </script>
</body>
</html>
