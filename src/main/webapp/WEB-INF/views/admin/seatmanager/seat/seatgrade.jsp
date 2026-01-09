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
		    <button class="status-btn" onclick="changeGrade(1)">VIP</button>
		    <button class="status-btn" onclick="changeGrade(2)">R석</button>
		    <button class="status-btn" onclick="changeGrade(3)">S석</button>
		    <button class="status-btn" onclick="changeGrade(4)">A석</button>
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
        // 1. 장소 선택 시 -> 공연 목록 및 구역(Group) 목록 불러오기
        $('#placeSelect').on('change', function() {
            var placeId = $(this).val();
            
            // 하위 선택창들 초기화
            $('#workSelect').empty().append('<option value="">공연 선택</option>');
            $('#roundSelect').empty().append('<option value="">회차 선택</option>');
            $('#groupSelect').empty().append('<option value="">구역 선택</option>'); 
            
            if (!placeId) return;

            // 공연 목록 로드
            $.get(contextPath + '/admin/roundseat/workList', { place_id: placeId }, function(data) {
                data.forEach(function(work) {
                    $('#workSelect').append('<option value="' + work.work_id + '">' + work.work_title + '</option>');
                });
            });

            // 구역 목록 로드 (좌석 자동 생성 시 필요)
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
            if (!roundId) { 
                alert('회차를 선택해주세요.'); 
                return; 
            }
            
            $.get(contextPath + '/admin/roundseat/list', { round_id: roundId }, function(seatList) {
                renderGradeMap(seatList);
            });
        });
    });

    // 등급 관리용 렌더링 함수
    function renderGradeMap(seatList) {
        var $container = $('#seatArea');
        $container.empty();
        
        seatList.forEach(function(seat) {
            var grade = (seat.grade_name || 'A').toLowerCase();
            var folder = "/static/assets/seatImg/";
            
            // 기존 이미지 규칙 유지 (abailable_ 오타 포함)
            var fileName = (grade === 'vip' || grade === 'r' || grade === 's') 
                           ? "abailable_" + grade + ".jpg" : "available_a.jpg";
            
            var finalImgUrl = contextPath + folder + fileName;

            var $seatDiv = $('<div class="admin-seat-grade" data-seat-id="' + seat.seat_id + '"></div>');
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

            // 클릭 시 정보 표시 및 선택 효과
            $seatDiv.on('click', function() {
                selectedSeatId = seat.seat_id;
                $('#selName').text(seat.seat_name);
                $('#selState').text(grade.toUpperCase());
                
                // 선택 표시 (노란 테두리)
                $('.admin-seat-grade').css('border', 'none');
                $(this).css('border', '2px solid yellow');
            });

            $container.append($seatDiv);
        });
    }

    // 등급 변경 함수
    function changeGrade(gradeId) {
        if(!selectedSeatId) { 
            alert('좌석을 먼저 선택하세요.'); 
            return; 
        }
        
        $.post(contextPath + '/admin/seatmanager/seat/grade/update', {
            seat_id: selectedSeatId,
            seat_grade_id: gradeId
        }, function(res) {
            if(res === 'success') {
                alert('등급이 변경되었습니다.');
                $('#btnLoadSeats').click(); // 목록 새로고침
            } else {
                alert('변경 실패: ' + res);
            }
        });
    }

    // 좌석 자동 생성 실행 (참고 코드의 기능 추가)
    function createSeats() {
        var groupId = $('#groupSelect').val();
        var rows = $('#rowCount').val();
        var cols = $('#colCount').val();

        if(!groupId || !rows || !cols) {
            alert('구역과 행/열 개수를 모두 입력해주세요.');
            return;
        }

        if(confirm(rows + '행 ' + cols + '열 좌석을 생성하시겠습니까?')) {
            $.post(contextPath + '/admin/seatmanager/seat/state/createBulk', {
                seat_group_id: groupId,
                row_count: rows,
                col_count: cols
            }, function(res) {
                if(res === 'success') {
                    alert('좌석이 생성되었습니다.');
                } else {
                    alert('생성 실패: ' + res);
                }
            });
        }
    }
</script>

</body>
</html>