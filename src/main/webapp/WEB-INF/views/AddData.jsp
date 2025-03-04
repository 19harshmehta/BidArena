<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    Integer auctionId = (Integer) session.getAttribute("auctionId");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Upload Data | BidArena</title>
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

    <style type="text/css">
        .input-wrapper {
            position: relative;
            width: 100%;
            margin-bottom: 20px;
        }

        .input100 {
            opacity: 0; /* Hide default file input */
            position: absolute;
            z-index: -1;
        }

        .custom-file-label {
            display: block;
            width: 100%;
            padding: 10px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
            transition: 0.3s ease-in-out;
        }

        .custom-file-label.selected {
            background-color: #d4edda; /* Light Green */
            border-color: #28a745; /* Green Border */
            color: #155724; /* Dark Green Text */
            font-weight: bold;
        }

        .error-message {
            color: red;
            font-weight: bold;
        }

        .success-message {
            color: green;
            font-weight: bold;
        }
    </style>

    <script>
        function validateForm() {
            var teamsFile = document.getElementById("teamsFile").value;
            var playersFile = document.getElementById("playersFile").value;
            var auctionId = "<%= auctionId %>";

            if (!teamsFile || !playersFile) {
                alert("Please select both Teams and Players Excel files.");
                return false;
            }

            if (!auctionId) {
                alert("Auction ID not found! Please create an auction first.");
                return false;
            }
            return true;
        }
    </script>

</head>
<body>

<div class="limiter">
    <div class="container-login100">
        <div class="wrap-login100">
            <form class="login100-form validate-form" action="uploadfiles" method="POST" enctype="multipart/form-data" onsubmit="return validateForm()">
                <span class="login100-form-title p-b-26">
                    Upload Auction Data
                </span>

                <%-- Display Auction ID --%>
                <p><b>Active Auction ID:</b> <%= (auctionId != null) ? auctionId : "Not Set" %></p>

                <%-- Success/Error Messages --%>
                <% if (request.getAttribute("success") != null) { %>
                    <p class="success-message"><%= request.getAttribute("success") %></p>
                <% } %>
                <% if (request.getAttribute("error") != null) { %>
                    <p class="error-message"><%= request.getAttribute("error") %></p>
                <% } %>

                <!-- Upload Teams File -->
                <div class="input-wrapper">
                    <input class="input100 file-input" type="file" name="teamsFile" id="teamsFile" accept=".xlsx, .xls" required>
                    <label for="teamsFile" class="custom-file-label">Upload Teams File</label>
                </div>

                <!-- Upload Players File -->
                <div class="input-wrapper">
                    <input class="input100 file-input" type="file" name="playersFile" id="playersFile" accept=".xlsx, .xls" required>
                    <label for="playersFile" class="custom-file-label">Upload Players File</label>
                </div>

                <!-- Submit Button -->
                <div class="container-login100-form-btn">
                    <div class="wrap-login100-form-btn">
                        <div class="login100-form-bgbtn"></div>
                        <button class="login100-form-btn" type="submit">
                            Upload Files
                        </button>
                    </div>
                </div>

                <div class="text-center p-t-115">
                    <a class="txt2" href="/dashboard">
                        Back to Dashboard
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="dropDownSelect1"></div>

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

<!-- JavaScript for File Input Handling -->
<script>
document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".file-input").forEach(input => {
        input.addEventListener("change", function () {
            let label = this.nextElementSibling; 
            if (this.files.length > 0) {
                label.textContent = this.files[0].name; 
                label.classList.add("selected"); 
            } else {
                label.textContent = "Upload File";
                label.classList.remove("selected");
            }
        });
    });
});
</script>

</body>
</html>
