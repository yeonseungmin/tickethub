<%@page import="com.ch.tickethub.dto.SeatGroup"%>
<%@page import="com.ch.tickethub.dto.Seat"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- 공통 헤더 CSS -->
<link rel="stylesheet" href="./inc/header.css">

<!-- 좌석 관리자 CSS -->
<link rel="stylesheet" href="/static/assets/css/seat.css">

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<div class="seat-option-bar">
    <div class="nav-group">
        <span class="nav-label">LOCATION</span>
        <select id="placeSelect" class="nav-select">
            <option value="">장소 선택</option>
            <c:forEach var="place" items="${placeList}">
                <option value="${place.place_id}">${place.place_name}</option>
            </c:forEach>
        </select>
    </div>

    <div class="nav-group">
        <span class="nav-label">PERFORMANCE</span>
        <select id="workSelect" class="nav-select">
            <option value="">공연 선택</option>
        </select>
    </div>

    <div class="nav-group">
        <span class="nav-label">ROUND</span>
        <select id="roundSelect" class="nav-select">
            <option value="">회차 선택</option>
        </select>
    </div>

    <button class="nav-load-btn" onclick="loadSeats()">
        <span style="margin-right:5px;">🔍</span> 좌석 불러오기
    </button>
</div>

<div class="admin-seat-wrapper">
    
    <div class="seat-map-container">
        <div style="text-align:center; color:#333; font-size:40px; letter-spacing:30px; margin-bottom:100px; font-weight:900;">
            STAGE
        </div>
        </div>

    <div class="management-side-panel">
        <h3 style="color:#007bff; margin-top:0;">Seat Control</h3>
        
        <div id="selection-info" style="background:#111; padding:15px; border-radius:8px; margin-bottom:20px; border:1px solid #333;">
            <p style="font-size:12px; color:#888;">선택 좌석: <span id="selName" style="color:#fff;">-</span></p>
            <p style="font-size:12px; color:#888;">상태: <span id="selState" style="color:#fff;">-</span></p>
        </div>

        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px; margin-bottom:30px;">
            <button class="admin-btn" style="background:#28a745" onclick="changeStatus('AVAILABLE')">AVAILABLE</button>
            <button class="admin-btn" style="background:#ffc107; color:#000" onclick="changeStatus('PREEMPTED')">PREEMPTED</button>
            <button class="admin-btn" style="background:#dc3545" onclick="changeStatus('RESERVED')">RESERVED</button>
            <button class="admin-btn" style="background:#6c757d" onclick="changeStatus('CANCELED')">CANCELED</button>
        </div>

        <div style="border-top:1px solid #444; padding-top:20px;">
            <p style="font-size:12px; color:#555; margin-bottom:10px;">좌석 자동 생성</p>
            <select id="groupSelect" class="nav-select" style="width:100%; margin-bottom:10px;">
                <option value="">구역 선택</option>
            </select>
            <div style="display:flex; gap:10px; margin-bottom:15px;">
                <input type="number" id="rowCount" placeholder="Rows" style="flex:1; background:#111; border:1px solid #444; color:#fff; padding:5px;">
                <input type="number" id="colCount" placeholder="Cols" style="flex:1; background:#111; border:1px solid #444; color:#fff; padding:5px;">
            </div>
            <button style="width:100%; padding:10px; background:#007bff; color:#fff; border:none; border-radius:4px; cursor:pointer;" onclick="createSeats()">생성 실행</button>
        </div>
    </div>
</div>
<script>
	let selectedSeatId = null;
	
	// 1. 구역 위치 저장 (드래그 앤 드롭 기능을 추가할 경우 사용)
	function savePosition(groupId, x, y) {
	    $.post("/seatgroup/updatePosition", {
	        seat_group_id: groupId,
	        pos_x: x,
	        pos_y: y
	    }, function(res) {
	        if(res === "success") console.log("위치가 저장되었습니다.");
	    });
	}
	
	// 2. 좌석 자동 생성 로직
	function createSeats() {
	    const groupId = $("#groupSelect").val();
	    const rows = $("#rowCount").val();
	    const cols = $("#colCount").val();
	
	    if (!groupId || !rows || !cols) {
	        alert("구역, 행, 열 정보를 모두 입력하세요");
	        return;
	    }
	
	    if (!confirm("물리적 좌석을 생성하시겠습니까?")) return;
	
	    // SeatController의 @PostMapping("/generate")와 연동
	    $.post("/admin/seat/generate", {
	        seat_group_id: groupId,
	        rows: rows,
	        cols: cols
	    }, function (res) {
	        if(res === "success") {
	            alert("좌석 생성 완료");
	            location.reload(); // 전체 구조가 바뀌므로 새로고침
	        } else {
	            alert("생성 실패: " + res);
	        }
	    });
	}
	
	// 3. 좌석 상태 업데이트 (중복 제거됨)
	function changeStatus(status) {
	    if (!selectedSeatId) {
	        alert("좌석을 선택하세요");
	        return;
	    }
	
	    $.post("/admin/seat/status/update", {
	        seat_id: selectedSeatId,
	        seat_state: status
	    }, function (res) {
	        if(res === "success") {
	            const seatEl = $("#seat-" + selectedSeatId);
	            seatEl.data("state", status);
	            $("#selState").text(status);
	            
	            // 이미지 즉시 교체
	            seatEl.attr("src", getSeatImage(status));
	            alert("상태가 " + status + "(으)로 변경되었습니다.");
	        } else {
	            alert("변경 실패: " + res);
	        }
	    });
	}
	
	// 4. 상태별 이미지 경로 반환
	function getSeatImage(state) {
	    // 서버의 실제 이미지 경로에 맞게 수정 필요
	    const path = "/static/assets/adminSeatImg/";
	    switch (state) {
	        case "AVAILABLE": return path + "AVAILABLE.png";
	        case "PREEMPTED": return path + "PREEMPTED.png";
	        case "RESERVED":  return path + "RESERVED.png";
	        case "CANCELED":  return path + "CANCELED.png";
	        default:          return path + "RESERVED.png";
	    }
	}
	
	// 5. 좌석 선택 시 정보 표시
	function selectSeat(seatId) {
	    selectedSeatId = seatId;
	    const el = $("#seat-" + seatId);
	
	    $(".seat-box").removeClass("active-select");
	    el.addClass("active-select");
	
	    $("#selName").text(el.data("name"));
	    $("#selFloor").text(el.data("floor"));
	    $("#selState").text(el.data("state"));
	}
	
	// 6. 셀렉트 박스 연동 (Place -> Work -> Round)
	$("#placeSelect").change(function () {
	    const placeId = $(this).val();
	    if(!placeId) return;
	
	    $.get("/admin/work/list", { place_id: placeId }, function (data) {
	        let html = '<option value="">공연 선택</option>';
	        data.forEach(work => {
	            html += `<option value="${work.work_id}">${work.work_name}</option>`;
	        });
	        $("#workSelect").html(html);
	        $("#roundSelect").html('<option value="">회차 선택</option>');
	    });
	});
	
	$("#workSelect").change(function () {
	    const workId = $(this).val();
	    if(!workId) return;
	
	    $.get("/admin/round/list", { work_id: workId }, function (data) {
	        let html = '<option value="">회차 선택</option>';
	        data.forEach(round => {
	            html += `<option value="${round.round_id}">${round.round_date} ${round.round_time}</option>`;
	        });
	        $("#roundSelect").html(html);
	    });
	});
</script>

</body>
</html>
