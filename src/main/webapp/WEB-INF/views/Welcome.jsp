<%@page import="org.springframework.ui.Model"%>
<%@page import="com.SE.entity.AuctionEntity"%>
<%@page import="java.util.List"%>
<%@page import="com.SE.entity.UserEntity"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="ISO-8859-1">
    <title>Dashboard | BidArena</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            display: flex;
            flex-direction: column;
            height: 100vh;
            background-color: #f4f4f4;
        }

        /* Top Navbar */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #a64bf4;
            background: linear-gradient(to right, #21d4fd, #b721ff, #21d4fd, #b721ff);
            padding: 15px;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }

        .top-nav .brand {
            color: white;
            font-size: 30px;
            font-weight: bold;
            letter-spacing: 2px;
            margin-left: 25px;
        }

        .top-nav .user-settings {
            color: white;
            cursor: pointer;
            font-size: 18px;
            margin-right: 15px;
            position: relative;
        }
        
        .user-icon {
    		font-size: 20px;  /* Adjust size */
    		margin-right: 8px; /* Spacing between icon and text */
    		vertical-align: middle; /* Align with text */
		}


        .dropdown {
            display: none;
            position: absolute;
            right: 0;
            top: 35px;
            background: white;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            width: 150px;
            z-index: 1000;
        }

        .dropdown a {
            display: block;
            padding: 10px;
            color: black;
            text-decoration: none;
        }

        .dropdown a:hover {
            background: #f1f1f1;
        }

        /* Layout */
        .layout-container {
            display: flex;
            margin-top: 60px;
            height: calc(100vh - 60px);
        }

        /* Sidebar */
        .sidebar {
            width: 200px;
            background: white;
            padding-top: 20px;
            height: 100%;
            transition: transform 0.3s ease;
            border-right: 7px solid lightgrey;
        }

        .sidebar a {
            display: block;
            color: #b721ff;
            padding: 15px 30px;
            font-size: 20px;
            text-decoration: none;
            transition: 0.3s;
        }

        .sidebar a:hover {
            font-size: 25px;
            font-weight: bold;
            background: #f0ccff;
            
        }

        /* Sidebar Toggle Button */
        .sidebar-toggle {
            display: none;
            position: absolute;
            top: 15px;
            left: 15px;
            font-size: 24px;
            cursor: pointer;
            color: white;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background: #ffffff;
        }

        
        
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                position: absolute;
                height: 100%;
                z-index: 999;
            }

            .sidebar.open {
                transform: translateX(0);
            }

            .sidebar-toggle {
                display: block;
            }
        }
        
        .table-custom {
		    width: 100%;
		    border-collapse: collapse;
		    border-radius: 8px;
		    overflow: hidden;
		    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
		}
		
		.table-custom th, .table-custom td {
		    padding: 12px;
		    text-align: center;
		}
		
		.table-custom th {
		    background: #0d6efd; /* Bootstrap Primary Blue */
		    color: white;
		    font-weight: bold;
		}
		
		.table-custom tr:nth-child(even) {
		    background: #f8f9fa; /* Light Gray */
		}
		
		.table-custom tr:hover {
		    background: #dee2e6; /* Hover effect */
		}
		
		
		.download-btn {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
        }

        .download-btn:hover {
            background-color: #0056b3;
        }
        
    </style>
</head>
<body>
<% UserEntity user = (UserEntity)session.getAttribute("user"); %>
    <!-- Top Navbar -->
    <div class="top-nav">
        <span class="sidebar-toggle" onclick="toggleSidebar()">&#9776;</span>
        <div class="brand">Bid Arena</div>
        <div class="user-settings" onclick="toggleDropdown()">
        	<span class="user-icon">&#128100;</span>
            <%= user.getUsername() %>
            <div class="dropdown" id="userDropdown">
                <a href="#">Profile</a>
                <a href="#">Settings</a>
                <a href="#">Logout</a>
            </div>
        </div>
    </div>

    <!-- Sidebar + Main Content -->
    <div class="layout-container">
        <!-- Sidebar -->
        <div class="sidebar" id="sidebar">
            <a href="#">Dashboard</a>
            <a href="#">Reports</a>
            <a href="#">Analytics</a>
            <a href="#">Settings</a>
            <a href="#">Help</a>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <h1>Welcome to the Dashboard</h1>   
<%
    List<AuctionEntity> auctions = (List<AuctionEntity>) session.getAttribute("auctions");
%>

<h2>Your Auctions</h2>

<table border="1" style="width:100%; border-collapse: collapse;" class="table-custom">
    <thead>
        <tr>
            <th>Auction Code</th>
            <th>Name</th>
            <th>Created On</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <% if (auctions != null && !auctions.isEmpty()) { %>
            <% for (AuctionEntity auction : auctions) { %>
                <tr>
                    <td><%= auction.getAuctionCode() %></td>
                    <td><%= auction.getLeagueName() %></td>
                    <td><%= auction.getCreatedAt() %></td>
                    <td><%= auction.getStatus() %></td>
                    <td>
					    <a href="#" onclick="startAuction(<%= auction.getAuctionId() %>, this)" 
					       class="start-link">Start Auction</a> | 
					    <a href="#" onclick="startUnsold(<%= auction.getAuctionId() %>, this)" 
					       class="start-link">Start Unsold</a> | 
					    <a href="#" onclick="endAuction(<%= auction.getAuctionId() %>, this)">End Auction</a> |
					   <a href="${pageContext.request.contextPath}/report/download?auctionId=<%=auction.getAuctionId() %>" class="download-btn">Download Auction Report</a>

					</td>
                </tr>
            <% } %>
        <% } else { %>
            <tr>
                <td colspan="6" style="text-align:center;">No auctions found.</td>
            </tr>
        <% } %>
    </tbody>
</table>
        <div><a href="createauction">Create Auction</a></div>
        </div>
        
    </div>

    <script>
        function toggleDropdown() {
            var dropdown = document.getElementById("userDropdown");
            dropdown.style.display = dropdown.style.display === "block" ? "none" : "block";
        }

        document.addEventListener("click", function(event) {
            var dropdown = document.getElementById("userDropdown");
            var userSettings = document.querySelector(".user-settings");

            if (!userSettings.contains(event.target)) {
                dropdown.style.display = "none";
            }
        });

        function toggleSidebar() {
            var sidebar = document.getElementById("sidebar");
            sidebar.classList.toggle("open");
        }
        
        
        function startAuction(auctionId, element) {
            window.location.href = "startAuction?id=" + auctionId;
        }

        function startUnsold(auctionId, element) {
            window.location.href = "startAuction?id=" + auctionId;
        }

        function endAuction(auctionId, element) {
        	console.log("Auction ID:", auctionId);
            if (confirm("Are you sure you want to end this auction?")) {
                fetch("/endAuction?id="+auctionId, { method: 'POST' })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            window.location.href = "/welcome"; // Redirect to welcome page
                        } else {
                            alert("Error: " + data.message);
                        }
                    })
                    .catch(error => console.error("Error:", error));
            } else {
                window.location.href = "/welcome"; // Redirect if user cancels
            }
        }
    </script>

</body>
</html>