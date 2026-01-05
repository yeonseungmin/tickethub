<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ch.tickethub.dto.SeatGroup"%>
<%@ page import="com.ch.tickethub.dto.Seat"%>
<%@ page import="com.ch.tickethub.dto.Place"%>
<%@ page import="java.util.List"%>
<%
    String contextPath = request.getContextPath();
    List<Place> placeList = (List<Place>)request.getAttribute("placeList");

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seat Management Admin</title>
    <link rel="stylesheet" href="<%=contextPath%>/inc/header.css">
    <link rel="stylesheet" href="<%=contextPath%>/static/assets/css/seat.css?v=<%=System.currentTimeMillis()%>">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="admin-seat-page">

<div class="seat-option-bar">
    <div class="nav-group">
        <span class="nav-label">PLACE</span>
        <select id="placeSelect" class="nav-select">
            <option value="">장소 선택</option>
            <% if(placeList != null) { 
                for(Place place : placeList) { %>
                <option value="<%=place.getPlace_id()%>"><%=place.getPlace_name()%></option>
            <% } } %>
                <option value="${place.place_id}">${place.place_name}</option>

        </select>
    </div>
    
    <div class="nav-group">
        <span class="nav-label">WORK</span>
        <select id="workSelect" class="nav-select">
            <option value="">공연 선택</option>
            
        </select>
    </div>
    <div class="nav-group">
        <span class="nav-label">ROUND</span>
        <select id="roundSelect" class="nav-select"><option value="">회차 선택</option></select>
    </div>

    <button class="nav-load-btn" onclick="loadSeats()">
        <span class="icon-search">🔍</span> 좌석 불러오기
    </button>
</div>

<div class="admin-seat-wrapper">
    <div class="seat-map-container">
        <div class="stage-label">STAGE</div>
        <div id="seatArea"></div>
    </div>

    <div class="management-side-panel">
        <h3 class="panel-title">Seat Control</h3>
        
        <div id="selection-info">
            <p>선택 좌석: <span id="selName">-</span></p>
            <p>상태: <span id="selState">-</span></p>
        </div>

        <div class="state-btn-grid">
            <button class="status-btn btn-available" onclick="changeStatus('AVAILABLE')">AVAILABLE</button>
            <button class="status-btn btn-preempted" onclick="changeStatus('PREEMPTED')">PREEMPTED</button>
            <button class="status-btn btn-reserved" onclick="changeStatus('RESERVED')">RESERVED</button>
            <button class="status-btn btn-canceled" onclick="changeStatus('CANCELED')">CANCELED</button>
        </div>

        <div class="grade-btn-grid">
            <button class="grade-btn btn-vip" onclick="changeGrade(1)">VIP</button>
            <button class="grade-btn btn-r" onclick="changeGrade(2)">R</button>
            <button class="grade-btn btn-s" onclick="changeGrade(3)">S</button>
            <button class="grade-btn btn-a" onclick="changeGrade(4)">A</button>
        </div>

        <div class="auto-gen-box">
            <p class="section-title">좌석 자동 생성</p>
            <select id="groupSelect" class="nav-select full-width-select"><option value="">구역 선택</option></select>
            <div class="input-group-row">
                <input type="number" id="rowCount" placeholder="Rows" class="admin-input-small">
                <input type="number" id="colCount" placeholder="Cols" class="admin-input-small">
            </div>
            <button class="create-exec-btn" onclick="createSeats()">생성 실행</button>
        </div>
    </div>
</div>

<script>
    let selectedSeatId = null;
    const contextPath = "<%=contextPath%>";

    // 1. 좌석 불러오기 (현재 선택된 구역의 좌석 배치)
    function loadSeats() {
        const groupId = $("#groupSelect").val();
        if(!groupId) { alert("구역을 먼저 선택하세요."); return; }

        $.get(contextPath + "/seatmanager/seat/manager", { seat_group_id: groupId }, function(data) {
            // 서버에서 보낸 좌석 리스트를 seatArea에 그림 (이 부분은 프로젝트의 HTML 구조에 맞게 구현)
            $("#seatArea").html(data);
        });
    }

    // 2. 좌석 상태 변경 (AVAILABLE, RESERVED 등)
    function changeStatus(status) {
        if (!selectedSeatId) { alert("좌석을 선택하세요"); return; }
        
        $.post(contextPath + "/seatmanager/seat/status/update", {
            seat_id: selectedSeatId,
            seat_state: status
        }, function (res) {
            if(res === "success") {
                $("#selState").text(status);
                alert("상태가 변경되었습니다.");
                // 이미지 업데이트 로직이 필요하다면 여기서 getSeatImage 호출
            } else {
                alert("변경 실패: " + res);
            }
        });
    }

    // 3. 좌석 등급 변경 (VIP, R, S, A)
    function changeGrade(gradeId) {
        if (!selectedSeatId) { alert("좌석을 선택하세요"); return; }
        
        $.post(contextPath + "/seatmanager/seat/grade/update", {
            seat_id: selectedSeatId,
            seat_grade_id: gradeId
        }, function (res) {
            if(res === "success") {
                alert("등급이 변경되었습니다.");
            } else {
                alert("변경 실패");
            }
        });
    }

    // 4. 좌석 자동 생성 (이중 for문을 타는 Service와 연결)
    function createSeats() {
        const groupId = $("#groupSelect").val();
        const rows = $("#rowCount").val();
        const cols = $("#colCount").val();

        if (!groupId || !rows || !cols) { alert("모든 정보를 입력하세요"); return; }
        if (!confirm("물리적 좌석을 생성하시겠습니까?")) return;

        $.post(contextPath + "/seatmanager/seat/generate", {
            seat_group_id: groupId,
            rows: rows,
            cols: cols
        }, function (res) {
            if(res === "success") {
                alert("좌석 생성 완료");
                location.reload();
            } else {
                alert("생성 실패: " + res);
            }
        });
    }

    // 5. 좌석 선택 시 호출되는 함수 (좌석 클릭 시)
    function selectSeat(seatId, seatName, seatState) {
        selectedSeatId = seatId;
        $(".seat-box").removeClass("active-select");
        $("#seat-" + seatId).addClass("active-select");

        $("#selName").text(seatName);
        $("#selState").text(seatState);
    }

	 // 6. 셀렉트 박스 연동 (장소 -> 공연 -> 회차)
	
	 // [Step 1] 장소 선택 시 -> 공연(Work) 목록 가져오기
	 $("#placeSelect").change(function () {
	     const placeId = $(this).val();
	     console.log("선택된 장소 ID:", placeId); // 확인용
	     // 다음 단계 리스트들 초기화
	     $("#workSelect").html('<option value="">공연 선택</option>');
	     $("#roundSelect").html('<option value="">회차 선택</option>');
	
	     if(!placeId) return;
	
	     // WorkMapper.xml 기준 필드명은 work_title입니다.
	     $.get(contextPath + "/admin/performance/work/list", { place_id: placeId }, function (data) {
	    	 console.log("서버 응답 데이터:", data); // ★ 이 부분이 브라우저 콘솔에 찍히는지 확인하세요.
	         let html = '<option value="">공연 선택</option>';
	         if (data.length === 0) {
	             console.warn("데이터가 비어있습니다. DB와 쿼리를 확인하세요.");
	         }
	         data.forEach(work => {
	             // 주의: DTO 필드명이 work_title인지 확인하세요 (Mapper에는 work_title로 되어있음)
	             html += `<option value="${work.work_id}">${work.work_title}</option>`;
	         });
	         $("#workSelect").html(html);
	     });
	 });
	
	 // [Step 2] 공연 선택 시 -> 회차(Round) 목록 가져오기 (추가된 부분)
	 $("#workSelect").change(function () {
	     const workId = $(this).val();
	     
	     $("#roundSelect").html('<option value="">회차 선택</option>');
	
	     if(!workId) return;
	
	     // RoundMapper.xml을 사용하는 컨트롤러 호출
	     $.get(contextPath + "/admin/round/list", { work_id: workId }, function (data) {
	         let html = '<option value="">회차 선택</option>';
	         data.forEach(round => {
	             // 날짜와 시간을 합쳐서 표시 (ex: 2023-12-25 14:00)
	             html += `<option value="${round.round_id}">${round.round_date} ${round.round_start_time}</option>`;
	         });
	         $("#roundSelect").html(html);
	     });
	 });
	
	 // 1. 좌석 불러오기 (수정)
	 function loadSeats() {
	     const roundId = $("#roundSelect").val(); // 이제 회차 ID를 기준으로 불러옵니다.
	     const groupId = $("#groupSelect").val(); // 구역도 필요하다면 유지
	     
	     if(!roundId) { alert("회차를 먼저 선택하세요."); return; }
	
	     // 만약 서버 컨트롤러가 round_id를 받도록 설계되어 있다면 아래와 같이 호출
	     $.get(contextPath + "/seatmanager/seat/manager", { 
	         round_id: roundId,
	         seat_group_id: groupId 
	     }, function(data) {
	         $("#seatArea").html(data);
	     });
	 }
</script>

</body>
</html>