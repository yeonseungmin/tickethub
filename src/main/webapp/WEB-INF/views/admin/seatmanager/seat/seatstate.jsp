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
    <link rel="stylesheet" href="<%=contextPath%>/static/assets/css/header.css">
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
/* 1. 전역 상태 변수 */
var selectedSeatId = null;
var contextPath = '<%=contextPath%>';
let isDragging = false;
let currentGroup = null;
let offset = { x: 0, y: 0 };
let groupsData = {}; // 모든 구역의 최신 좌표를 보관

$(document).ready(function() {
    
    // [A] 장소 선택 시 -> 공연 목록 및 구역 목록 불러오기
    $('#placeSelect').on('change', function() {
        var placeId = $(this).val();
        $('#workSelect').empty().append('<option value="">공연 선택</option>');
        $('#roundSelect').empty().append('<option value="">회차 선택</option>');
        $('#groupSelect').empty().append('<option value="">구역 선택</option>'); 
        
        if (!placeId) return;

        // 1. 공연 목록 로드
        $.get(contextPath + '/admin/roundseat/workList', { place_id: placeId }, function(data) {
            data.forEach(function(work) {
                $('#workSelect').append('<option value="' + work.work_id + '">' + work.work_title + '</option>');
            });
        });

        // 2. 구역 목록 로드 (좌석 자동 생성용 드롭다운)
        $.get(contextPath + '/admin/seatgroup/list', { place_id: placeId }, function(groupList) {
            var $groupSelect = $('#groupSelect');
            if (groupList && groupList.length > 0) {
                groupList.forEach(function(group) {
                    $groupSelect.append('<option value="' + group.seat_group_id + '">' + group.group_name + '</option>');
                });
            }
        });
    });

    // [B] 공연 선택 시 -> 회차 목록 불러오기
	$('#workSelect').on('change', function() {
	    var workId = $(this).val();
	    var placeId = $('#placeSelect').val(); // 현재 선택된 장소 ID 가져오기
	    
	    $('#roundSelect').empty().append('<option value="">회차 선택</option>');
	    
	    // 장소와 공연이 모두 선택되어야 요청함
	    if (!workId || !placeId) return;
	
	    $.get(contextPath + '/admin/roundseat/roundList', { 
	        work_id: workId, 
	        place_id: placeId  // 서버로 장소 ID도 함께 보냄
	    }, function(data) {
	        data.forEach(function(round) {
	            // 사용자에게 보일 때 장소 정보를 살짝 표시해주면 더 확실합니다.
	            var roundText = round.round_date + ' (' + round.round_start_time + ')';
	            $('#roundSelect').append('<option value="' + round.round_id + '">' + roundText + '</option>');
	        });
	    });
	});

    // [C] 좌석 불러오기 버튼 클릭
    $('#btnLoadSeats').on('click', function() {
        var roundId = $('#roundSelect').val();
        if (!roundId) { alert('회차를 선택해주세요.'); return; }
        
        $.get(contextPath + '/admin/roundseat/list', { round_id: roundId }, function(seatList) {
            renderStatusMap(seatList);
        });
    });

    // [D] ★ 일괄 배치 저장 버튼 클릭 ★
    $(document).on('click', '#btnSaveLayout', function() {
        const groupIds = Object.keys(groupsData);
        if (groupIds.length === 0) {
            alert("저장할 구역 데이터가 없습니다. 먼저 좌석을 불러와주세요.");
            return;
        }

        if (!confirm("변경된 모든 구역의 위치를 DB에 저장하시겠습니까?")) return;

        let total = groupIds.length;
        let successCount = 0;

        groupIds.forEach(function(gid) {
            const g = groupsData[gid];
            $.ajax({
                url: contextPath + '/admin/seatgroup/updateGroupPos',
                type: 'POST',
                data: {
                    "seat_group_id": gid,
                    "pos_x": Math.round(g.posX),
                    "pos_y": Math.round(g.posY)
                },
                success: function(res) {
                    successCount++;
                    if (--total === 0) alert("성공적으로 저장되었습니다.");
                },
                error: function() {
                    if (--total === 0) alert("저장 중 일부 오류가 발생했습니다.");
                }
            });
        });
    });
});

/* -------------------------------------------------------------------------- */
/* 렌더링 및 드래그 관련 함수 (기존 로직 유지 + CSS 클래스화)
/* -------------------------------------------------------------------------- */
	/* [수정] 좌석 불러오기 전용 함수 (중복 제거 및 비동기 재사용을 위해 분리) */
	function loadSeatLayout() {
	    var roundId = $('#roundSelect').val();
	    console.log("현재 요청하는 회차 ID:", roundId);
	    if (!roundId) {
	        alert('회차를 선택해주세요.');
	        return;
	    }
	    
	    // 불러오기 전 기존 좌석 및 구역 박스 완전히 삭제 (장소 변경 시 잔상 방지)
	    $('#seatArea').find('.admin-seat, .group-boundary-box').remove();
	    
	    $.get(contextPath + '/admin/roundseat/list', { round_id: roundId }, function(seatList) {
	        if (!seatList || seatList.length === 0) {
	            alert("해당 회차에 생성된 좌석이 없습니다. [좌석 자동 생성]을 먼저 진행해주세요.");
	            return;
	        }
	        renderStatusMap(seatList);
	        console.log("Loaded round_id: " + roundId + ", Seats: " + seatList.length);
	    });
	}
	
	/* [수정] 좌석 상태 변경 함수 */
	function changeStatus(status) {
	    if (!selectedSeatId) {
	        alert("변경할 좌석을 먼저 선택해주세요.");
	        return;
	    }
	
	    var roundId = $('#roundSelect').val();
	    if (!roundId) {
	        alert("회차 정보를 확인할 수 없습니다.");
	        return;
	    }
	
	    if (!confirm("선택한 좌석의 상태를 [" + status + "]로 변경하시겠습니까?")) return;
	
	    $.ajax({
	        url: contextPath + '/admin/roundseat/updateStatus', 
	        type: 'POST',
	        data: {
	            "seat_id": selectedSeatId,
	            "round_id": roundId,
	            "status": status 
	        },
	        success: function(res) {
	            if(res === "success") {
	                alert("상태가 변경되었습니다.");
	                loadSeatLayout(); // 새로고침 없이 비동기로 다시 로드
	            } else {
	                alert("변경 실패: " + res);
	            }
	        },
	        error: function(xhr) {
	            alert("통신 오류가 발생했습니다.");
	        }
	    });
	}
	
	/* [수정] 좌석 자동 생성 함수 (비동기 최적화 및 모든 Place 대응) */
	function createSeats() {
	    var groupId = $('#groupSelect').val(); 
	    var rowCount = $('#rowCount').val();
	    var colCount = $('#colCount').val();
	    var placeId = $('#placeSelect').val(); // 현재 선택된 장소 ID
	
	    if (!groupId || !rowCount || !colCount) {
	        alert("구역 및 행/열 정보를 입력해주세요.");
	        return;
	    }
	
	    if (!confirm("선택한 구역(ID:" + groupId + ")에 좌석을 생성하시겠습니까?")) return;
	
	    // 생성 중 화면 클릭 방지 및 로딩 표시
	    $('#admin-seat-wrapper').css('opacity', '0.5');
	
	    $.ajax({
	        url: contextPath + '/admin/seatgroup/createBulk',
	        type: 'POST',
	        data: {
	            "seat_group_id": groupId,
	            "row_count": rowCount,
	            "col_count": colCount
	        },
	        success: function(res) {
	            if (res === "success") {
	                alert("좌석 생성이 완료되었습니다.");
	                // location.reload()를 삭제하고, 현재 선택된 회차가 있다면 즉시 비동기 로드
	                if($('#roundSelect').val()) {
	                    loadSeatLayout();
	                }
	            } else {
	                alert("생성 실패: " + res);
	            }
	        },
	        error: function(xhr) {
	            alert("서버 오류가 발생했습니다.");
	        },
	        complete: function() {
	            $('#admin-seat-wrapper').css('opacity', '1.0');
	        }
	    });
	}
	
	/* [이벤트 바인딩] 기존 '좌석 불러오기' 버튼에 함수 연결 */
	$(document).ready(function() {
	    $('#btnLoadSeats').off('click').on('click', function() {
	        loadSeatLayout();
	    });
	    
	    // 장소가 바뀌면 화면을 즉시 비움 (다른 장소 데이터 혼선 방지)
	    $('#placeSelect').on('change', function() {
	        // [수정] $('#seatArea').empty(); 를 아래 줄로 교체
	        $('#seatArea').find('.admin-seat, .group-boundary-box').remove();
	        groupsData = {}; 
	    });
	});
	function renderStatusMap(seatList) {
	    var $container = $('#seatArea');
	    $container.find('.admin-seat, .group-boundary-box').remove();
	    if (!seatList || seatList.length === 0) return;
	
	    // 1. 구역 데이터 계산
	    var groups = {};
	    seatList.forEach(function(seat) {
	        if (!groups[seat.seat_group_id]) {
	            groups[seat.seat_group_id] = {
	                name: seat.group_name || 'Unknown',
	                minX: Infinity, minY: Infinity, maxX: -Infinity, maxY: -Infinity,
	                posX: seat.pos_x, posY: seat.pos_y,
	                rowGap: seat.row_gap, colGap: seat.col_gap
	            };
	        }
	        var curX = seat.pos_x + (seat.seat_x.charCodeAt(0) - 65) * seat.col_gap;
	        var curY = seat.pos_y + (seat.seat_y - 1) * seat.row_gap;
	        var g = groups[seat.seat_group_id];
	        if (curX < g.minX) g.minX = curX; if (curY < g.minY) g.minY = curY;
	        if (curX > g.maxX) g.maxX = curX; if (curY > g.maxY) g.maxY = curY;
	    });
	    groupsData = groups;
	
	    // 2. 구역 경계 박스 생성
	    Object.keys(groups).forEach(function(groupId) {
	        var g = groups[groupId];
	        var padding = 20;
	        var $box = $('<div class="group-boundary-box"></div>')
	            .attr('data-group-id', groupId)
	            .css({
	                'left': (g.minX - padding) + 'px',
	                'top': (g.minY - padding) + 'px',
	                'width': (g.maxX - g.minX + 32 + padding * 2) + 'px',
	                'height': (g.maxY - g.minY + 32 + padding * 2) + 'px'
	            });
	        $box.append($('<div class="group-name-label"></div>').text(g.name));
	        $container.append($box);
	        initGroupDrag($box, groupId);
	    });
	
	    // 3. 개별 좌석 생성
	    seatList.forEach(function(seat) {
	        var sStatus = (seat.status || 'AVAILABLE').toUpperCase();
	        var finalX = seat.pos_x + (seat.seat_x.charCodeAt(0) - 65) * seat.col_gap;
	        var finalY = seat.pos_y + (seat.seat_y - 1) * seat.row_gap;
	
	        var $seatDiv = $('<div class="admin-seat"></div>')
	            .attr({
	                'data-seat-id': seat.seat_id,
	                'data-group-id': seat.seat_group_id,
	                'data-orig-x': finalX,
	                'data-orig-y': finalY
	            })
	            .css({
	                'left': finalX + 'px',
	                'top': finalY + 'px',
	                'background-image': "url('" + contextPath + "/static/assets/adminSeatImg/" + sStatus + ".png')"
	            });
	
	        $seatDiv.on('click', function(e) {
	            e.stopPropagation();
	            selectedSeatId = seat.seat_id;
	            $('#selName').text(seat.seat_name);
	            $('#selState').text(sStatus);
	            $('.admin-seat').css('outline', 'none');
	            $(this).css('outline', '2px solid yellow');
	        });
	        $container.append($seatDiv);
	    });
	}
	
	function initGroupDrag($box, groupId) {
	    $box.on('mousedown', function(e) {
	        if ($(e.target).hasClass('admin-seat')) return;
	        isDragging = true;
	        currentGroup = groupId;
	        var boxOffset = $box.position();
	        offset.x = e.pageX - boxOffset.left;
	        offset.y = e.pageY - boxOffset.top;
	        $box.addClass('dragging');
	        e.preventDefault();
	    });
	}
	
	$(document).on('mousemove', function(e) {
	    if (!isDragging || !currentGroup) return;
	    var g = groupsData[currentGroup];
	    var $box = $('.group-boundary-box[data-group-id="' + currentGroup + '"]');
	    var newL = e.pageX - offset.x;
	    var newT = e.pageY - offset.y;
	    $box.css({ left: newL + 'px', top: newT + 'px' });
	
	    var dx = (newL + 20) - g.minX;
	    var dy = (newT + 20) - g.minY;
	
	    $('.admin-seat[data-group-id="' + currentGroup + '"]').each(function() {
	        var $s = $(this);
	        var ox = parseFloat($s.attr('data-orig-x'));
	        var oy = parseFloat($s.attr('data-orig-y'));
	        $s.css({ left: (ox + dx) + 'px', top: (oy + dy) + 'px' });
	    });
	});
	
	$(document).on('mouseup', function() {
	    if (isDragging && currentGroup) {
	        var $box = $('.group-boundary-box[data-group-id="' + currentGroup + '"]');
	        var g = groupsData[currentGroup];
	        var dx = (parseFloat($box.css('left')) + 20) - g.minX;
	        var dy = (parseFloat($box.css('top')) + 20) - g.minY;
	
	        g.posX += dx; g.posY += dy;
	        g.minX += dx; g.minY += dy;
	
	        $('.admin-seat[data-group-id="' + currentGroup + '"]').each(function() {
	            var $s = $(this);
	            $s.attr('data-orig-x', parseFloat($s.css('left')));
	            $s.attr('data-orig-y', parseFloat($s.css('top')));
	        });
	
	        $box.removeClass('dragging');
	        isDragging = false;
	        currentGroup = null;
	    }
	});
	
	function deleteSeat() {
	    if (!selectedSeatId) {
	        alert("삭제할 좌석을 선택해주세요.");
	        return;
	    }

	    if (!confirm("정말로 이 좌석을 삭제하시겠습니까?\n이 작업은 즉시 반영되며 복구할 수 없습니다.")) {
	        return;
	    }

	    $.ajax({
	        url: contextPath + '/admin/seatmanager/seat/state/delete',
	        type: 'POST',
	        data: { seat_id: selectedSeatId },
	        success: function(response) {
	            // response.trim()을 사용하여 혹시 모를 공백 제거
	            if (response.trim() === "success") {
	                // ✅ 수정: data-id -> data-seat-id 로 변경
	                var $targetSeat = $('.admin-seat[data-seat-id="' + selectedSeatId + '"]');
	                
	                if ($targetSeat.length > 0) {
	                    $targetSeat.fadeOut(300, function() {
	                        $(this).remove(); // 화면에서 제거
	                    });
	                } else {
	                    // 선택자로 못 찾을 경우를 대비해 목록 다시 불러오기 실행
	                    loadSeatLayout();
	                }

	                $('#selName').text('-');
	                $('#selState').text('-');
	                selectedSeatId = null;
	                
	                alert("좌석이 성공적으로 삭제되었습니다.");
	            } else {
	                alert("삭제 실패: " + response);
	            }
	        },
	        error: function(xhr) {
	            alert("서버와 통신 중 오류가 발생했습니다.");
	        }
	    });
	}
</script>

</body>
</html>