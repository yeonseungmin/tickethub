<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.ch.tickethub.dto.SeatGrade, com.ch.tickethub.dto.Work" %>
<%
    String contextPath = request.getContextPath();
    String roundId = request.getParameter("round_id");

    Work work = (Work)request.getAttribute("work");
    List<SeatGrade> seatGradeList = (List<SeatGrade>)request.getAttribute("seatGradeList");

    int basePrice = (work != null) ? work.getWork_price() : 0;
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
        var BASE_PRICE = <%= basePrice %>;

        var GRADE_SURCHARGE_MAP = {
        	<% if(seatGradeList != null) {
                  for(int i=0; i < seatGradeList.size(); i++) {
                      SeatGrade g = seatGradeList.get(i);%>
                "<%= g.getGrade_name().toLowerCase()%>": <%= g.getSurcharge()%><%= (i < seatGradeList.size() - 1) ? "," : "" %>
            <% }} %>
        };
        console.log("DB 기반 기본가:", BASE_PRICE);
        console.log("DB 기반 할증료 테이블:", GRADE_SURCHARGE_MAP);
    </script>
    <script src="<%=contextPath%>/static/assets/js/seatPopup.js?v=<%=System.currentTimeMillis()%>"></script>
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
            
            <hr> 
            <div class="seat-legend">
                <div class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/available_vip.jpg"> VIP</div>
                <div class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/available_r.jpg"> R석</div>
                <div class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/available_s.jpg"> S석</div>
                <div class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/available_a.jpg"> A석</div>
            </div>
        
            <hr> 
            <div class="seat-legend">
                <div class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/sold.jpg"> 판매완료</div>
                <div class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/preempted.jpg"> 결제진행중</div>
            </div>
        </div>
        <hr> 
        <div class="person-count-selection">
            <h4>관람 인원 선택</h4>
            <select id="personCount" class="nav-select">
                <option value="1">1명</option>
                <option value="2">2명</option>
                <option value="3">3명</option>
                <option value="4">4명</option>
            </select>
        </div>
        <hr> 
        <div class="total-price">
            <span>총 금액</span>
            <strong id="total-amount">0</strong>원
        </div>
        <button class="btn-next-step" onclick="goToPayment()">결제하기</button>
    </div>
</div>

<script>
	/* [3] 페이지 실행 시 초기화 루틴 */
	$(document).ready(function() {
	    if(currentRoundId && currentRoundId !== 'null' && currentRoundId !== '') {
	        initUserReservation(currentRoundId);
	    } else {
	        alert("회차 정보가 없습니다.");
	    }
	
	    // 인원수 변경 시 선택 상태 리셋
	    $('#personCount').on('change', function() {
	        if(typeof resetSelection === 'function') {
	            resetSelection();
	            updateUserSelectionUI();
	        }
	    });
	});
</script>
</body>
</html>