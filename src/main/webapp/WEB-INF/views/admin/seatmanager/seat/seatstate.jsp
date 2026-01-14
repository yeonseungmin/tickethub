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
   		<div class="area-rotation-box" style="margin-top: 20px;">
		    <p class="section-title">구역 기울기 (각도)</p>
		    <div class="input-group-row">
		        <input type="number" id="groupAngle" placeholder="0" class="admin-input-small" value="0">
		        <button class="add-area-btn" onclick="applyRotation()">기울기 적용</button>
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
    /* 1. 전역 변수 설정 */
    var isDragging = false;
    var isSelecting = false;    
    var currentGroup = null; 
    var offset = { x: 0, y: 0 };
    var groupsData = {}; 
    var startX, startY;
    // Lasso 선택 상자 객체 준비
    var $selectionBox = $('<div id="selection-box" class="selection-box"></div>');

    window.selectedSeatIds = [];    // ID 관리용
    window.selectedSeatObjs = [];   // 명칭 표시용 {id, label} 객체 관리용

    $(document).ready(function() {
        // [장소 선택] 구역 목록 갱신
        $('#placeSelect').on('change', function() {
            var placeId = $(this).val();
            if (!placeId) return;
            refreshGroupSelect(placeId);
        });

        // [좌석 불러오기] 버튼
        $('#btnLoadSeats').on('click', function() {
            loadSeatLayout();
        });

        /* 2. 저장 버튼 로직 */
        $(document).off('click', '#btnSaveLayout').on('click', '#btnSaveLayout', function() {
            const groupIds = Object.keys(groupsData);
            if (groupIds.length === 0) { alert("저장할 데이터가 없습니다."); return; }
            if (!confirm("모든 구역의 위치와 회전 각도를 저장하시겠습니까?")) return;

            const updateList = groupIds.map(gid => ({
                seat_group_id: gid,
                pos_x: Math.round(groupsData[gid].posX),
                pos_y: Math.round(groupsData[gid].posY),
                angle: parseInt(groupsData[gid].angle) || 0
            }));

            $.ajax({
                url: contextPath + '/admin/seatgroup/updateGroupsBulk', 
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify(updateList),
                dataType: 'text',
                success: function(res) {
                    if (res.includes("<!DOCTYPE") || res.includes("<html")) {
                        alert("서버 응답 오류가 발생했습니다.");
                    } else {
                        alert("성공적으로 저장되었습니다.");
                    }
                },
                error: function(xhr) {
                    alert("저장 실패: (HTTP " + xhr.status + ")");
                }
            });
        });

        /* --- 마우스 드래그 범위 선택 시작 --- */
        $('#seatArea').on('mousedown', function(e) {
            // 좌석이나 구역 박스를 클릭한 경우 드래그 선택 방지
            if ($(e.target).closest('.admin-seat, .group-boundary-box').length > 0) return;
            
            isSelecting = true;
            var containerOffset = $(this).offset();
            startX = e.pageX - containerOffset.left;
            startY = e.pageY - containerOffset.top;
            
            // 기존 상자 제거 후 새로 추가 (중복 방지)
            $('#selection-box').remove();
            $selectionBox.css({ 
                left: startX, 
                top: startY, 
                width: 0, 
                height: 0, 
                display: 'block' 
            }).appendTo('#seatArea');

            if (!e.ctrlKey) {
                $('.admin-seat').removeClass('selected-multi');
                window.selectedSeatIds = [];
                window.selectedSeatObjs = [];
                updateSelectionInfo();
            }
        });
    });

    /* 3. 데이터 로드 및 렌더링 (매핑 로직 유지) */
    function loadSeatLayout() {
        var roundId = $('#roundSelect').val();
        if (!roundId) { alert('회차를 선택해주세요.'); return; }
        
        window.selectedSeatIds = [];
        window.selectedSeatObjs = [];
        updateSelectionInfo();

        $.get(contextPath + '/admin/roundseat/list', { round_id: roundId }, function(seatList) {
            renderStatusMap(seatList);
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
                    maxRelX: 0, maxRelY: 0,
                    posX: seat.pos_x, posY: seat.pos_y,
                    angle: seat.angle || 0,
                    colGap: seat.col_gap || 35, rowGap: seat.row_gap || 35
                };
            }
            
            /* [매핑 수정] 
               가로(X) = seat_y (숫자: 1, 2, 3...)
               세로(Y) = seat_x (알파벳: A, B, C...)
            */
            var rx = (seat.seat_y - 1) * (seat.col_gap || 35);
            var ry = (seat.seat_x.charCodeAt(0) - 65) * (seat.row_gap || 35);
            
            var g = groups[seat.seat_group_id];
            if (rx > g.maxRelX) g.maxRelX = rx; 
            if (ry > g.maxRelY) g.maxRelY = ry;
        });
        groupsData = groups;

        Object.keys(groups).forEach(function(groupId) {
            var g = groups[groupId];
            var boxWidth = Math.max(g.maxRelX + 72, 100); 
            var boxHeight = Math.max(g.maxRelY + 72, 80);

            var $box = $('<div class="group-boundary-box"></div>')
                .attr('data-group-id', groupId)
                .css({ 
                    left: g.posX + 'px', top: g.posY + 'px', 
                    width: boxWidth + 'px', height: boxHeight + 'px',
                    transform: 'rotate(' + g.angle + 'deg)',
                    position: 'absolute'
                });

            $box.append($('<div class="group-name-label"></div>').text(g.name));
            $container.append($box);
            
            $box.on('mousedown', function(e) {
                if ($(e.target).hasClass('admin-seat')) return; 
                isDragging = true;
                currentGroup = groupId;
                $('.group-boundary-box').css('border-color', '#444');
                $(this).css('border-color', '#007bff');
                $('#groupAngle').val(g.angle);
                var boxOffset = $(this).position();
                offset.x = e.pageX - boxOffset.left;
                offset.y = e.pageY - boxOffset.top;
                e.preventDefault();
            });

            seatList.filter(s => s.seat_group_id == groupId).forEach(function(seat) {
                var sStatus = (seat.status || 'AVAILABLE').toUpperCase();
                
                // 가로(rx) 숫자 위치, 세로(ry) 알파벳 위치 적용
                var innerX = (seat.seat_y - 1) * (seat.col_gap || 35) + 20;
                var innerY = (seat.seat_x.charCodeAt(0) - 65) * (seat.row_gap || 35) + 20;
                
                // 명칭: A행 1열 (A는 seat_x, 1은 seat_y)
                var seatLabel = seat.seat_x + "행 " + seat.seat_y + "열";

                var $seatDiv = $('<div class="admin-seat"></div>')
                    .attr({ 'data-seat-id': seat.seat_id, 'data-label': seatLabel })
                    .css({ 
                        left: innerX + 'px', top: innerY + 'px', 
                        backgroundImage: "url('" + contextPath + "/static/assets/adminSeatImg/" + sStatus + ".png')",
                        position: 'absolute'
                    });

                $seatDiv.on('click', function(e) {
                    e.stopPropagation();
                    var sId = String($(this).attr('data-seat-id'));
                    var sLabel = $(this).attr('data-label');

                    if (e.ctrlKey) {
                        if (window.selectedSeatIds.includes(sId)) {
                            window.selectedSeatIds = window.selectedSeatIds.filter(id => id !== sId);
                            window.selectedSeatObjs = window.selectedSeatObjs.filter(o => o.id !== sId);
                            $(this).removeClass('selected-multi');
                        } else {
                            window.selectedSeatIds.push(sId);
                            window.selectedSeatObjs.push({id: sId, label: sLabel});
                            $(this).addClass('selected-multi');
                        }
                    } else {
                        $('.admin-seat').removeClass('selected-multi');
                        window.selectedSeatIds = [sId];
                        window.selectedSeatObjs = [{id: sId, label: sLabel}];
                        $(this).addClass('selected-multi');
                    }
                    updateSelectionInfo();
                });
                $box.append($seatDiv);
            });
        });
    }

    /* 4. 마우스 이동 로직 (이동 + Lasso) */
    $(document).on('mousemove', function(e) {
        if (isDragging && currentGroup) {
            var $box = $('.group-boundary-box[data-group-id="' + currentGroup + '"]');
            var areaW = $('#seatArea').width();
            var areaH = $('#seatArea').height();
            var boxW = $box.outerWidth();
            var boxH = $box.outerHeight();

            var newL = e.pageX - offset.x;
            var newT = e.pageY - offset.y;

            if (newL < 0) newL = 0; if (newT < 0) newT = 0;
            if (newL + boxW > areaW) newL = areaW - boxW;
            if (newT + boxH > areaH) newT = areaH - boxH;

            $box.css({ left: newL + 'px', top: newT + 'px' });
            groupsData[currentGroup].posX = newL;
            groupsData[currentGroup].posY = newT;
        }

        if (isSelecting) {
            var containerOffset = $('#seatArea').offset();
            var currentX = e.pageX - containerOffset.left;
            var currentY = e.pageY - containerOffset.top;
            
            var width = Math.abs(currentX - startX);
            var height = Math.abs(currentY - startY);
            var left = Math.min(currentX, startX);
            var top = Math.min(currentY, startY);
            
            $('#selection-box').css({ left: left, top: top, width: width, height: height });

            // 범위 내 좌석 체크
            var boxRect = $('#selection-box')[0].getBoundingClientRect();
            $('.admin-seat').each(function() {
                var seatRect = this.getBoundingClientRect();
                var isInside = !(seatRect.right < boxRect.left || seatRect.left > boxRect.right || 
                                 seatRect.bottom < boxRect.top || seatRect.top > boxRect.bottom);
                
                var sId = String($(this).attr('data-seat-id'));
                var sLabel = $(this).attr('data-label');

                if (isInside && !window.selectedSeatIds.includes(sId)) {
                    window.selectedSeatIds.push(sId);
                    window.selectedSeatObjs.push({id: sId, label: sLabel});
                    $(this).addClass('selected-multi');
                }
            });
            updateSelectionInfo();
        }
    });

    $(document).on('mouseup', function() {
        if (isSelecting) {
            $('#selection-box').hide();
        }
        isDragging = false;
        isSelecting = false;
    });

    /* 5. 정보 업데이트 (요구사항 반영) */
    function updateSelectionInfo() {
        var count = window.selectedSeatIds.length;
        
        // 1. 선택 좌석 이름 표시 (A행 1열 외 n개)
        var nameText = "-";
        if (count > 0) {
            nameText = window.selectedSeatObjs[0].label;
            if (count > 1) {
                nameText += " 외 " + (count - 1) + "개";
            }
        }
        $('#selName').text(nameText);

        // 2. 상태 칸에 선택 개수 표시
        $('#selState').text(count > 0 ? count + "개 선택됨" : "-");
    }

    /* 6. 기울기(회전) 적용 */
    function applyRotation() {
        if (!currentGroup) { alert("구역을 먼저 선택하세요."); return; }
        var angle = parseInt($('#groupAngle').val()) || 0;
        var $box = $('.group-boundary-box[data-group-id="' + currentGroup + '"]');
        $box.css('transform', 'rotate(' + angle + 'deg)');
        if (groupsData[currentGroup]) groupsData[currentGroup].angle = angle;
    }

    /* 7. 좌석 상태 변경 및 삭제 */
    function changeStatus(status) {
        if (window.selectedSeatIds.length === 0) return alert("좌석을 선택해주세요.");
        var roundId = $('#roundSelect').val();
        if (!confirm(window.selectedSeatIds.length + "개 좌석을 [" + status + "]로 변경하시겠습니까?")) return;

        let requests = window.selectedSeatIds.map(id => $.post(contextPath + '/admin/roundseat/updateStatus', { seat_id: id, round_id: roundId, status: status }));
        Promise.all(requests).then(() => {
            alert("변경 완료");
            loadSeatLayout();
        });
    }

    function deleteSeat() {
        if (window.selectedSeatIds.length === 0) return alert("좌석을 선택해주세요.");
        if (!confirm("선택한 좌석을 삭제하시겠습니까?")) return;
        let requests = window.selectedSeatIds.map(id => $.post(contextPath + '/admin/seatmanager/seat/state/delete', { seat_id: id }));
        Promise.all(requests).then(() => { 
            alert("삭제 완료"); 
            window.selectedSeatIds = []; 
            loadSeatLayout(); 
        });
    }

    /* 8. 생성 관련 */
    function createSeats() {
        var groupId = $('#groupSelect').val();
        var rowCount = $('#rowCount').val();
        var colCount = $('#colCount').val();
        if (!groupId || !rowCount || !colCount) return alert("정보를 모두 입력하세요.");
        $.post(contextPath + '/admin/seatgroup/createBulk', { "seat_group_id": groupId, "row_count": rowCount, "col_count": colCount }, function(res) {
            alert("좌석 생성 완료");
            loadSeatLayout();
        });
    }

    function addNewArea() {
        const placeId = $('#placeSelect').val();
        const groupName = $('#newGroupName').val();
        if (!placeId || !groupName) return alert("장소와 구역명을 확인하세요.");
        $.post(contextPath + '/admin/seatgroup/area/add', { place_id: placeId, group_name: groupName }, function(res) {
            alert("새 구역 등록 완료");
            $('#newGroupName').val('');
            refreshGroupSelect(placeId);
        });
    }

    function refreshGroupSelect(placeId) {
        $.get(contextPath + '/admin/seatgroup/list', { place_id: placeId }, function(groupList) {
            const $gs = $('#groupSelect');
            $gs.empty().append('<option value="">구역 선택</option>');
            if (groupList) groupList.forEach(g => { $gs.append('<option value="' + g.seat_group_id + '">' + g.group_name + '</option>'); });
        });
    }
</script>
</body>
</html>