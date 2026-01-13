<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
    String roundId = request.getParameter("round_id");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>좌석 선택 | TicketHub</title>
    
    <link rel="stylesheet" href="<%=contextPath%>/static/assets/css/popup.css">
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        var contextPath = '<%=contextPath%>';
        var currentRoundId = '<%=roundId%>';
    </script>
    
    <script src="<%=contextPath%>/static/assets/js/seatPopup.js"></script>
</head>

<body class="user-reservation-page">
<div class="reservation-container">
    <div class="seat-selection-section">
        <div class="stage-label">STAGE</div>
        <div id="seatArea"></div>
    </div>
    
    <div class="info-sidebar">
        <div class="selected-info-box">
            <h4>선택 좌석</h4>
            <div id="selected-seats-list">
                <p class="empty-msg">좌석을 선택해 주세요.</p>
            </div>
            
            <hr> <div class="seat-legend">
		        <div class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/available_vip.jpg"> VIP</div>
		        <div class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/available_r.jpg"> R석</div>
		        <div class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/available_s.jpg"> S석</div>
		        <div class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/available_a.jpg"> A석</div>
		    </div>
		
		    <hr> <div class="seat-legend">
		        <div class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/sold.jpg"> 판매완료</div>
		        <div class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/preempted.jpg"> 결제진행중</div>
		    </div>
		</div>
            <div class="total-price">
                <span>총 금액</span>
                <strong id="total-amount">0</strong>원
            </div>
        <button class="btn-next-step" onclick="goToPayment()">결제하기</button>
    </div>
</div>

<script>
    $(document).ready(function() {
        console.log("JSP 준비 완료. 회차 ID:", currentRoundId);
        if(currentRoundId) {
            initUserReservation(currentRoundId);
        } else {
            alert("회차 정보가 없습니다.");
        }
    });
</script>
</body>
</html>