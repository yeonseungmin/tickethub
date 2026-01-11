<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>Grade Management Admin</title>
    <link rel="stylesheet" href="<%=contextPath%>/static/assets/css/seat.css?v=<%=System.currentTimeMillis()%>">
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        var contextPath = '<%=contextPath%>';
    </script>
    
    <script src="<%=contextPath%>/static/assets/js/seat.js?v=<%=System.currentTimeMillis()%>" charset="UTF-8"></script>
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
            <select id="roundSelect" class="nav-select">
                <option value="">회차 선택</option>
            </select>
        </div>

        <button class="nav-load-btn" onclick="loadSeatLayout()">
            <span class="icon-search">🔍</span> 조회
        </button>
    </div>

    <div class="admin-seat-wrapper">
        <div class="seat-map-container">
            <div class="stage-label">STAGE</div>
            <div id="seatArea"></div>
        </div>

        <div class="management-side-panel">
            <h3 class="panel-title">Grade Controller</h3>
            <div id="selection-info">
                <p>선택 좌석: <span id="selName">-</span></p>
                <p>등급: <span id="selState">-</span></p>
            </div>

            <div class="grade-btn-grid">
                <button class="grade-btn btn-vip" onclick="changeGrade(1)">VIP</button>
                <button class="grade-btn btn-r" onclick="changeGrade(2)">R석</button>
                <button class="grade-btn btn-s" onclick="changeGrade(3)">S석</button>
                <button class="grade-btn btn-a" onclick="changeGrade(4)">A석</button>
            </div>

            <button class="save-layout-btn" onclick="saveBatchLayout()" style="margin-top:20px;">
                등급 저장
            </button>
        </div>
    </div>

	<script>
	/**
	 * 1. 좌석 레이아웃 로드 (AJAX)
	 * 조회 버튼 클릭 시에만 실행됩니다.
	 */
	// 전역 변수 관리
	 window.selectedSeatIds = [];
	 window.pendingChanges = {}; // { seat_id: grade_id } 형태로 변경 내역을 임시 저장

	 /**
	  * 1. 좌석 레이아웃 로드 (AJAX)
	  */
	 function loadSeatLayout() {
	     var roundId = $('#roundSelect').val();
	     if (!roundId) {
	         alert("회차를 선택해주세요.");
	         return;
	     }

	     // 초기화
	     window.selectedSeatIds = [];
	     window.pendingChanges = {}; // 새로 불러올 때 대기 내역 초기화
	     updateSelectionInfo("-"); 

	     var url = contextPath + '/admin/roundseat/list?round_id=' + roundId + '&_t=' + new Date().getTime();

	     $.get(url, function(list) {
	         if (!list || list.length === 0) {
	             alert("해당 회차에 생성된 좌석 데이터가 없습니다.");
	             $('#seatArea').empty();
	             return;
	         }
	         renderStatusMap(list);
	     }).fail(function() {
	         alert("데이터를 불러오는 중 오류가 발생했습니다.");
	     });
	 }

	 /**
	  * 2. 등급 관리 전용 렌더링 함수
	  */
	 function renderStatusMap(seatList) {
	     var $container = $('#seatArea').empty();
	     
	     // [A] 구역 경계선 그리기 (기존 로직 유지)
	     var groups = {};
	     seatList.forEach(function(seat) {
	         if (!groups[seat.seat_group_id]) {
	             groups[seat.seat_group_id] = {
	                 name: seat.group_name || '구역',
	                 minX: Infinity, minY: Infinity, maxX: -Infinity, maxY: -Infinity
	             };
	         }
	         var curX = seat.pos_x + (seat.seat_x.charCodeAt(0) - 65) * seat.col_gap;
	         var curY = seat.pos_y + (seat.seat_y - 1) * seat.row_gap;
	         var g = groups[seat.seat_group_id];
	         if (curX < g.minX) g.minX = curX; if (curY < g.minY) g.minY = curY;
	         if (curX > g.maxX) g.maxX = curX; if (curY > g.maxY) g.maxY = curY;
	     });

	     Object.keys(groups).forEach(function(id) {
	         var g = groups[id];
	         $('<div class="group-boundary-box"></div>')
	             .css({
	                 left: (g.minX - 20) + 'px', 
	                 top: (g.minY - 20) + 'px',
	                 width: (g.maxX - g.minX + 72) + 'px', 
	                 height: (g.maxY - g.minY + 72) + 'px'
	             })
	             .append($('<div class="group-name-label"></div>').text(g.name))
	             .appendTo($container);
	     });

	     // [B] 좌석 그리기
	     seatList.forEach(function(seat) {
	         var finalX = seat.pos_x + (seat.seat_x.charCodeAt(0) - 65) * seat.col_gap;
	         var finalY = seat.pos_y + (seat.seat_y - 1) * seat.row_gap;
	         
	         var rawGrade = seat.grade_name || "A"; 
	         var gName = rawGrade.toLowerCase();
	         
	         var gradeType = (['vip', 'r', 's'].indexOf(gName) > -1) ? gName : 'a';
	         var imgUrl = contextPath + "/static/assets/seatImg/available_" + gradeType + ".jpg";

	         $('<div class="admin-seat"></div>')
	             .attr({ 
	                 'data-seat-id': seat.seat_id,
	                 'data-grade': rawGrade.toUpperCase()
	             })
	             .css({ 
	                 left: finalX + 'px', 
	                 top: finalY + 'px', 
	                 backgroundImage: "url('" + imgUrl + "')" 
	             })
	             .on('click', function(e) {
	                 e.stopPropagation();
	                 if (e.ctrlKey || e.metaKey) {
	                     var idx = window.selectedSeatIds.indexOf(seat.seat_id);
	                     if (idx > -1) {
	                         window.selectedSeatIds.splice(idx, 1);
	                         $(this).removeClass('selected-multi');
	                     } else {
	                         window.selectedSeatIds.push(seat.seat_id);
	                         $(this).addClass('selected-multi');
	                     }
	                 } else {
	                     $('.admin-seat').removeClass('selected-multi');
	                     window.selectedSeatIds = [seat.seat_id];
	                     $(this).addClass('selected-multi');
	                 }
	                 updateSelectionInfo(rawGrade.toUpperCase());
	             })
	             .appendTo($container);
	     });
	 }

	 /**
	  * 3. 정보창 업데이트 함수 (기존 유지)
	  */
	 function updateSelectionInfo(gradeName) {
	     var count = (window.selectedSeatIds) ? window.selectedSeatIds.length : 0;
	     if (count > 0) {
	         $('#selName').html('<b style="color:#2563eb;">' + count + '</b> 개');
	     } else {
	         $('#selName').text("-");
	     }
	     
	     if (count === 0) {
	         $('#selState').text("-");
	     } else if (count > 1) {
	         $('#selState').text("다중 선택됨");
	     } else {
	         $('#selState').text(gradeName || "-");
	     }
	 }

	 /**
	  * 4. 등급 임시 변경 (화면에서만 변경)
	  */
	 function changeGrade(gradeId) {
	     if (!window.selectedSeatIds || window.selectedSeatIds.length === 0) {
	         return alert("변경할 좌석을 먼저 선택하세요.");
	     }

	     // 등급 ID별 이미지 타입 매핑
	     var gradeMap = { 1: 'vip', 2: 'r', 3: 's', 4: 'a' };
	     var gradeType = gradeMap[gradeId];
	     var imgUrl = contextPath + "/static/assets/seatImg/available_" + gradeType + ".jpg";

	     window.selectedSeatIds.forEach(function(id) {
	         // 1. 임시 변경 내역 객체에 저장
	         window.pendingChanges[id] = gradeId;

	         // 2. 화면의 좌석 이미지 즉시 교체
	         var $seat = $('.admin-seat[data-seat-id="' + id + '"]');
	         $seat.css('background-image', "url('" + imgUrl + "')");
	         
	         // 3. 저장 전임을 알리는 표시 (테두리를 파란색으로 변경 등)
	         $seat.css('outline', '2px solid #2563eb'); 
	     });

	     // 선택 해제 (원할 경우 추가)
	     // $('.admin-seat').removeClass('selected-multi');
	     // window.selectedSeatIds = [];
	 }

	 /**
	  * 5. [등급 저장] 버튼 클릭 시 호출 - 서버 최종 반영
	  */
	 function saveBatchLayout() {
	     var seatIds = Object.keys(window.pendingChanges);
	     
	     if (seatIds.length === 0) {
	         return alert("변경된 내용이 없습니다.");
	     }

	     if (!confirm(seatIds.length + "개 좌석의 등급 변경을 저장하시겠습니까?")) return;

	     // 모든 변경 내역을 서버로 전송
	     var requests = seatIds.map(function(id) {
	         return $.post(contextPath + '/admin/roundseat/updateGrade', { 
	             seat_id: id, 
	             seat_grade_id: window.pendingChanges[id] 
	         });
	     });

	     // 모든 AJAX 요청이 완료될 때까지 대기
	     Promise.all(requests).then(function() {
	         alert("성공적으로 저장되었습니다.");
	         window.pendingChanges = {}; // 내역 비우기
	         loadSeatLayout(); // 최신 데이터로 다시 그리기
	     }).catch(function(err) {
	         alert("저장 중 오류가 발생했습니다.");
	     });
	 }
	</script>

</body>
</html>