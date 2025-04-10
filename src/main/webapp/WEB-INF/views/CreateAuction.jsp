<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ include file="Layout.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Create Auction | BidArena</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Favicon -->
<link rel="icon" type="image/png" href="images/icons/favicon.ico"/>

<!-- Bootstrap and CSS -->
<link rel="stylesheet" type="text/css" href="../assets/vendor/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="../assets/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="../assets/fonts/iconic/css/material-design-iconic-font.min.css">
<link rel="stylesheet" type="text/css" href="../assets/vendor/animate/animate.css">
<link rel="stylesheet" type="text/css" href="../assets/vendor/css-hamburgers/hamburgers.min.css">
<link rel="stylesheet" type="text/css" href="../assets/vendor/animsition/css/animsition.min.css">
<link rel="stylesheet" type="text/css" href="../assets/vendor/select2/select2.min.css">
<link rel="stylesheet" type="text/css" href="../assets/vendor/daterangepicker/daterangepicker.css">
<link rel="stylesheet" type="text/css" href="../assets/css/util.css">
<link rel="stylesheet" type="text/css" href="../assets/css/main.css">

<style>
    .wrap-login100 {
        width: 80% !important; /* or 100%, based on your design */
        max-width: 1000px;     /* adjust as needed */
        margin-top : -50px;
    }
    
    .container-login100{
    	margin : 0px;
    }
    
</style>


</head>
<body>

<div class="limiter">
    <div class="container-login100">
        <div class="wrap-login100">
            <form class="login100-form validate-form" action="createauction" method="POST">
                <span class="login100-form-title p-b-26">
                    Create Auction
                </span>

               	<div class="row">
    				<div class="col-md-6">
				        <div class="wrap-input100 validate-input" data-validate="Enter League Name">
				            <input class="input100" type="text" name="leagueName" required>
				            <span class="focus-input100" data-placeholder="League Name"></span>
				        </div>
				    </div>
				    <div class="col-md-6">
				        <div class="wrap-input100 validate-input" data-validate="Enter Number of Teams">
				            <input class="input100" type="number" name="numTeams" min="4" required>
				            <span class="focus-input100" data-placeholder="Number of Teams"></span>
				        </div>
				    </div>
				</div>
				
				<div class="row">
				    <div class="col-md-6">
				        <div class="wrap-input100 validate-input" data-validate="Enter min. Number of players in each team">
				            <input class="input100" type="number" name="numPlayers" min="2" required>
				            <span class="focus-input100" data-placeholder="min. No. of Players (in each team)"></span>
				        </div>
				    </div>
				    <div class="col-md-6">
				        <div class="wrap-input100 validate-input" data-validate="Enter max. Number of players in each team">
				            <input class="input100" type="number" name="maxNumPlayers" required>
				            <span class="focus-input100" data-placeholder="max. No. of Players (in each team)"></span>
				        </div>
				    </div>
				</div>

                <div class="wrap-input100 validate-input" data-validate="Enter Wallet per Team">
                    <input class="input100" type="number" name="walletPerTeam" min="0" required>
                    <span class="focus-input100" data-placeholder="Wallet points per Team"></span>
                </div>

                <div class="wrap-input100 validate-input" data-validate="Enter Base Price">
                    <input class="input100" type="number" name="basePrice" min="0" required>
                    <span class="focus-input100" data-placeholder="Base Price"></span>
                </div>

                

                <div class="container-login100-form-btn">
                    <div class="wrap-login100-form-btn">
                        <div class="login100-form-bgbtn"></div>
                        <button class="login100-form-btn" type="submit">
                            Create Auction
                        </button>
                    </div>
                </div>

                <div class="text-center p-t-50">
                    <a class="txt2" href="/dashboard">
                        Back to Dashboard
                    </a>
                </div>

            </form>
    </div>
</div>


<!-- JavaScript -->
<script src="../assets/vendor/jquery/jquery-3.2.1.min.js"></script>
<script src="../assets/vendor/animsition/js/animsition.min.js"></script>
<script src="../assets/vendor/bootstrap/js/popper.js"></script>
<script src="../assets/vendor/bootstrap/js/bootstrap.min.js"></script>
<script src="../assets/vendor/select2/select2.min.js"></script>
<script src="../assets/vendor/daterangepicker/moment.min.js"></script>
<script src="../assets/vendor/daterangepicker/daterangepicker.js"></script>
<script src="../assets/vendor/countdowntime/countdowntime.js"></script>
<script src="../assets/js/main.js"></script>

</body>
</html>
