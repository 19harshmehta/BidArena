<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Change Password | BidArena</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
<!--===============================================================================================--> 
	<link rel="icon" type="image/png" href="../assets/img/logo.png"/>
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../assets/vendor/bootstrap/css/bootstrap.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../assets/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../assets/fonts/iconic/css/material-design-iconic-font.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../assets/vendor/animate/animate.css">
<!--===============================================================================================--> 
	<link rel="stylesheet" type="text/css" href="../assets/vendor/css-hamburgers/hamburgers.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../assets/vendor/animsition/css/animsition.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../assets/vendor/select2/select2.min.css">
<!--===============================================================================================--> 
	<link rel="stylesheet" type="text/css" href="../assets/vendor/daterangepicker/daterangepicker.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../assets/css/util.css">
	<link rel="stylesheet" type="text/css" href="../assets/css/main.css">
</head>
<body>
<div class="limiter">
		<div class="container-login100">
			<div class="wrap-login100">
				<form class="login100-form validate-form" action="changepassword" method="POST" onsubmit="return validatePasswords()"> 
					<span class="login100-form-title p-b-26">BidArena <br>
						Change Password
					</span>
					
					<div class="wrap-input100 validate-input" data-validate="Valid email is required">
						<input class="input100" type="email" name="email" required>
						<span class="focus-input100" data-placeholder="Email"></span>
					</div>

					<div class="wrap-input100 validate-input" data-validate="Enter new password">
						<input class="input100" type="password" name="password" id="password" required>
						<span class="focus-input100" data-placeholder="New Password"></span>
					</div>

					<div class="wrap-input100 validate-input" data-validate="Confirm your password">
						<input class="input100" type="password" name="cpassword" id="cpassword" required>
						<span class="focus-input100" data-placeholder="Confirm Password"></span>
						<div id="passwordError" style="color: red; font-size: 14px;"></div>
					</div>

					<div class="wrap-input100 validate-input" data-validate="Enter OTP">
						<input class="input100" type="text" name="otp" required>
						<span class="focus-input100" data-placeholder="OTP"></span>
					</div>
					<div><span style="color: red; font-size: 14px;">${error}</span></div>

					<div class="container-login100-form-btn">
						<div class="wrap-login100-form-btn">
							<div class="login100-form-bgbtn"></div>
							<button class="login100-form-btn">Change Password</button>
						</div>
					</div>

					<div class="text-center p-t-115">
						<span class="txt1">Remember your password?</span>
						<a class="txt2" href="login">Login</a>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script>
		function validatePasswords() {
			let password = document.getElementById("password").value;
			let confirmPassword = document.getElementById("cpassword").value;
			let errorMsg = document.getElementById("passwordError");

			if (password !== confirmPassword) {
				errorMsg.textContent = "Passwords do not match!";
				return false;
			} else {
				errorMsg.textContent = "";
				return true;
			}
		}
	</script>

<!--===============================================================================================-->
	<script src="../assets/vendor/jquery/jquery-3.2.1.min.js"></script>
<!--===============================================================================================-->
	<script src="../assets/vendor/animsition/js/animsition.min.js"></script>
<!--===============================================================================================-->
	<script src="../assets/vendor/bootstrap/js/popper.js"></script>
	<script src="../assets/vendor/bootstrap/js/bootstrap.min.js"></script>
<!--===============================================================================================-->
	<script src="../assets/vendor/select2/select2.min.js"></script>
<!--===============================================================================================-->
	<script src="../assets/vendor/daterangepicker/moment.min.js"></script>
	<script src="../assets/vendor/daterangepicker/daterangepicker.js"></script>
<!--===============================================================================================-->
	<script src="../assets/vendor/countdowntime/countdowntime.js"></script>
<!--===============================================================================================-->
	<script src="../assets/js/main.js"></script>
</body>
</html>
