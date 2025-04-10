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
            height: 100%;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            background: white;
            padding-top: 20px;
            height: 100%;
            transition: transform 0.3s ease;
            border-right: 7px solid lightgrey;
        }

        .sidebar a {
            display: block;
            color: #5596fc;
            padding: 15px 30px;
            font-size: 20px;
            text-decoration: none;
            transition: 0.3s;
        }

        .sidebar a:hover {
            font-size: 25px;
            font-weight: bold;
            background: #d8eefc;
            
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
			    display: flex;
			    flex-direction: column;
			    align-items: flex-start; /* Ensures content is aligned to the left */
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
            <a href="/welcome">Dashboard</a>
            <a href="createauction">Create Auction</a>
            <a href="#">Reports</a>
            <a href="#">Settings</a>
            <a href="#">Help</a>
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
    </script>

</body>
</html>