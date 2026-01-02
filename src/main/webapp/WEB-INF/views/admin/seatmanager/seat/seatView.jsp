<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="static/assets/css/seat.css">
</head>
<body>

<div class="admin-seat-content">
    <div class="admin-filter-bar">
        <div class="filter-group">
            <label>공연:</label>
            <select id="perfSelect">
                <option value="">-- 공연 선택 --</option>
                <c:forEach var="work" items="${workList}">
                    <option value="${work.work_id}">${work.work_title}</option>
                </c:forEach>
            </select>
        </div>
        <button type="button" class="admin-btn" style="width:auto; margin:0; background:#007bff;">좌석도 조회</button>
    </div>

    <div class="admin-seat-wrapper">
        <div class="seat-map-container" id="seatContainer">
            <div style="position: absolute; width:100%; top:10px; text-align:center; color:#555; font-weight:bold;">STAGE</div>
            
            <c:forEach var="rs" items="${roundSeatList}">
                <img src="${rs.on_img_url}" 
                     class="seat-box" 
                     id="seat-${rs.seat_id}"
                     /* DB의 seat_x, seat_y를 inline style로 적용하여 위치 고정 */
                     style="left: ${rs.seat_x}px; top: ${rs.seat_y}px;"
                     
                     /* 자바스크립트 제어를 위한 데이터 바인딩 */
                     data-seat-name="${rs.seat_name}"
                     data-grade-name="${rs.grade_name}"
                     data-status="${rs.status}"
                     onclick="handleSeatClick('${rs.seat_id}')">
            </c:forEach>
        </div>

        <div class="management-side-panel">
            <h4 style="margin-top:0; border-bottom:1px solid #555; padding-bottom:10px;">관리자 컨트롤</h4>
            
            <div id="selection-display" style="background:#222; padding:15px; margin:20px 0; border-radius:5px;">
                <p>좌석명: <strong id="selName" style="color:#007bff">-</strong></p>
                <p>현재 등급: <span id="selGrade">-</span></p>
                <p>DB 상태: <span id="selStatus">-</span></p>
            </div>

            <p style="font-size:12px; color:#888;">상태 강제 변경:</p>
            <button class="admin-btn" style="background:#28a745" onclick="processStatus('AVAILABLE')">예매가능(AVAILABLE)</button>
            <button class="admin-btn" style="background:#ffc107; color:#000" onclick="processStatus('PREEMPTED')">임시홀딩(PREEMPTED)</button>
            <button class="admin-btn" style="background:#dc3545" onclick="processStatus('RESERVED')">강제예약(RESERVED)</button>
            <hr style="border:0.5px solid #555; margin:20px 0;">
            <button class="admin-btn" style="background:#666" onclick="processStatus('CANCELED')">예약취소(CANCELED)</button>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
let activeSeatId = null;

/**
 * [함수] 좌석 클릭 시 우측 패널에 상세 정보 표시
 */
function handleSeatClick(seatId) {
    activeSeatId = seatId;
    const $target = $("#seat-" + seatId);

    // 1. 시각적 선택 표시 (테두리 효과)
    $(".seat-box").removeClass("active-select");
    $target.addClass("active-select");

    // 2. 우측 패널 데이터 업데이트
    $("#selName").text($target.data("seat-name"));
    $("#selGrade").text($target.data("grade-name"));
    $("#selStatus").text($target.data("status"));
}

/**
 * [함수] 버튼 클릭 시 서버 DB(round_seat)의 상태를 업데이트
 */
function processStatus(newStatus) {
    if (!activeSeatId) {
        alert("먼저 관리할 좌석을 선택해 주세요.");
        return;
    }

    if (!confirm(activeSeatId + " 좌석을 " + newStatus + " 상태로 변경하시겠습니까?")) return;

    // Ajax를 통해 서버 컨트롤러에 업데이트 요청 전송
    $.ajax({
        url: "/admin/round_seat/update",
        method: "POST",
        data: {
            seat_id: activeSeatId,
            status: newStatus,
            round_id: "${roundId}" // 서버에서 넘겨받은 현재 회차 ID
        },
        success: function(response) {
            alert("DB 업데이트 성공!");
            // 실제 반영을 위해 페이지를 새로고침하거나 
            // 해당 좌석의 data-status 값과 이미지를 동적으로 교체합니다.
            location.reload(); 
        },
        error: function() {
            alert("업데이트 중 오류가 발생했습니다.");
        }
    });
}
</script>
</body>
</html>