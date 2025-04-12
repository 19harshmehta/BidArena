<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<%@ page import="com.SE.entity.TeamEntity" %>
<%@ page import="com.SE.entity.PlayerEntity" %>

<html>
<head>
    <title>Auction Details</title>
</head>
<body>

<h1>Auction Report</h1>

<%
    Integer totalPlayers = (int) request.getAttribute("totalPlayers");
	Integer totalTeams = (int) request.getAttribute("totalTeams");
	Integer soldPlayers = (int) request.getAttribute("soldPlayers");
	Integer unsoldPlayers = (int) request.getAttribute("unsoldPlayers");
    List<TeamEntity> teams = (List<TeamEntity>) request.getAttribute("teams");
    Map<Integer, List<PlayerEntity>> teamPlayersMap = (Map<Integer, List<PlayerEntity>>) request.getAttribute("teamPlayersMap");
    Map<Integer, PlayerEntity> teamHighestBidPlayerMap = (Map<Integer, PlayerEntity>) request.getAttribute("teamHighestBidPlayerMap");
    Map<Integer, PlayerEntity> teamLowestBidPlayerMap = (Map<Integer, PlayerEntity>) request.getAttribute("teamLowestBidPlayerMap");
    PlayerEntity overallHighestBidPlayer = (PlayerEntity) request.getAttribute("overallHighestBidPlayer");
    PlayerEntity overallLowestBidPlayer = (PlayerEntity) request.getAttribute("overallLowestBidPlayer");




%>

<h2>Total Players in Auction: <%= totalPlayers %></h2>
<h2>Total Teams in Auction: <%= totalTeams %></h2>
<h2>Sold Players: <%= soldPlayers %></h2>
<h2>Unsold Players: <%= unsoldPlayers %></h2>
<h2>Auction Highest Bid Player:</h2>
<%
    if(overallHighestBidPlayer != null) {
%>
    Player: <%= overallHighestBidPlayer.getName() %> 
    (  <%= overallHighestBidPlayer.getSoldPrice() %>)
<%
    } else {
%>
    Not Available
<%
    }
%>

<h2>Auction Lowest Bid Player:</h2>
<%
    if(overallLowestBidPlayer != null) {
%>
    Player: <%= overallLowestBidPlayer.getName() %> 
    (  <%= overallLowestBidPlayer.getSoldPrice() %>)
<%
    } else {
%>
    Not Available
<%
    }
%>

<hr>

<h2>Team Details</h2>

<%
    for (TeamEntity team : teams) {
        List<PlayerEntity> playerList = teamPlayersMap.get(team.getTeamId());
%>
    <h3>Team Name: <%= team.getTeamName() %></h3>
    <p>Balance:  <%= team.getWallet() %></p>
    <p>No. of Players: <%= playerList.size() %></p>
	<p>Highest Bid Player: 
<%
    PlayerEntity highestPlayer = teamHighestBidPlayerMap.get(team.getTeamId());
    if(highestPlayer != null) {
%>
    <%= highestPlayer.getName() %> (  <%= highestPlayer.getSoldPrice() %>)
<%
    } else {
%>
    Not Available
<%
    }
%>
</p>

<p>Lowest Bid Player: 
<%
    PlayerEntity lowestPlayer = teamLowestBidPlayerMap.get(team.getTeamId());
    if(lowestPlayer != null) {
%>
    <%= lowestPlayer.getName() %> (  <%= lowestPlayer.getSoldPrice() %>)
<%
    } else {
%>
    Not Available
<%
    }
%>
</p>
    <table style="width:50%">
        <tr>
            <th>Player Name</th>
            <th>Sold Amount</th>
        </tr>

<%
        if(playerList != null && playerList.size() > 0){
            for (PlayerEntity player : playerList) {
%>
                <tr>
                    <td><%= player.getName() %></td>
                    <td> <%= player.getSoldPrice() %></td>
                </tr>
<%
            }
        } else {
%>
            <tr>
                <td colspan="2">No Players</td>
            </tr>
<%
        }
%>
    </table>
    <hr>
<%
    }
%>

<a href="/welcome">Back to Home</a>

</body>
</html>