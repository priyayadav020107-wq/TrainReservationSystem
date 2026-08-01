<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html, body {
            width: 100%;
            height: 100%;
        }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #0d0d10;
        }

        /* Outer frame - now fills the entire viewport, no floating card */
        .frame {
            width: 100vw;
            height: 100vh;
            background: #0d0d10;
            border-radius: 0;
            padding: 0;
            box-shadow: none;
        }

        .split-container {
            display: flex;
            width: 100%;
            height: 100%;
            border-radius: 0;
            overflow: hidden;
        }

        /* ===== LEFT SIDE — Train image panel ===== */
        .left-panel {
            flex: 1.1;
            position: relative;
            background:
                linear-gradient(100deg, rgba(20,20,20,0.55) 0%, rgba(232,114,12,0.55) 35%, rgba(193,18,31,0.35) 55%, rgba(20,20,20,0.15) 75%),
                url('https://images.unsplash.com/photo-1474487548417-781cb71495f3?q=80&w=1200&auto=format&fit=crop') center/cover no-repeat;
            display: flex;
            align-items: flex-end;
            padding: 40px;
        }
        /* 
           ⬆ Replace the url('...') above with your own train photo:
           e.g. url('assets/train-banner.jpg')
        */
        .left-panel::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(180deg, rgba(13,13,16,0.15) 0%, rgba(13,13,16,0.55) 100%);
        }
        .left-caption {
            position: relative;
            z-index: 2;
            color: #f0f0f0;
        }
        .left-caption .tag {
            display: inline-block;
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1px;
            padding: 5px 12px;
            border-radius: 4px;
            margin-bottom: 14px;
        }
        .left-caption h1 {
            font-size: 30px;
            font-weight: 700;
            line-height: 1.25;
            text-shadow: 0 2px 10px rgba(0,0,0,0.5);
        }

        /* ===== RIGHT SIDE — Admin login form panel ===== */
        .right-panel {
            flex: 1;
            background: #1c1c1f;
            padding: 45px 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: #f0f0f0;
        }
        .right-panel-inner {
            width: 100%;
            max-width: 420px;
        }
        .right-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 35px;
        }
        .brand {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 700;
            font-size: 15px;
            color: #f0f0f0;
        }
        .brand .dot {
            width: 18px;
            height: 18px;
            border-radius: 4px;
            background: linear-gradient(135deg, #f5a623, #e8720c);
            display: inline-block;
        }
        .system-tag {
            font-size: 12px;
            color: #8a8a8f;
        }

        h2.form-title {
            font-size: 26px;
            font-weight: 700;
            color: #f0f0f0;
            margin-bottom: 4px;
            text-align: left;
        }
        .form-title .dot-accent { color: #e8720c; }
        .form-subtitle {
            font-size: 13px;
            color: #8a8a8f;
            margin-bottom: 28px;
        }

        .field-label {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.5px;
            color: #8a8a8f;
            text-transform: uppercase;
            margin-bottom: 6px;
            display: block;
        }
        .field-group { margin-bottom: 18px; }

        input {
            width: 100%;
            padding: 12px 14px;
            margin: 0;
            border: 1px solid #34343a;
            border-radius: 6px;
            background: #141416;
            color: #f0f0f0;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s;
        }
        input::placeholder { color: #6a6a70; }
        input:focus { border-color: #e8720c; }

        .field-group.active input {
            border-color: #e8720c;
            box-shadow: 0 0 0 1px rgba(232,114,12,0.35);
        }

        button[type="submit"] {
            width: 100%;
            padding: 13px;
            background: linear-gradient(135deg, #f5a623, #e8720c);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 0.5px;
            margin-top: 8px;
            transition: opacity 0.2s;
        }
        button[type="submit"]:hover { opacity: 0.88; }

        .error {
            color: #ff8585;
            background: #2e1a1a;
            border-left: 3px solid #c1121f;
            padding: 10px 12px;
            border-radius: 5px;
            font-size: 13px;
            margin-bottom: 16px;
            text-align: left;
        }

        .link {
            text-align: left;
            margin-top: 22px;
            font-size: 13px;
            color: #8a8a8f;
        }
        a { color: #f5a623; text-decoration: none; font-weight: 600; }
        a:hover { text-decoration: underline; }

        @media (max-width: 760px) {
            .split-container { flex-direction: column; }
            .left-panel { min-height: 200px; }
        }
    </style>
</head>
<body>
    <div class="frame">
        <div class="split-container">

            <!-- LEFT: Train image panel -->
            <div class="left-panel">
                <div class="left-caption">
                    <span class="tag">INDIAN RAILWAYS</span>
                    <h1>Admin access<br>to the system</h1>
                </div>
            </div>

            <!-- RIGHT: Admin login form panel -->
            <div class="right-panel">
              <div class="right-panel-inner">
                <div class="right-top">
                    <div class="brand"><span class="dot"></span> Train Reservation</div>
                    <div class="system-tag">Indian Railways</div>
                </div>

                <h2 class="form-title">🔐 Admin<span class="dot-accent">.</span></h2>
                <div class="form-subtitle">Sign in to the admin dashboard</div>

                <% if(request.getAttribute("error") != null) { %>
                    <div class="error"><%= request.getAttribute("error") %></div>
                <% } %>

                <form method="post" action="AdminServlet">
                    <input type="hidden" name="action" value="login">

                    <div class="field-group active">
                        <label class="field-label">Admin Email</label>
                        <input type="email" name="email" placeholder="Enter admin email" required>
                    </div>

                    <div class="field-group">
                        <label class="field-label">Password</label>
                        <input type="password" name="password" placeholder="Enter your password" required>
                    </div>

                    <button type="submit">LOGIN</button>
                </form>

                <div class="link">
                    <a href="Login.jsp">← User Login</a>
                </div>
              </div>
            </div>

        </div>
    </div>
</body>
</html>
