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
            left:-10px;
            z-index: 1000;
            
        }
        .top-nav .brand {
            color: white;
            font-size: 30px;
            font-weight: bold;
            letter-spacing: 2px;
            margin-left: 40px;
        }
    	
        body { 
        	font-family: Arial, sans-serif;
        	
        	text-align: center;
        	background: #EDF2FF;
        }
        
        .container {
        	display: flex; 
        	gap: 20px; 
        	justify-content: center;
        	margin-top:100px;
        }
        
        .panel { 
        	background-color: white;
        	height: 700px;
        	width: 45%;
        	padding: 10px; 
        	border-radius: 8px; 
        	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); 
        }
            
        h1 { 
        	color: #5596fc; 
        	margin-top: 30px;
        	font-weight: bolder;
        	font-size: 40px;
        }
        
        .player-info-vertical-scroll {
		    max-height: 45px; /* adjust height */
		    overflow-y: auto;
		    
		    /* hide scrollbar for Webkit (Chrome, Safari) */
		    scrollbar-width: none; /* Firefox */
		    -ms-overflow-style: none; /* IE and Edge */
		}
		
		.player-info-vertical-scroll::-webkit-scrollbar {
		    display: none; /* Chrome, Safari */
		}
		
		
		.right-player-info-vertical-scroll {
		    max-height: 480px; /* adjust height */
		    overflow-y: auto;
		    
		    /* hide scrollbar for Webkit (Chrome, Safari) */
		    scrollbar-width: none; /* Firefox */
		    -ms-overflow-style: none; /* IE and Edge */
		}
		
		.player-info-vertical-scroll::-webkit-scrollbar {
		    display: none; /* Chrome, Safari */
		}

        
        .bid-display { 
        	font-size: 20px; 
        	font-weight: bold; 
        	color: #d32f2f; 
        }
        
        .bid-buttons {
        	border: none;
        	border-radius: 20px;
        	padding: 15px 10px;
        	margin-top: -10px;
        	background: #f1f1f1;
        }
        
        .bid-buttons p{
        	margin-top: -5px;
        	color: black;
        	font-weight: bold;
        	font-size: 20px;
        }
        
        .bid-buttons button { 
        	padding: 8px 12px;
        	width: 100px; 
        	border: none; 
        	margin: 0 5px;
        	font-weight:bold;
        	border-radius: 5px;
        	cursor: pointer; 
        	background-color: #ff9f00;
        }
        
        .bid-buttons button:hover { 
        	transform: scale(1.03);
        }
        
        .team-select button { 
	        margin: 5px; 
	        padding: 8px 12px; 
	        border: none; 
	        background-color: #007bff;
	        color: white; 
	        font-weight:bold;
	        border-radius: 5px; 
        }
        
        .team-select button:hover { 
	        transform: scale(1.03);
        }
        
        .finalize-button { 
        	background-color: #28a745; 
        	color: white; 
        	font-weight: bold;
        	padding: 10px; 
        	width: 200px;
        	cursor: pointer;
        	border: 1px solid black; 
        	border-radius: 5px; 
        	margin-top: 10px; 
        	margin: 0 5px;
        }
        
        .finalize-button:hover{
        	transform: scale(1.03);
        }
        
        .bottom-panel {
		    background-color: #f1f1f1;
		    padding: 20px 10px;
		    border: 0;
		    border-radius: 20px;
		    margin-top: 38px;
		}
		
		.bottom-panel h2 {
		    margin-bottom: 10px;
		    margin-top: 0;
		}
    	
    	.team-list { 
    		margin-bottom: 30px; 
    	}
        
        .team-item {
            display: flex; 
            justify-content: space-between;
            padding: 8px;
            border-bottom: 1px solid #ddd;
        }
    </style>
</head>

<body>
<!--<audio id="soldSound" src="resources/static/assets/sound/ipl_tune.mp3" preload="auto"></audio>-->	
    <div class="top-nav">
		<div class="brand"><%= auction.getLeagueName() %></div>
	</div>
    <div class="container">
        <!-- Left Panel -->
        <div class="panel">
        <%if(currentPlayer != null){ %>
            <%
		    String imageUrl = currentPlayer.getImageUrl();
            //out.println("Image URL from PlayerEntity: " + imageUrl);
            String fileId = null;

            int idStartIndex = imageUrl.indexOf("id=");
            if (idStartIndex != -1) {
              fileId = imageUrl.substring(idStartIndex + 3);
            }

            if (fileId != null) {
              //out.println("Extracted File ID: " + fileId);
              // You can now use the 'fileId' variable
            } else {
              //out.println("Could not extract the File ID from the URL.");
            }
%>
<!--<img id="playerImage" src="https://drive.google.com/uc?id=<%= fileId %>" alt="Player Image" width="150" height="150" />-->
            <img src="/assets/players/one.jpeg" width="300px;" alt="Player Image"> 
    <!--        <img src="https://drive.google.com/uc?export=view&id=1Kf707AOu12Ct16BYh0W0xVrYf9FODVl6"width="300px;" alt="Player Image">-->
			
			    <p><strong>Name:</strong> <%= currentPlayer.getName() %></p>
			    <p><strong>Age:</strong> <%= currentPlayer.getAge() %></p>
			    <p>Image URL: <%= currentPlayer.getImageUrl() %></p>
			<div class="player-info-vertical-scroll">
			    <p><strong>Description:</strong> <%= currentPlayer.getSkills() %></p>
			</div>
			    <p><strong>Batting:</strong> <%= currentPlayer.getBatting() %></p>
			    <p><strong>Bowling:</strong> <%= currentPlayer.getBalling() %></p>
			    <p><strong>Wicket Keeping:</strong> <%= currentPlayer.getWicketkeeper() %></p>
			    <p class="bid-display"><strong>Current Bid:</strong> <span id="currentBid"><%= auction.getBasePrice() %></span></p>
			
			
            <audio id="soldSound" src="/assets/sound/ipl_tune.mp3" preload="auto"></audio>

			<div id="soldStamp" style="
			    position: absolute;
			    top: 150px;
			    left: 60px;
			    font-size: 64px;
			    font-weight: bold;
			    color: green;
			    transform: scale(0.5) rotate(-20deg);
			    opacity: 0;
			    transition: all 0.6s ease-in-out;
			    border: 3px solid green;
			    z-index: 1000;">SOLD</div>
            
            <div id="unsoldStamp" style="
			    position: absolute;
			    top: 150px;
			    left: 35px;
			    font-size: 64px;
			    font-weight: bold;
			    color: red;
			    transform: scale(0.5) rotate(-20deg);
			    opacity: 0;
			    transition: all 0.6s ease-in-out;
			    border: 3px solid red;
			    z-index: 1000;">UNSOLD</div>

            <div class="bid-buttons">
            	<p>Raise Bid</p>
                <button onclick="increaseBid(100)">+100</button>
                <button onclick="increaseBid(200)">+200</button>
                <button onclick="increaseBid(500)">+500</button>
                <button onclick="increaseBid(1000)">+1000</button>
            </div>
        </div>
		
        <!-- Right Panel -->
        <div class="panel">
        <div class="right-player-info-vertical-scroll">
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
	         </div>
	         
	         <!-- Bottom Section -->
		    <div class="bottom-panel">
		        <h2>Select Team</h2>
		        <div class="team-select" id="teamSelect">
		            <% for (TeamEntity team : teams) { %>
		                <button onclick="selectTeam('<%= team.getTeamId() %>')"><%= team.getTeamName() %></button>
		            <% } %>
		        </div>
		        <button class="finalize-button" onclick="finalizeBid()">Sold</button>
		        <button class="finalize-button" style="background-color: #dc3545;" onclick="markUnsold()">Unsold</button>
		    </div>
    	</div>

    <script>
        let currentBid = <%= auction.getBasePrice() %>;
        let selectedTeam = null;
        let auctionedPlayers = JSON.parse(localStorage.getItem("auctionedPlayers")) || [];

        function markUnsold() {
        	const unsoldStamp = document.getElementById("unsoldStamp");

            // Show animation
            unsoldStamp.style.opacity = 1;
            unsoldStamp.style.transform = "scale(1.2) rotate(-20deg)";
            unsoldStamp.style.transition = "all 0.6s ease-in-out";

            setTimeout(() => {
                unsoldStamp.style.transform = "scale(1) rotate(-20deg)";
            }, 100);

            // Wait for animation, then hide and reload
            setTimeout(() => {
                unsoldStamp.style.opacity = 0;
                window.location.reload(); 
            }, 3000); // 3 seconds delay 
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

            // Update Wallet Balance in the Frontend Immediately
            updateWalletDisplay(selectedTeam, currentBid);

            //Start: Animation + Sound
            const soldSound = document.getElementById("soldSound");
            const soldStamp = document.getElementById("soldStamp");

            if (soldSound && soldStamp) {
                soldSound.play(); // Play sold sound

                soldStamp.style.opacity = 1;
                soldStamp.style.transform = "scale(1.2) rotate(-20deg)";
                setTimeout(() => {
                    soldStamp.style.transform = "scale(1) rotate(-20deg)";
                }, 150);

                // Wait for animation to finish, then continue logic
                setTimeout(() => {
                    soldStamp.style.opacity = 0;

                    // Proceed with player reload or backend sync
                    if (auctionedPlayers.length >= 1) {
                        sendToBackend();
                    } else {
                        window.location.reload();
                    }

                }, 3000);
            } else {
                // Fallback: continue logic if sound or stamp not found
                if (auctionedPlayers.length >= 1) {
                    sendToBackend();
                } else {
                    window.location.reload();
                }
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