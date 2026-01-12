<%@page import="com.ch.tickethub.dto.Work"%>
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
    <title>Seat Management Admin (Updated)</title>
    <link rel="stylesheet" href="<%=contextPath%>/static/assets/css/seat.css?v=<%=System.currentTimeMillis()%>">
<!--     <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> -->
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

    <button class="nav-load-btn" id="btnLoadSeats">
        <span class="icon-search">🔍</span> 좌석 불러오기
    </button>
</div>

<div class="admin-seat-wrapper">
    <div class="seat-map-container">
        <div class="stage-label">STAGE</div>
        <div id="seatArea">
            <div class="floor-label" style="top: 0px;">─── 1st FLOOR ───</div>
            <div class="floor-label floor-2-label" style="top: 600px;">─── 2nd FLOOR ───</div>
        </div>
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
            <button class="status-btn btn-delete" onclick="deleteSeat()">DELETE SEAT</button>
        </div>

        <div class="area-registration-box">
            <p class="section-title">새 구역 등록</p>
            <div class="input-group-vertical">
                <select id="newGroupName" class="admin-input-full">
					<option value="">구역 선택</option>
					<option value="중앙 1F">중앙 1F</option>
					<option value="중앙 2F">중앙 2F</option>
					<option value="좌측 하단 1F">좌측 하단 1F</option>
					<option value="좌측 상단 1F">좌측 상단 1F</option>
					<option value="우측 하단 1F">우측 하단 1F</option>
					<option value="우측 상단 1F">우측 상단 1F</option>
					<option value="좌측 하단 2F">좌측 하단 2F</option>
					<option value="좌측 상단 2F">좌측 상단 2F</option>
					<option value="우측 하단 2F">우측 하단 2F</option>
					<option value="우측 상단 2F">우측 상단 2F</option>
                </select>
                <button class="add-area-btn" onclick="addNewArea()">
                    <span class="icon-plus">+</span> 구역 추가하기
                </button>
            </div>
        </div>
        <hr class="panel-divider">

        <div class="auto-gen-box">
            <p class="section-title">좌석 자동 생성</p>
            <select id="groupSelect" class="nav-select full-width-select">
                <option value="">구역 선택</option>
            </select>
            <div class="input-group-row">
                <input type="number" id="rowCount" placeholder="Rows" class="admin-input-small">
                <input type="number" id="colCount" placeholder="Cols" class="admin-input-small">
            </div>
            <button class="create-exec-btn" onclick="createSeats()">생성 실행</button>
            <button id="btnSaveLayout" class="save-layout-btn">현재 배치 저장하기</button>
        </div>
    </div>
</div>

<script>
    /* 1. 이 페이지 고유 전역 변수 (selectedSeatIds는 seat.js의 것을 사용) */
    var isDragging = false;
    var currentGroup = null;
    var offset = { x: 0, y: 0 };
    var groupsData = {}; 
    
    $(document).ready(function() {
        // [수정] 장소 선택 시 구역 목록 갱신만 수행 (공연/회차 연동은 seat.js가 처리)
        $('#placeSelect').on('change', function() {
            var placeId = $(this).val();
            if (!placeId) return;
            refreshGroupSelect(placeId);
        });

        // [유지] 좌석 불러오기 버튼
        $('#btnLoadSeats').on('click', function() {
            loadSeatLayout();
        });

        // [유지] 배치 저장 버튼
        $(document).on('click', '#btnSaveLayout', function() {
            const groupIds = Object.keys(groupsData);
            if (groupIds.length === 0) { alert("저장할 구역 데이터가 없습니다."); return; }
            if (!confirm("변경된 모든 구역의 위치를 DB에 저장하시겠습니까?")) return;
            let total = groupIds.length;
            groupIds.forEach(function(gid) {
                const g = groupsData[gid];
                $.ajax({
                    url: contextPath + '/admin/seatgroup/updateGroupPos',
                    type: 'POST',
                    data: { "seat_group_id": gid, "pos_x": Math.round(g.posX), "pos_y": Math.round(g.posY) },
                    success: function() { if (--total === 0) alert("성공적으로 저장되었습니다."); },
                    error: function() { if (--total === 0) alert("저장 중 오류 발생"); }
                });
            });
        });
    });
    
    function updateSelectionInfo(status) {
        // window.selectedSeatIds (seat.js 관리) 사용
        const count = window.selectedSeatIds.length;
        $('#selName').text(count > 0 ? count + "개 선택됨" : "-");
        $('#selState').text(count === 1 ? (status || "SELECTED") : (count > 1 ? "MULTI" : "-"));
    }
    
    function loadSeatLayout() {
        var roundId = $('#roundSelect').val();
        if (!roundId) { alert('회차를 선택해주세요.'); return; }
        window.selectedSeatIds = []; // 선택 초기화
        updateSelectionInfo("-");
        $.get(contextPath + '/admin/roundseat/list', { round_id: roundId }, function(seatList) {
            renderStatusMap(seatList);
        });
    }
    
    function changeStatus(status) {
        let ids = window.selectedSeatIds.filter(id => id != null && id !== "");
        if (ids.length === 0) { alert("변경할 좌석을 선택해주세요."); return; }
        var roundId = $('#roundSelect').val();
        if (!roundId) { alert("회차를 먼저 선택해주세요."); return; }
        
        if (!confirm(ids.length + "개 좌석을 [" + status + "]로 변경하시겠습니까?")) return;

        let requests = ids.map(id => 
            $.post(contextPath + '/admin/roundseat/updateStatus', { 
                seat_id: id, round_id: roundId, status: status 
            })
        );
        
        Promise.all(requests).then(() => { 
            
            loadSeatLayout(); 
        });
    }
    
    function deleteSeat() {
        let ids = window.selectedSeatIds.filter(id => id != null && id !== "");
        if (ids.length === 0) { alert("삭제할 좌석을 선택해주세요."); return; }
        if (!confirm("선택한 " + ids.length + "개 좌석을 삭제하시겠습니까?")) return;

        let requests = ids.map(id => 
            $.post(contextPath + '/admin/seatmanager/seat/state/delete', { seat_id: id })
        );
        
        Promise.all(requests).then(() => { 
            alert("삭제 완료"); 
            window.selectedSeatIds = []; 
            loadSeatLayout(); 
        });
    }
    
    function renderStatusMap(seatList) {
        var $container = $('#seatArea');
        $container.find('.admin-seat, .group-boundary-box').remove();
        var groups = {};
        seatList.forEach(function(seat) {
            if (!groups[seat.seat_group_id]) {
                groups[seat.seat_group_id] = {
                    name: seat.group_name || 'Unknown',
                    minX: Infinity, minY: Infinity, maxX: -Infinity, maxY: -Infinity,
                    posX: seat.pos_x, posY: seat.pos_y, rowGap: seat.row_gap, colGap: seat.col_gap
                };
            }
            var curX = seat.pos_x + (seat.seat_x.charCodeAt(0) - 65) * seat.col_gap;
            var curY = seat.pos_y + (seat.seat_y - 1) * seat.row_gap;
            var g = groups[seat.seat_group_id];
            if (curX < g.minX) g.minX = curX; if (curY < g.minY) g.minY = curY;
            if (curX > g.maxX) g.maxX = curX; if (curY > g.maxY) g.maxY = curY;
        });
        groupsData = groups;
    
        Object.keys(groups).forEach(function(groupId) {
            var g = groups[groupId];
            var $box = $('<div class="group-boundary-box"></div>').attr('data-group-id', groupId)
                .css({ left: (g.minX - 20) + 'px', top: (g.minY - 20) + 'px', width: (g.maxX - g.minX + 72) + 'px', height: (g.maxY - g.minY + 72) + 'px' });
            $box.append($('<div class="group-name-label"></div>').text(g.name));
            $container.append($box);
            initGroupDrag($box, groupId);
        });
    
        seatList.forEach(function(seat) {
            var sStatus = (seat.status || 'AVAILABLE').toUpperCase();
            var finalX = seat.pos_x + (seat.seat_x.charCodeAt(0) - 65) * seat.col_gap;
            var finalY = seat.pos_y + (seat.seat_y - 1) * seat.row_gap;
            var $seatDiv = $('<div class="admin-seat"></div>')
                .attr({ 'data-seat-id': seat.seat_id, 'data-group-id': seat.seat_group_id, 'data-orig-x': finalX, 'data-orig-y': finalY })
                .css({ left: finalX + 'px', top: finalY + 'px', backgroundImage: "url('" + contextPath + "/static/assets/adminSeatImg/" + sStatus + ".png')" });
    
            $seatDiv.on('click', function(e) {
                e.stopPropagation();
                if (e.ctrlKey) {
                    const idx = window.selectedSeatIds.indexOf(seat.seat_id);
                    if (idx > -1) { window.selectedSeatIds.splice(idx, 1); $(this).removeClass('selected-multi'); }
                    else { window.selectedSeatIds.push(seat.seat_id); $(this).addClass('selected-multi'); }
                } else {
                    $('.admin-seat').removeClass('selected-multi');
                    window.selectedSeatIds = [seat.seat_id];
                    $(this).addClass('selected-multi');
                }
                updateSelectionInfo(sStatus);
            });
            $container.append($seatDiv);
        });
    }
    
    // [유지] 구역 드래그 기능
    function initGroupDrag($box, groupId) {
        $box.on('mousedown', function(e) {
            if ($(e.target).hasClass('admin-seat')) return;
            isDragging = true; currentGroup = groupId;
            var boxOffset = $box.position();
            offset.x = e.pageX - boxOffset.left; offset.y = e.pageY - boxOffset.top;
            $box.addClass('dragging'); e.preventDefault();
        });
    }
    
    $(document).on('mousemove', function(e) {
        if (!isDragging || !currentGroup) return;
        var g = groupsData[currentGroup], $box = $('.group-boundary-box[data-group-id="' + currentGroup + '"]');
        var newL = e.pageX - offset.x, newT = e.pageY - offset.y;
        $box.css({ left: newL + 'px', top: newT + 'px' });
        var dx = (newL + 20) - g.minX, dy = (newT + 20) - g.minY;
        $('.admin-seat[data-group-id="' + currentGroup + '"]').each(function() {
            var $s = $(this), ox = parseFloat($s.attr('data-orig-x')), oy = parseFloat($s.attr('data-orig-y'));
            $s.css({ left: (ox + dx) + 'px', top: (oy + dy) + 'px' });
        });
    });
    
    $(document).on('mouseup', function() {
        if (isDragging && currentGroup) {
            var $box = $('.group-boundary-box[data-group-id="' + currentGroup + '"]'), g = groupsData[currentGroup];
            var dx = (parseFloat($box.css('left')) + 20) - g.minX, dy = (parseFloat($box.css('top')) + 20) - g.minY;
            g.posX += dx; g.posY += dy; g.minX += dx; g.minY += dy;
            $('.admin-seat[data-group-id="' + currentGroup + '"]').each(function() {
                var $s = $(this); $s.attr('data-orig-x', parseFloat($s.css('left'))).attr('data-orig-y', parseFloat($s.css('top')));
            });
            $box.removeClass('dragging'); isDragging = false; currentGroup = null;
        }
    });
    
    // [유지] 구역 추가 및 생성 기능
    function createSeats() {
        var groupId = $('#groupSelect').val(), rowCount = $('#rowCount').val(), colCount = $('#colCount').val();
        if (!groupId || !rowCount || !colCount) return alert("정보를 입력하세요.");
        $.post(contextPath + '/admin/seatgroup/createBulk', { "seat_group_id": groupId, "row_count": rowCount, "col_count": colCount }, function(res) {
            if (res.trim() === "success") { alert("완료"); loadSeatLayout(); }
        });
    }
    
    function addNewArea() {
        const placeId = $('#placeSelect').val(), groupName = $('#newGroupName').val();
        if (!placeId || !groupName) return alert("정보를 확인하세요.");
        $.post(contextPath + '/admin/seatgroup/area/add', { place_id: placeId, group_name: groupName }, function(res) {
            if (res === "success") { alert("성공"); $('#newGroupName').val(''); refreshGroupSelect(placeId); }
        });
    }
    
    function refreshGroupSelect(placeId) {
        $.get(contextPath + '/admin/seatgroup/list', { place_id: placeId }, function(groupList) {
            const $groupSelect = $('#groupSelect');
            $groupSelect.empty().append('<option value="">구역 선택</option>');
            if (groupList) groupList.forEach(g => $groupSelect.append('<option value="' + g.seat_group_id + '">' + g.group_name + '</option>'));
        });
    }
</script>
</body>
</html>