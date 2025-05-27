<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>


<html>
<head>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">


    <style type="text/css">
        body {
            background-color: #f0f4ff;
        }
        .form-gap {
            padding-top: 70px;
        }
        .panel {
            border: none;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .btn-primary {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        .loader {
            border-top: 2px solid #3498db; /* Blue */
            border-radius: 50%;
            width: 12px;
            height: 12px;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>


<body>
    <div class="form-gap"></div>
    <div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="panel panel-default">
                    <div class="panel-body text-center">
                        <h2 class="text-center">NHẬP OTP</h2>
                        <form id="otp-form" action="verify-otp" role="form" method="post" autocomplete="off" class="form">
                            <div class="form-group">
                                <input id="opt" name="otp" class="form-control" type="text" placeholder="Nhập OTP" required="required">
                                <span id="err__container" class="text-danger"></span>
                            </div>
                            <div class="form-group">
                                <button type="button" onclick="verifyOTP('${pageContext.request.contextPath}/verify-otp')" class="btn btn-primary btn-block">GỬI</button>
                            </div>
                        </form>
                        <div id="resend__container">
                            <button onclick="resendOTP()" id="resendBtn" class="btn btn-sm btn-secondary" disabled style="display: none;">GỬI LẠI OTP</button>
                            <span id="timer" class="text-muted">Resend in 30 seconds</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <script>
        document.addEventListener("DOMContentLoaded", function () {
            startTimer();
        });


        function startTimer() {
            let countdown = 30; 
            const resendBtn = document.getElementById('resendBtn');
            const timerElement = document.getElementById('timer');


            const interval = setInterval(function () {
                countdown--;


                if (countdown <= 0) {
                    clearInterval(interval);
                    resendBtn.removeAttribute('disabled');
                    resendBtn.style.display = 'block';
                    timerElement.style.display = 'none';
                } else {
                    timerElement.textContent = 'Resend in ' + countdown + ' seconds';
                }
            }, 1000);
        }


        function resendOTP() {
            const resendBtn = document.getElementById('resendBtn');
            resendBtn.innerHTML = '<span class="loader"></span> GỬI LẠI...';
            resendBtn.setAttribute('disabled', true);


            $.ajax({
                type: 'POST',
                url: 'ResendOTP',
                success: function (result) {
                    document.querySelector('#resend__container').innerHTML = result;
                    startTimer();
                },
                error: function (error) {
                    console.error('Error while resending OTP:', error);
                    resendBtn.innerHTML = 'GỬI LẠI OTP';
                    resendBtn.removeAttribute('disabled');
                }
            });
        }


        function verifyOTP(url) {
            $.ajax({
                type: 'POST',
                data: { otp: document.getElementById('opt').value },
                url: url,
                dataType: 'json',
                success: function (response) {
                    if (response.status === 'success-forgotpassword') {
                        window.location.href = 'reset-password'; 
                    } else if (response.status === 'success-emailverification') {
                        window.location.href = 'signup';
                    } else {
                        document.querySelector('#err__container').innerHTML = response.message;
                    }
                }
            });
        }
    </script>
</body>
</html>