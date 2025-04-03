<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Collections"%>
<%@page import="com.SE.entity.TeamEntity"%>
<%@page import="com.SE.entity.PlayerEntity"%>
<%@page import="com.SE.entity.AuctionEntity"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    AuctionEntity auction = (AuctionEntity) request.getAttribute("auction");
    List<PlayerEntity> players = (List<PlayerEntity>) request.getAttribute("players");
    List<TeamEntity> teams = (List<TeamEntity>) request.getAttribute("teams");

    // Retrieve the list of auctioned player IDs from session
    List<Integer> auctionedPlayerIds = (List<Integer>) session.getAttribute("auctionedPlayerIds");

    if (auctionedPlayerIds == null) {
        auctionedPlayerIds = new ArrayList<>();
    }

    // Create a new list to store remaining players who have not been auctioned
    List<PlayerEntity> remainingPlayers = new ArrayList<>();
    for (PlayerEntity player : players) {
        if (!auctionedPlayerIds.contains(player.getPlayerId())) {
            remainingPlayers.add(player);
        }
    }

    PlayerEntity currentPlayer = null;

    // If there are still players left to be auctioned, select one randomly
    if (!remainingPlayers.isEmpty()) {
        Collections.shuffle(remainingPlayers);
        currentPlayer = remainingPlayers.get(0);

        // Mark this player as auctioned
        auctionedPlayerIds.add(currentPlayer.getPlayerId());
        session.setAttribute("auctionedPlayerIds", auctionedPlayerIds);
    }else{
    	auctionedPlayerIds.clear();
    }
   System.out.println(auctionedPlayerIds);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auction Page</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; text-align: center; }
        .container { display: flex; gap: 20px; justify-content: center; margin-top: 30px; }
        .panel { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
        h2 { color: #ff9800; }
        .bid-display { font-size: 20px; font-weight: bold; color: #d32f2f; }
        .bid-buttons button { margin: 5px; padding: 8px 12px; border: none; cursor: pointer; }
        .team-select button { margin: 5px; padding: 8px 12px; border: none; background-color: #007bff; color: white; border-radius: 5px; }
        .finalize-button { background-color: #28a745; color: white; padding: 10px; cursor: pointer; border-radius: 5px; margin-top: 10px; }
    	 .team-list { margin-bottom: 20px; }
        .team-item {
            display: flex; justify-content: space-between;
            padding: 8px; border-bottom: 1px solid #ddd;
        }
    </style>
</head>

<body>
    <div class="container">
        <!-- Left Panel -->
        <div class="panel">
        <%if(currentPlayer != null){ %>
            <h2><%= auction.getLeagueName() %></h2>
            <img src="<%= currentPlayer.getImageUrl() %>" width="100" alt="Player Image">
            <p><strong>Name:</strong> <%= currentPlayer.getName() %></p>
            <p><strong>Age:</strong> <%= currentPlayer.getAge() %></p>
            <p><strong>Batting:</strong> <%= currentPlayer.getBatting() %></p>
            <p><strong>Bowling:</strong> <%= currentPlayer.getBalling() %></p>
            <p><strong>Wicket Keeping:</strong> <%= currentPlayer.getWicketkeeper() %></p>
            <p class="bid-display">Current Bid:  <span id="currentBid"><%= auction.getBasePrice() %></span></p>
            <h3>Raise Bid</h3>
            <div class="bid-buttons">
                <button onclick="increaseBid(100)">+100</button>
                <button onclick="increaseBid(200)">+200</button>
                <button onclick="increaseBid(500)">+500</button>
                <button onclick="increaseBid(1000)">+1000</button>
            </div>
        </div>
		
        <!-- Right Panel -->
        <div class="panel">
        <div class="team-list" id="teamList">
                <% for (TeamEntity team : teams) { %>
                    <div class="team-item">
                    <%if(team.getWallet() > (auction.getWalletPerTeam() * 0.2)){  %>
                        <span><%=team.getTeamName()%></span>
                        <span>  <span class="wallet" data-team="<%=team.getTeamId()%>"><%=team.getWallet()%></span></span>
                    <%} else{%>
                    	<span><%=team.getTeamName()%></span>
                        <span>  <span style="background-color: red;" class="wallet" data-team="<%=team.getTeamId()%>"><%=team.getWallet()%></span></span>
                    <%} %>
                    </div>
                <% } %>
         </div>
            <h3>Select Team</h3>
            <div class="team-select" id="teamSelect">
                <% for (TeamEntity team : teams) { %>
                    <button onclick="selectTeam('<%= team.getTeamId() %>')"><%= team.getTeamName() %></button>
                <% } %>
            </div>
            <button class="finalize-button" onclick="finalizeBid()">Finalize Bid</button>
            <button class="finalize-button" style="background-color: #dc3545;" onclick="markUnsold()">Unsold</button> 
        </div>
    </div>

    <script>
        let currentBid = <%= auction.getBasePrice() %>;
        let selectedTeam = null;
        let auctionedPlayers = JSON.parse(localStorage.getItem("auctionedPlayers")) || [];

        function markUnsold() {
            window.location.reload(); 
        }

        function increaseBid(amount) {
            currentBid += amount;
            document.getElementById("currentBid").textContent = currentBid;
        }

        function selectTeam(teamId) {
            selectedTeam = teamId;
            document.querySelectorAll(".team-select button").forEach(btn => btn.style.background = "#007bff");
            event.target.style.background = "#ff9800";
        }
        

        function finalizeBid() {
            if (!selectedTeam) {
                alert("Please select a team before finalizing the bid.");
                return;
            }

            let playerData = {
                playerId: <%= currentPlayer.getPlayerId() %>,
                soldToTeam: selectedTeam,
                soldPrice: currentBid
            };

            // Store in local storage
            auctionedPlayers.push(playerData);
            localStorage.setItem("auctionedPlayers", JSON.stringify(auctionedPlayers));

         // **Update Wallet Balance in the Frontend Immediately**
            updateWalletDisplay(selectedTeam, currentBid);
            
            // Check if 10 players are stored, then send to backend
            if (auctionedPlayers.length >= 1 ) {
                sendToBackend();
            } else {
                window.location.reload(); // Load new player
            }
        }
        
        function updateWalletDisplay(teamId, bidAmount) {
            let walletSpan = document.querySelector(`.wallet[data-team="${teamId}"]`);
            if (walletSpan) {
                let currentBalance = parseInt(walletSpan.textContent);
                walletSpan.textContent = currentBalance - bidAmount;
            }
        }

        function sendToBackend() {
            fetch('/saveAuctionedPlayers', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(auctionedPlayers)
            }).then(response => {
                if (response.ok) {
                    localStorage.removeItem("auctionedPlayers"); // Clear storage after saving
                    window.location.reload(); // Start new batch
                } else {
                    alert("Error saving auction data.");
                }
            });
        }
    </script>
<%}else{ %>
		<p>No players left</p>
		<script>
		window.location.href = "/welcome";
		</script>
<% }%>


</body>
</html>