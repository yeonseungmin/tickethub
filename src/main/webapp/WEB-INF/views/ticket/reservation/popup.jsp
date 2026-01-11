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
  <!--   <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> -->
    <script>
	    var contextPath = '<%=contextPath%>';
	    var currentRoundId = '<%=roundId%>';
        window.selectedSeatIds = []; 
    </script>
</head>
<body class="user-reservation-page">

<div class="reservation-container">
    <div class="seat-selection-section">
        <div class="stage-label">STAGE</div>
        
        <div id="seatArea"></div>
        
        <div class="seat-legend">
            <div class="legend-group">
                <span class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/available_vip.jpg"> VIP</span>
                <span class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/checked_available_vip.jpg"> 선택</span>
            </div>
            <div class="legend-group">
                <span class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/available_r.jpg"> R석</span>
                <span class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/checked_available_r.jpg"> 선택</span>
            </div>
            <div class="legend-group">
                <span class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/available_s.jpg"> S석</span>
                <span class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/checked_available_s.jpg"> 선택</span>
            </div>
            <div class="legend-group">
                <span class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/available_a.jpg"> A석</span>
                <span class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/checked_available_a.jpg"> 선택</span>
            </div>
            <span class="legend-item"><img src="<%=contextPath%>/static/assets/seatImg/sold.jpg"> 판매완료</span>
        </div>
    </div>

    <div class="info-sidebar">
        <div class="selected-info-box">
            <h4>선택 좌석</h4>
            <div id="selected-seats-list">
                <p class="empty-msg">좌석을 선택해 주세요.</p>
            </div>
            <hr>
            <div class="total-price">
                <span>총 금액</span>
                <strong id="total-amount">0</strong>원
            </div>
        </div>
        <button class="btn-next-step" onclick="goToPayment()">결제하기</button>
    </div>
</div>

<script>
    $(document).ready(function() {
        if(currentRoundId) loadUserSeatLayout(currentRoundId);
    });

    function loadUserSeatLayout(roundId) {
        // 서버에서 좌석 리스트를 가져옵니다 (Mapper 에러 해결 후 정상 작동)
        $.get(contextPath + '/admin/roundseat/list', { round_id: roundId }, function(list) {
            renderUserSeatMap(list);
        });
    }

    function renderUserSeatMap(seatList) {
        var $container = $('#seatArea').empty();
        var groups = {};

        // 1. 구역(Group) 데이터 추출 및 경계 계산
        seatList.forEach(function(seat) {
            if (!groups[seat.seat_group_id]) {
                groups[seat.seat_group_id] = {
                    name: seat.group_name || '구역',
                    minX: Infinity, minY: Infinity, maxX: -Infinity, maxY: -Infinity
                };
            }
            // seatgrade.jsp와 동일한 좌표 계산식 적용
            var curX = seat.pos_x + (seat.seat_x.charCodeAt(0) - 65) * seat.col_gap;
            var curY = seat.pos_y + (seat.seat_y - 1) * seat.row_gap;
            
            var g = groups[seat.seat_group_id];
            if (curX < g.minX) g.minX = curX; if (curY < g.minY) g.minY = curY;
            if (curX > g.maxX) g.maxX = curX; if (curY > g.maxY) g.maxY = curY;
        });

        // 2. 구역 경계선 박스 렌더링
        Object.keys(groups).forEach(function(id) {
            var g = groups[id];
            $('<div class="group-boundary-box"></div>')
                .css({
                    left: (g.minX - 15) + 'px', 
                    top: (g.minY - 15) + 'px',
                    width: (g.maxX - g.minX + 55) + 'px', 
                    height: (g.maxY - g.minY + 55) + 'px'
                })
                .append($('<div class="group-name-label"></div>').text(g.name))
                .appendTo($container);
        });

        // 3. 개별 좌석 렌더링
        seatList.forEach(function(seat) {
            var finalX = seat.pos_x + (seat.seat_x.charCodeAt(0) - 65) * seat.col_gap;
            var finalY = seat.pos_y + (seat.seat_y - 1) * seat.row_gap;
            var grade = (seat.grade_name || "A").toLowerCase();
            
            var $seat = $('<div class="admin-seat"></div>')
                .attr({ 'data-seat-id': seat.round_seat_id, 'data-grade': grade })
                .css({ left: finalX + 'px', top: finalY + 'px' });

            // 예약 상태(is_reserved) 확인
            if (seat.is_reserved === 'Y') {
                $seat.addClass('reserved')
                     .css('background-image', 'url(' + contextPath + '/static/assets/seatImg/sold.jpg)');
            } else {
                $seat.addClass('available')
                     .css('background-image', 'url(' + contextPath + '/static/assets/seatImg/available_' + grade + '.jpg)')
                     .on('click', function() { toggleSeatSelection($(this), seat, grade); });
            }
            $container.append($seat);
        });
    }

    function toggleSeatSelection($el, seat, grade) {
        var seatId = seat.round_seat_id;
        var index = window.selectedSeatIds.indexOf(seatId);

        if (index > -1) {
            // 선택 해제
            window.selectedSeatIds.splice(index, 1);
            $el.removeClass('selected').css('background-image', 'url(' + contextPath + '/static/assets/seatImg/available_' + grade + '.jpg)');
        } else {
            // 선택 (최대 4매)
            if(window.selectedSeatIds.length >= 4) return alert("최대 4좌석까지 선택 가능합니다.");
            window.selectedSeatIds.push(seatId);
            $el.addClass('selected').css('background-image', 'url(' + contextPath + '/static/assets/seatImg/checked_available_' + grade + '.jpg)');
        }
        updateUI();
    }

    function updateUI() {
        var $list = $('#selected-seats-list').empty();
        if(window.selectedSeatIds.length === 0) {
            $list.append('<p class="empty-msg">좌석을 선택해 주세요.</p>');
            return $('#total-amount').text('0');
        }
        window.selectedSeatIds.forEach(function(id) {
            $list.append('<div class="selected-item">좌석 ID: ' + id + '</div>');
        });
        // 합계 금액 계산 로직은 필요에 따라 추가
    }

    function goToPayment() {
        if (window.selectedSeatIds.length === 0) return alert("좌석을 선택해주세요.");
        location.href = contextPath + "/ticket/payment?round_id=" + currentRoundId + "&seats=" + window.selectedSeatIds.join(",");
    }
</script>
</body>
</html>