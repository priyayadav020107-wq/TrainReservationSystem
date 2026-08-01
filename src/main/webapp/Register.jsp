<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <style>
        body {
            font-family: Arial;
            background: linear-gradient(to right, #2e2e30 0%, #242426 40%, #1a1a1c 100%);
            margin: 0;
        }
        .container {
            width: 400px;
            margin: 80px auto;
            background: #2c2c2e;
            padding: 30px;
            border-radius: 10px;
            border: 1px solid #3e3e40;
            box-shadow: 0 4px 20px rgba(0,0,0,0.45);
        }
        h2 { text-align: center; color: #f5a623; }
        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #3e3e40;
            border-radius: 5px;
            box-sizing: border-box;
            background: #272729;
            color: #e8e8e8;
        }
        button {
            width: 100%;
            padding: 10px;
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover { opacity: 0.85; }
        .link { text-align: center; margin-top: 15px; }
        a { color: #f5a623; }
        .error {
            background: #2e1a1a;
            color: #e8720c;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            border-left: 4px solid #c1121f;
        }
        .message {
            background: #1e3020;
            color: #5cb87a;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            border-left: 4px solid #5cb87a;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>User Registration</h2>

        <%-- ✅ Display error message if any --%>
        <% if(request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <%-- ✅ Display success message if any --%>
        <% if(request.getAttribute("message") != null) { %>
            <div class="message"><%= request.getAttribute("message") %></div>
        <% } %>

        <form method="post" action="UserServlet">
            <input type="hidden" name="action" value="register">
            <input type="text" name="name" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="tel" name="phone" placeholder="Phone Number" required>
            <input type="password" name="password" placeholder="Password (min 6 characters)" required>
            <button type="submit">Register</button>
        </form>
        <div class="link">
            <a href="Login.jsp">Already have account? Login</a>
        </div>
    </div>
</body>
</html>
