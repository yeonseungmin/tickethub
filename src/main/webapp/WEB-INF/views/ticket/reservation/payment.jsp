<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.ch.tickethub.dto.SeatDetail" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // 1. Model에서 데이터를 꺼내 자바 리스트로 캐스팅
    List<SeatDetail> seatList = (List<SeatDetail>)request.getAttribute("selectedSeatList");
	System.out.println("<div style='color:yellow; background:black; padding:10px;'>원본 데이터: " + seatList + "</div>");
    String formattedSeats = "";
    String formattedGrade = "";
    
    if (seatList != null && !seatList.isEmpty()) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < seatList.size(); i++) {
            SeatDetail s = seatList.get(i);
            
            // [중요] 필드명 확인: s.getSeat_x()가 안되면 s.getSeatX()를 시도해야 합니다.
            // 여기서는 사용자님이 앞서 언급하신 getSeat_x() 형식을 기준으로 작성합니다.
            String row = (s.getSeat_x() != null) ? s.getSeat_x() : "0";
            int num = s.getSeat_y(); 
            
            sb.append(row).append("열 ").append(num).append("번");
            if (i < seatList.size() - 1) sb.append(", ");
        }
        formattedSeats = sb.toString();
        
        // 2. 등급 가공 (대문자 변환)
        String grade = seatList.get(0).getGrade_name();
        if (grade != null) {
            formattedGrade = grade.toUpperCase() + " 석";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제 페이지</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/assets/css/payment.css">
</head>
<body>

<div class="container">
    <div class="main-content">
        <h2 class="title">이용 약관</h2>
        <div class="terms-box">
            <p><strong>제 1 조 (목적)</strong><br>본 약관은 티켓허브 제공 서비스 규정입니다.</p>
            <p><strong>제 2 조 (예매 및 취소)</strong><br>공연 전날까지만 취소 가능합니다.</p>
        </div>
        <div class="agree-section">
            <input type="checkbox" id="agree"> <label for="agree">약관에 동의합니다.</label>
        </div>
    </div> 

    <div class="sidebar">
        <h3>예매 정보 확인</h3>
        <div class="info-group">
            <p><strong>선택한 좌석:</strong> 
                <span class="seat-item"><%= formattedSeats %></span>
            </p>
            <p><strong>좌석 등급:</strong> 
                <span class="grade-text"><%= formattedGrade %></span>
            </p>
        </div>
        
        <hr>
        
        <div class="price-info">
		    <p>총 주문 금액: <fmt:formatNumber value="${totalAmount}"/> 원</p>
		    <p>등급 할인 (${benefitSummary}): 
		        <span style="color:red;">- <fmt:formatNumber value="${discountAmount}"/> 원</span>
		    </p>
		    <hr>
		    <h3 class="total-line">최종 결제 금액: <fmt:formatNumber value="${finalAmount}"/> 원</h3>
		</div>

        <button id="payBtn">결제하기</button>
    </div>
</div>

<script>
    document.getElementById('payBtn').onclick = function() {
        if(!document.getElementById('agree').checked) {
            alert('약관에 동의해주세요.');
            return;
        }

        // 고유 번호 생성
        const now = new Date();
        const dateStr = now.getFullYear() + 
                        String(now.getMonth() + 1).padStart(2, '0') + 
                        String(now.getDate()).padStart(2, '0');
        const randomStr = Math.floor(Math.random() * 1000000).toString().padStart(6, '0');
        const merchant_uid = "TH-" + dateStr + "-" + randomStr;

        // 서버에서 넘겨준 값 안전하게 변수에 담기
        const rId = "${roundId}";
        const sIds = "${seatIdsStr}";
        const amt = "${finalAmount}";
        const bId = "${benefitId}";
        const seatGradeId = "${selectedSeatList[0].seat_grade_id}";

        if(confirm('결제를 진행하시겠습니까?')) {
            // 줄바꿈 없이 한 줄로 연결하거나, 아래처럼 + 기호를 정확히 써야 합니다.
            location.href = 'completePayment?' + 
                            'round_id=' + rId + 
                            '&seats=' + sIds + 
                            '&amount=' + amt + 
                            '&benefitId=' + bId + 
                            '&orderId=' + merchant_uid +
                            '&seat_grade_id=' + seatGradeId;
        }
    };
</script>
</body>
</html>