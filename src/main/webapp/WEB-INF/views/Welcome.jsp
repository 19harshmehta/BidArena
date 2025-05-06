<%@ include file="Layout.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="ISO-8859-1">
    <title>Dashboard | BidArena</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <style>
        body {
            font-family: Arial, sans-serif;
        }

        h1, h4 {
            margin-left: 20px;
        }

        .cards-container {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            padding: 20px;
            justify-content: center;
        }

        .auction-card {
            width: 400px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            transition: transform 0.2s;
        }

        .auction-card:hover {
            transform: scale(1.03);
        }

        .auction-card h3 {
            color: #0d6efd;
            margin-bottom: 10px;
        }

        .auction-card p {
            margin: 6px 0;
            display: flex;
            flex-direction: row;
            font-size: 14px;
        }

        .card-buttons1 {
            margin-top: 20px;
            display: flex;
            flex-direction: row;
            gap: 10px;
        }
        
        .card-buttons2 {
            margin-top: 10px;
            display: flex;
            flex-direction: row;
            gap: 10px;
        }
        
        .wid{
        	width:240px;
        }
                
        .flex-btn{
        	display: flex;
        	flex-direction: column;
        }

        .download-btn {
            background-color: #007bff;
            color: white;
            padding: 8px 12px;
            font-size: 14px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            text-decoration: none;
            text-align: center;
        }

        .download-btn:hover {
            opacity: 0.9;
        }

        .start-btn { background-color: #198754; }
        .unsold-btn { background-color: #0dcaf0; }
        .end-btn { background-color: #dc3545; }
        .details-btn { background-color: #6f42c1; }
    </style>
</head>
<body>
    <!-- Main Content -->
    <div class="main-content">
        <h1>Welcome <%= user.getUsername() %>,</h1><br>
        <h4>This is your Dashboard</h4><br><br>

        <%
            List<AuctionEntity> auctions = (List<AuctionEntity>) session.getAttribute("auctions");
        %>

        <h2 style="margin-left: 20px;">Your Auctions</h2><br>

        <% if (auctions != null && !auctions.isEmpty()) { %>
            <div class="cards-container">
                <% for (AuctionEntity auction : auctions) { %>
                    <div class="auction-card">
                        <h3><%= auction.getLeagueName() %></h3>
                        <p><b>Auction Code :</b> <span style="padding-left: 40px;"><%= auction.getAuctionCode() %></span></p>
                        <p><b>Created On:</b> <span style="padding-left: 59px;"><%= auction.getCreatedAt() %></p>
                        <p><b>Status:</b> <span style="padding-left: 90px;"><%= auction.getStatus() %></p>

						<div class="flex-btn">
                        <div class="card-buttons1">
                            <a href="#" onclick="startAuction(<%= auction.getAuctionId() %>)" class="download-btn start-btn wid">Start Auction</a>
                            <a href="#" onclick="startUnsold(<%= auction.getAuctionId() %>)" class="download-btn unsold-btn wid">Start Unsold</a>
                            <a href="#" onclick="endAuction(<%= auction.getAuctionId() %>)" class="download-btn end-btn wid">End Auction</a>
                        </div>
                        <div class="card-buttons2">
                            <a href="${pageContext.request.contextPath}/report/download?auctionId=<%=auction.getAuctionId() %>" class="download-btn wid">Download Report</a>
                            <a href="viewdetails?auctionId=<%=auction.getAuctionId()%>" class="download-btn details-btn wid">View Details</a> 
                            <a href="uploaddata?auctionId=<%=auction.getAuctionId()%>" class="download-btn details-btn wid">Add Data</a> 
                        </div>
                    	</div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <p style="text-align:center;">No auctions found.</p>
        <% } %>
    </div>

    <script>     
        function startAuction(auctionId) {
            window.location.href = "startAuction?id=" + auctionId;
        }

        function startUnsold(auctionId) {
            window.location.href = "startAuction?id=" + auctionId;
        }

        function endAuction(auctionId) {
            console.log("Auction ID:", auctionId);
            if (confirm("Are you sure you want to end this auction?")) {
                fetch("/endAuction?id=" + auctionId, { method: 'POST' })
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