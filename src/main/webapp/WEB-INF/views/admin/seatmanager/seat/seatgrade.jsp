<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ch.tickethub.dto.Place"%>
<%@ page import="java.util.List"%>
<%
    String contextPath = request.getContextPath();
    // 서버 컨텍스트에서 전달된 장소 목록
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
    <script src="<%=contextPath%>/static/assets/js/seat-common.js" charset="UTF-8"></script>
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
            <div id="seatArea">
                </div>
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
                구역 위치 저장
            </button>
        </div>
    </div>

<script>
    /**
     * 1. 좌석 데이터 로드
     * seat-common.js의 renderStatusMap을 'grade' 모드로 호출합니다.
     */
    function loadSeatLayout() {
        var roundId = $('#roundSelect').val();
        if (!roundId) return alert('회차를 선택해주세요.');
        
        $.get(contextPath + '/admin/roundseat/list', { round_id: roundId }, function(list) {
            if(!list || list.length === 0) {
                alert("해당 회차에 등록된 좌석이 없습니다.");
                $('#seatArea').empty();
                return;
            }
            // 'grade' 모드로 호출하여 등급별 이미지가 나오게 함
            renderStatusMap(list, 'grade'); 
        });
    }

    /**
     * 2. 선택된 좌석 등급 일괄 변경
     */
    function changeGrade(gradeId) {
        // selectedSeatIds는 seat-common.js에서 관리하는 전역 변수
        if (typeof selectedSeatIds === 'undefined' || selectedSeatIds.length === 0) {
            return alert("등급을 변경할 좌석을 먼저 선택하세요.");
        }
        
        if (!confirm(selectedSeatIds.length + "개 좌석의 등급을 변경하시겠습니까?")) return;

        // Ajax 요청들을 배열로 생성
        var requests = selectedSeatIds.map(function(id) {
            return $.post(contextPath + '/admin/seatmanager/seat/grade/update', { 
                seat_id: id, 
                seat_grade_id: gradeId 
            });
        });
        
        // 모든 요청이 완료되면 알림창 띄우고 새로고침
        Promise.all(requests).then(function() { 
            alert("등급 변경이 완료되었습니다."); 
            loadSeatLayout(); 
        }).catch(function(err) {
            alert("일부 좌석 변경 중 오류가 발생했습니다.");
        });
    }

    /**
     * 3. 선택 정보 업데이트 (JSP 커스텀)
     * seat-common.js에서 좌석 클릭/드래그 시 이 함수를 호출합니다.
     */
    function updateSelectionInfo(info) {
        $('#selName').text(selectedSeatIds.length > 0 ? selectedSeatIds.length + "개 선택" : "-");
        $('#selState').text(info || (selectedSeatIds.length > 1 ? "MULTI" : "-"));
    }
</script>

</body>
</html>