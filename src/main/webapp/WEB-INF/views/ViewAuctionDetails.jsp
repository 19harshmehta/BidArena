<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<%@ page import="com.SE.entity.TeamEntity" %>
<%@ page import="com.SE.entity.PlayerEntity" %>

<html>
<head>
    <title>Auction Report Summary</title>

    <!-- Style for clean layout -->
    <style>
        /* Global Styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #F2F6FF;
            padding: 20px;
            margin: 0;
        }

        h1 {
        	background: #a64bf4;
            background: linear-gradient(to right, #21d4fd, #b721ff, #21d4fd, #b721ff);
            color: white;
            padding: 15px 0;
            text-align: center;
        }

        h2 {
            color: #555;
        }

        h3 {
            color: #333;
            margin-top: 0;
        }

        .stats-container {
            background-color: #ffffff;
            border: 1px solid #ccc;
            padding: 20px;
            margin-bottom: 30px;
        }

        .stats-container ul {
            list-style: none;
        }

        .stats-container li {
            font-size: 16px;
            padding: 5px 0;
            margin-left: -38px;
            
        }

        .highlighted-players {
            display: flex;
            gap: 30px;
            margin-bottom: 30px;
        }

        .highlighted-player {
            flex: 1;
            padding: 15px;
            border-left: 5px solid;
        }

        .highest-player {
            background-color: #e8f5e9;
            border-color: green;
        }

        .lowest-player {
            background-color: #ffebee;
            border-color: red;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        table th, table td {
            padding: 8px;
            text-align: left;
            border: 1px solid #ddd;
        }

        table th {
            background-color: #f0f0f0;
        }

        .back-button {
            text-align: center;
            margin-top: 40px;
        }

        .back-button a {
            text-decoration: none;
            background-color: #007bff;
            color: white;
            padding: 12px 25px;
            border-radius: 5px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .highlighted-players {
                flex-direction: column;
                gap: 20px;
            }

            .highlighted-player {
                flex: unset;
                border-left: none;
                border-top: 5px solid;
            }

            .highlighted-player:first-child {
                border-top-color: green;
            }

            .highlighted-player:last-child {
                border-top-color: red;
            }

            table th, table td {
                font-size: 14px;
                padding: 10px;
            }

            .stats-container {
                padding: 15px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }

            h1 {
                font-size: 22px;
            }

            h2, h3 {
                font-size: 18px;
            }

            .stats-container {
                padding: 10px;
            }

            table th, table td {
                font-size: 12px;
                padding: 8px;
            }

            .back-button a {
                padding: 10px 20px;
            }
        }

    </style>
</head>
<body>

    <h1>Auction Report Summary</h1>

    <!-- Overall Stats -->
    <div class="stats-container">
        <h2>Overall Stats</h2>
        <ul>
            <li><strong>Total Players:</strong> <%= request.getAttribute("totalPlayers") %></li>
            <li><strong>Total Teams:</strong> <%= request.getAttribute("totalTeams") %></li>
            <li><strong>Sold Players:</strong> <%= request.getAttribute("soldPlayers") %></li>
            <li><strong>Unsold Players:</strong> <%= request.getAttribute("unsoldPlayers") %></li>
        </ul>
    </div>

    <!-- Highlighted Players -->
    <div class="highlighted-players">
        <div class="highlighted-player highest-player">
            <h3>Highest Bid Player</h3>
            <%
                PlayerEntity overallHighestBidPlayer = (PlayerEntity) request.getAttribute("overallHighestBidPlayer");
                if(overallHighestBidPlayer != null) {
            %>
                <p><strong><%= overallHighestBidPlayer.getName() %></strong> - &#8377; <%= overallHighestBidPlayer.getSoldPrice() %></p>
            <% } else { %>
                <p>Not Available</p>
            <% } %>
        </div>

        <div class="highlighted-player lowest-player">
            <h3>Lowest Bid Player</h3>
            <%
                PlayerEntity overallLowestBidPlayer = (PlayerEntity) request.getAttribute("overallLowestBidPlayer");
                if(overallLowestBidPlayer != null) {
            %>
                <p><strong><%= overallLowestBidPlayer.getName() %></strong> - &#8377; <%= overallLowestBidPlayer.getSoldPrice() %></p>
            <% } else { %>
                <p>Not Available</p>
            <% } %>
        </div>
    </div>

    <!-- Per Team Details -->
    <%
        List<TeamEntity> teams = (List<TeamEntity>) request.getAttribute("teams");
        Map<Integer, List<PlayerEntity>> teamPlayersMap = (Map<Integer, List<PlayerEntity>>) request.getAttribute("teamPlayersMap");
        Map<Integer, PlayerEntity> teamHighestBidPlayerMap = (Map<Integer, PlayerEntity>) request.getAttribute("teamHighestBidPlayerMap");
        Map<Integer, PlayerEntity> teamLowestBidPlayerMap = (Map<Integer, PlayerEntity>) request.getAttribute("teamLowestBidPlayerMap");

        for (TeamEntity team : teams) {
            List<PlayerEntity> playerList = teamPlayersMap.get(team.getTeamId());
            PlayerEntity highestPlayer = teamHighestBidPlayerMap.get(team.getTeamId());
            PlayerEntity lowestPlayer = teamLowestBidPlayerMap.get(team.getTeamId());
    %>

    <div class="stats-container">
        <u><h3>Team: <%= team.getTeamName() %></h3></u>
        <p><strong>Balance:</strong> &#8377; <%= team.getWallet() %></p>
        <p><strong>Players Bought:</strong> <%= playerList.size() %></p>
        <p style="color: green"><strong>Highest Bid:</strong>
            <%= highestPlayer != null ? highestPlayer.getName() + " (&#8377; " + highestPlayer.getSoldPrice() + ")" : "Not Available" %>
        </p>
        <p style="color: red;"><strong>Lowest Bid:</strong>
            <%= lowestPlayer != null ? lowestPlayer.getName() + " (&#8377; " + lowestPlayer.getSoldPrice() + ")" : "Not Available" %>
        </p>

        <!-- Player List Table -->
        <table>
            <tr>
                <th>Player Name</th>
                <th>Sold Price (&#8377;)</th>
            </tr>
            <%
                if (playerList != null && !playerList.isEmpty()) {
                    for (PlayerEntity player : playerList) {
            %>
                        <tr>
                            <td><%= player.getName() %></td>
                            <td><%= player.getSoldPrice() %></td>
                        </tr>
            <%      }
                } else {
            %>
                <tr>
                    <td colspan="2">No Players</td>
                </tr>
            <% } %>
        </table>
    </div>

    <% } %>

    <!-- Back to Home Button -->
    <div class="back-button">
        <a href="/reports">Back</a> &nbsp;&nbsp;&nbsp;
        <a href="/welcome">Home</a>
    </div>
    
</body>
</html>