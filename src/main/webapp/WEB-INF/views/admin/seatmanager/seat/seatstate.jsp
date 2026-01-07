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
        </div>
    </div>
</div>

<script>
    var selectedSeatId = null;
    var contextPath = '<%=contextPath%>';

    $(document).ready(function() {
        // 1. 장소 선택 시 -> 공연 목록 및 구역 목록 불러오기
        $('#placeSelect').on('change', function() {
            var placeId = $(this).val();
            $('#workSelect').empty().append('<option value="">공연 선택</option>');
            $('#roundSelect').empty().append('<option value="">회차 선택</option>');
            $('#groupSelect').empty().append('<option value="">구역 선택</option>'); // 구역 초기화
            
            if (!placeId) return;

            // 공연 목록 로드
            $.get(contextPath + '/admin/roundseat/workList', { place_id: placeId }, function(data) {
                data.forEach(function(work) {
                    $('#workSelect').append('<option value="' + work.work_id + '">' + work.work_title + '</option>');
                });
            });

            // 구역 목록 로드 (좌석 자동 생성용)
            $.get(contextPath + '/admin/seatgroup/list', { place_id: placeId }, function(groupList) {
                groupList.forEach(function(group) {
                    $('#groupSelect').append('<option value="' + group.seat_group_id + '">' + group.seat_group_name + '</option>');
                });
            });
        });

        // 2. 공연 선택 시 -> 회차 목록 불러오기
        $('#workSelect').on('change', function() {
            var workId = $(this).val();
            $('#roundSelect').empty().append('<option value="">회차 선택</option>');
            if (!workId) return;

            $.get(contextPath + '/admin/roundseat/roundList', { work_id: workId }, function(data) {
                data.forEach(function(round) {
                    var roundText = round.round_date + ' (' + round.round_start_time + ')';
                    $('#roundSelect').append('<option value="' + round.round_id + '">' + roundText + '</option>');
                });
            });
        });

        // 3. 좌석 불러오기
        $('#btnLoadSeats').on('click', function() {
            var roundId = $('#roundSelect').val();
            if (!roundId) { alert('회차를 선택해주세요.'); return; 
            }
            
            $.get(contextPath + '/admin/roundseat/list', { round_id: roundId }, function(seatList) {
                renderStatusMap(seatList);
            });
        });
    });
    /**
     * ✅ 좌석 배치도 렌더링 (상태 관리용)
     */
    function renderStatusMap(seatList) {
        var $container = $('#seatArea');
        $container.empty();
        
        seatList.forEach(function(seat) {
            // 상태값 (AVAILABLE, RESERVED, PREEMPTED, CANCELED)
            var sStatus = (seat.status || 'AVAILABLE').toUpperCase();
            var folder = "/static/assets/adminSeatImg/";
            
            // 이미지 파일명: AVAILABLE.png, RESERVED.png 등
            var finalImgUrl = contextPath + folder + sStatus + ".png";

            var $seatDiv = $('<div class="admin-seat" data-seat-id="' + seat.seat_id + '"></div>');
            $seatDiv.css({
                'position': 'absolute',
                'left': (seat.pos_x + (seat.seat_y - 1) * seat.col_gap) + 'px',
                'top': (seat.pos_y + (seat.seat_x.charCodeAt(0) - 65) * seat.row_gap) + 'px',
                'background-image': "url('" + finalImgUrl + "')",
                'background-size': 'cover',
                'width': '25px', 
                'height': '25px', 
                'cursor': 'pointer',
                'box-sizing': 'border-box'
            });
            
            // 좌석 클릭 시 전역 변수에 ID 저장 및 UI 표시
            $seatDiv.on('click', function() {
                selectedSeatId = seat.seat_id;
                $('#selName').text(seat.seat_name);
                $('#selState').text(sStatus);
                
                // 선택 표시 (노란 테두리)
                $('.admin-seat').css('border', 'none');
                $(this).css('border', '2px solid yellow');
            });

            $container.append($seatDiv);
        });
    }

    /**
     * ✅ 버튼 클릭 시 호출되는 상태 변경 함수
     * @param status 'AVAILABLE' | 'RESERVED' | 'PREEMPTED' | 'CANCELED'
     */
    function changeStatus(status) {
        var roundId = $('#roundSelect').val();
        
        if(!roundId) { 
            alert('회차를 먼저 선택해주세요.'); 
            return; 
        }
        if(!selectedSeatId) { 
            alert('변경할 좌석을 먼저 선택해주세요.'); 
            return; 
        }

        if(confirm('선택한 좌석의 상태를 ' + status + '(으)로 변경하시겠습니까?')) {
            $.post(contextPath + '/admin/roundseat/updateStatus', {
                round_id: roundId,
                seat_id: selectedSeatId,
                status: status
            }, function(res) {
                if(res === 'success') {
                    alert('상태가 정상적으로 변경되었습니다.');
                    // 🔄 변경된 이미지를 확인하기 위해 목록 다시 불러오기
                    $('#btnLoadSeats').click(); 
                    
                    // 상세 정보 창 초기화 (선택 해제 대응)
                    selectedSeatId = null;
                    $('#selName').text('-');
                    $('#selState').text('-');
                } else {
                    alert('변경 실패: ' + res);
                }
            }).fail(function() {
                alert('서버와의 통신에 실패했습니다.');
            });
        }
    }
</script>

</body>
</html>