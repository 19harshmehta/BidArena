<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<%@ page import="com.SE.entity.AuctionEntity" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Reports - Auctions</title>
</head>
<body>

<h1>Your Created Auctions</h1>

<%
    List<AuctionEntity> userAuctions = (List<AuctionEntity>) request.getAttribute("userAuctions");
%>

<table border="1" cellpadding="10">
    <tr>
        <th>Auction ID</th>
        <th>Auction Code</th>
        <th>League Name</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>

<%
    if(userAuctions != null && userAuctions.size() > 0) {
        for(AuctionEntity auction : userAuctions) {
%>
        <tr>
            <td><%= auction.getAuctionId() %></td>
            <td><%= auction.getAuctionCode() %></td>
            <td><%= auction.getLeagueName() %></td>
            <td><%= auction.getStatus() %></td>
            <td>
                <a href="/viewdetails?auctionId=<%= auction.getAuctionId() %>">View Details</a>
            </td>
        </tr>
<%
        }
    } else {
%>
        <tr>
            <td colspan="4">No Auctions Found!</td>
        </tr>
<%
    }
%>
</table>

<a href="/welcome">Back to Home</a>

</body>
</html>