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
    var currentGroup = null; // 현재 선택되거나 드래그 중인 구역 ID
    var offset = { x: 0, y: 0 };
    var groupsData = {}; // 각 구역의 위치(posX, posY)와 각도(angle) 정보를 저장

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

        /* 2. 저장 버튼 로직 (수정) */
        $(document).on('click', '#btnSaveLayout', function() {
            const groupIds = Object.keys(groupsData);
            if (groupIds.length === 0) { alert("저장할 데이터가 없습니다."); return; }
            
            // 저장 전 데이터 최종 확인 (콘솔에서 확인 가능)
            console.log("저장 전 전체 데이터 상태:", groupsData);

            if (!confirm("모든 구역의 위치와 회전 각도를 DB에 저장하시겠습니까?")) return;

            let total = groupIds.length;
            let successFlag = true;

            groupIds.forEach(function(gid) {
                const g = groupsData[gid];
                
                // ★ 여기서 콘솔을 확인하여 angle이 0인지 확인하세요.
                console.log(`전송 시도 -> ID: ${gid}, Angle: ${g.angle}`);

                $.ajax({
                    url: contextPath + '/admin/seatgroup/updateGroupPos',
                    type: 'POST',
                    data: { 
                        "seat_group_id": gid, 
                        "pos_x": Math.round(g.posX), 
                        "pos_y": Math.round(g.posY),
                        "angle": g.angle // || 0 을 제거하고 실제 값을 보냅니다.
                    },
                    success: function(res) {
                        console.log(gid + " 저장 완료");
                    },
                    error: function(xhr) { 
                        console.error(gid + " 저장 실패:", xhr.responseText);
                        successFlag = false; 
                    },
                    complete: function() { 
                        if (--total === 0) {
                            if(successFlag) alert("성공적으로 저장되었습니다.");
                            else alert("저장 중 일부 오류가 발생했습니다.");
                        }
                    }
                });
            });
        });
    });

    /* 2. 좌석 선택 관련 함수 */
    function toggleSeatSelection($el, seatId, status, isMulti) {
        if (isMulti) {
            const idx = window.selectedSeatIds.indexOf(seatId);
            if (idx > -1) {
                window.selectedSeatIds.splice(idx, 1);
                $el.removeClass('selected-multi');
            } else {
                window.selectedSeatIds.push(seatId);
                $el.addClass('selected-multi');
            }
        } else {
            $('.admin-seat').removeClass('selected-multi');
            window.selectedSeatIds = [seatId];
            $el.addClass('selected-multi');
        }
        updateSelectionInfo(status);
    }

    function updateSelectionInfo(status) {
        const count = window.selectedSeatIds.length;
        $('#selName').text(count > 0 ? count + "개 선택됨" : "-");
        $('#selState').text(count === 1 ? (status || "SELECTED") : (count > 1 ? "MULTI" : "-"));
    }

    /* 3. 데이터 로드 및 렌더링 */
    function loadSeatLayout() {
        var roundId = $('#roundSelect').val();
        if (!roundId) { alert('회차를 선택해주세요.'); return; }
        window.selectedSeatIds = [];
        updateSelectionInfo("-");
        $.get(contextPath + '/admin/roundseat/list', { round_id: roundId }, function(seatList) {
            renderStatusMap(seatList);
        });
    }

    function renderStatusMap(seatList) {
        var $container = $('#seatArea');
        // 기존 렌더링 요소 제거 (라벨 제외)
        $container.find('.admin-seat, .group-boundary-box').remove();

        var groups = {};
        // 1단계: 구역별 데이터 수집 및 내부 상대 범위 계산
        seatList.forEach(function(seat) {
            if (!groups[seat.seat_group_id]) {
                groups[seat.seat_group_id] = {
                    name: seat.group_name || 'Unknown',
                    minRelX: Infinity, minRelY: Infinity, maxRelX: -Infinity, maxRelY: -Infinity,
                    posX: seat.pos_x, posY: seat.pos_y,
                    angle: seat.angle || 0,
                    colGap: seat.col_gap, rowGap: seat.row_gap
                };
            }
            var rx = (seat.seat_x.charCodeAt(0) - 65) * seat.col_gap;
            var ry = (seat.seat_y - 1) * seat.row_gap;
            var g = groups[seat.seat_group_id];
            if (rx < g.minRelX) g.minRelX = rx; if (ry < g.minRelY) g.minRelY = ry;
            if (rx > g.maxRelX) g.maxRelX = rx; if (ry > g.maxRelY) g.maxRelY = ry;
        });
        groupsData = groups;

        // 2단계: 구역 박스(부모) 및 좌석(자식) 생성
        Object.keys(groups).forEach(function(groupId) {
            var g = groups[groupId];
            
            // 구역 경계 박스 생성
            var $box = $('<div class="group-boundary-box"></div>')
                .attr('data-group-id', groupId)
                .css({ 
                    left: g.posX + 'px', 
                    top: g.posY + 'px', 
                    width: (g.maxRelX - g.minRelX + 72) + 'px', 
                    height: (g.maxRelY - g.minRelY + 72) + 'px',
                    transform: 'rotate(' + g.angle + 'deg)',
                    position: 'absolute'
                });

            $box.append($('<div class="group-name-label"></div>').text(g.name));
            $container.append($box);
            
            // 구역 마우스 다운 (드래그 시작 및 선택)
            $box.on('mousedown', function(e) {
                if ($(e.target).hasClass('admin-seat')) return; // 좌석 클릭 시 드래그 방지
                
                isDragging = true;
                currentGroup = groupId;
                
                // UI 선택 표시
                $('.group-boundary-box').css('border-color', '#444');
                $(this).css('border-color', '#007bff');
                $('#groupAngle').val(g.angle);

                var boxOffset = $(this).position();
                offset.x = e.pageX - boxOffset.left;
                offset.y = e.pageY - boxOffset.top;
                e.preventDefault();
            });

            // 해당 구역의 좌석들을 박스 내부로 추가
            seatList.filter(s => s.seat_group_id == groupId).forEach(function(seat) {
                var sStatus = (seat.status || 'AVAILABLE').toUpperCase();
                var innerX = (seat.seat_x.charCodeAt(0) - 65) * seat.col_gap + 20;
                var innerY = (seat.seat_y - 1) * seat.row_gap + 20;

                var $seatDiv = $('<div class="admin-seat"></div>')
                    .attr({ 'data-seat-id': seat.seat_id })
                    .css({ 
                        left: innerX + 'px', 
                        top: innerY + 'px', 
                        backgroundImage: "url('" + contextPath + "/static/assets/adminSeatImg/" + sStatus + ".png')",
                        position: 'absolute'
                    });

                // 좌석 클릭 시 선택 토글
                $seatDiv.on('click', function(e) {
                    e.stopPropagation(); // 부모 박스 드래그 이벤트 방지
                    toggleSeatSelection($(this), seat.seat_id, sStatus, e.ctrlKey);
                });

                $box.append($seatDiv);
            });
        });
    }

    /* 4. 마우스 이동 및 드래그 로직 */
    $(document).on('mousemove', function(e) {
        if (!isDragging || !currentGroup) return;
        
        var $box = $('.group-boundary-box[data-group-id="' + currentGroup + '"]');
        var newL = e.pageX - offset.x;
        var newT = e.pageY - offset.y;
        
        $box.css({ left: newL + 'px', top: newT + 'px' });
        
        // 데이터 객체 실시간 갱신
        groupsData[currentGroup].posX = newL;
        groupsData[currentGroup].posY = newT;
    });

    $(document).on('mouseup', function() {
        isDragging = false; // 드래그 상태만 해제 (선택된 currentGroup은 유지)
    });

    /* 5. 기울기(회전) 적용 */
    function applyRotation() {
        if (!currentGroup) { 
            alert("기울기를 변경할 구역을 먼저 선택(클릭)하세요."); 
            return; 
        }
        
        // 1. 입력값 가져오기
        var angleValue = $('#groupAngle').val();
        var angle = parseInt(angleValue) || 0;
        
        var $box = $('.group-boundary-box[data-group-id="' + currentGroup + '"]');
        
        // 2. 화면에 즉시 반영
        $box.css('transform', 'rotate(' + angle + 'deg)');
        
        // 3. [중요] 데이터 객체에 저장
        if (groupsData[currentGroup]) {
            groupsData[currentGroup].angle = angle;
            console.log("기울기 적용 성공! 구역:", currentGroup, "각도:", groupsData[currentGroup].angle);
        } else {
            console.error("해당 구역 데이터를 찾을 수 없습니다:", currentGroup);
        }
    }

    /* 6. 좌석 상태 변경 및 관리 함수 */
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

    /* 7. 구역 및 좌석 생성 보조 함수 */
    function createSeats() {
        var groupId = $('#groupSelect').val();
        var rowCount = $('#rowCount').val();
        var colCount = $('#colCount').val();
        if (!groupId || !rowCount || !colCount) return alert("정보를 모두 입력하세요.");
        
        $.post(contextPath + '/admin/seatgroup/createBulk', { 
            "seat_group_id": groupId, 
            "row_count": rowCount, 
            "col_count": colCount 
        }, function(res) {
            if (res.trim() === "success") { 
                alert("좌석 생성 완료"); 
                loadSeatLayout(); 
            }
        });
    }

    function addNewArea() {
        const placeId = $('#placeSelect').val();
        const groupName = $('#newGroupName').val();
        if (!placeId || !groupName) return alert("장소와 구역명을 확인하세요.");
        
        $.post(contextPath + '/admin/seatgroup/area/add', { 
            place_id: placeId, 
            group_name: groupName 
        }, function(res) {
            if (res === "success") { 
                alert("새 구역이 등록되었습니다."); 
                $('#newGroupName').val(''); 
                refreshGroupSelect(placeId); 
            }
        });
    }

    function refreshGroupSelect(placeId) {
        $.get(contextPath + '/admin/seatgroup/list', { place_id: placeId }, function(groupList) {
            const $groupSelect = $('#groupSelect');
            $groupSelect.empty().append('<option value="">구역 선택</option>');
            if (groupList) {
                groupList.forEach(g => {
                    $groupSelect.append('<option value="' + g.seat_group_id + '">' + g.group_name + '</option>');
                });
            }
        });
    }
</script>
</body>
</html>