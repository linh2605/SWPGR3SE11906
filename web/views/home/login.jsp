<%-- 
    Document   : login
    Created on : May 26, 2025, 5:08:48 AM
    Author     : tamthui
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-box {
            background: white;
            padding: 40px;
            border-radius: 10px;
            width: 350px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .login-box h2 {
            text-align: center;
        }
        .login-box input[type="text"],
        .login-box input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .login-box .checkbox-group {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
        }
        .login-box button {
            width: 100%;
            background-color: #41d9c2;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="login-box">
    <h2>ĐĂNG NHẬP</h2>
    <p style="text-align: center;">Mời bạn đăng nhập để thực hiện các thao tác quản lí</p>
    <form action="login" method="post">
        <input type="text" name="username" placeholder="Email or username" required>
        <input type="password" name="password" placeholder="Password" required>
        <div class="checkbox-group">
            <label><input type="checkbox" name="remember"> Remember</label>
            <label><input type="checkbox" name="forget"> Forget password</label>
        </div>
        <button type="submit">ĐĂNG NHẬP</button>
    </form>
</div>
</body>
</html>


