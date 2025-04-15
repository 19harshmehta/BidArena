<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<%@ page import="com.SE.entity.AuctionEntity" %>

<!-- DataTables CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css">

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>


<%@ include file="Layout.jsp" %>

<div style="padding: 20px;">
    <h1 style="margin-top: 20px; margin-bottom: 40px;">Your Created Auctions</h1>

    <%
        List<AuctionEntity> userAuctions = (List<AuctionEntity>) request.getAttribute("userAuctions");
    %>

    <table id="auctionTable" class="display responsive nowrap" style="width:100%">
        <thead>
            <tr>
                <th>Auction ID</th>
                <th>Auction Code</th>
                <th>League Name</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
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
            }
        %>
        </tbody>
    </table>

    <div style="margin-top: 20px;">
        <a href="/welcome" style="text-decoration:none; background:#007bff; color:white; padding:10px 20px; border-radius:5px;">Back to Home</a>
    </div>
</div>

<script>
    $(document).ready(function() {
        $('#auctionTable').DataTable({
            responsive: true,
            pageLength: 5,
            lengthMenu: [5, 10, 25, 50],
            columnDefs: [
                { orderable: false, targets: 4 } // Make "Actions" column unsortable
            ]
        });
    });
</script>