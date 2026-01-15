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
            <div id="seatArea">
	             <div class="floor-label" style="top: 0px;">─── 1st FLOOR ───</div>
	            <div class="floor-label floor-2-label" style="top: 600px;">─── 2nd FLOOR ───</div>
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
                등급 저장
            </button>
        </div>
    </div>

<script>
    /* 1. 전역 변수 설정 */
    window.selectedSeatIds = [];
    window.selectedSeatObjs = []; 
    window.pendingChanges = {}; 
    
    var isSelecting = false;
    var startX, startY;
    var $selectionBox = $('<div id="selection-box" class="selection-box"></div>');

    $(document).ready(function() {
        // [좌석 불러오기] 버튼 연동
        $('#btnLoadSeats').on('click', function() {
            loadSeatLayout();
        });

        /* --- 드래그 범위 선택(Lasso) 로직 추가 --- */
        $('#seatArea').on('mousedown', function(e) {
            // 좌석이나 구역 박스를 직접 클릭한 경우 드래그 무시
            if ($(e.target).closest('.admin-seat, .group-boundary-box').length > 0) return;
            
            isSelecting = true;
            var containerOffset = $(this).offset();
            startX = e.pageX - containerOffset.left;
            startY = e.pageY - containerOffset.top;
            
            $('#selection-box').remove();
            $selectionBox.css({ 
                left: startX, top: startY, width: 0, height: 0, display: 'block' 
            }).appendTo('#seatArea');

            // Ctrl 키를 안 누르고 드래그 시작 시 기존 선택 초기화
            if (!e.ctrlKey) {
                $('.admin-seat').removeClass('selected-multi');
                window.selectedSeatIds = [];
                window.selectedSeatObjs = [];
                updateSelectionInfo("-");
            }
        });

        $(document).on('mousemove', function(e) {
            if (!isSelecting) return;

            var containerOffset = $('#seatArea').offset();
            var currentX = e.pageX - containerOffset.left;
            var currentY = e.pageY - containerOffset.top;
            
            var width = Math.abs(currentX - startX);
            var height = Math.abs(currentY - startY);
            var left = Math.min(currentX, startX);
            var top = Math.min(currentY, startY);
            
            $('#selection-box').css({ left: left, top: top, width: width, height: height });

            // 범위 내 좌석 실시간 체크
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
        });

        $(document).on('mouseup', function() {
            if (isSelecting) {
                $('#selection-box').hide();
                isSelecting = false;
            }
        });
    });

    /**
     * 2. 좌석 레이아웃 로드
     */
    function loadSeatLayout() {
        var roundId = $('#roundSelect').val();
        if (!roundId) { alert("회차를 선택해주세요."); return; }

        window.selectedSeatIds = [];
        window.selectedSeatObjs = [];
        window.pendingChanges = {}; 
        updateSelectionInfo("-"); 

        $.get(contextPath + '/admin/roundseat/list', { round_id: roundId }, function(list) {
            if (!list || list.length === 0) {
                alert("데이터가 없습니다.");
                $('#seatArea').empty();
                return;
            }
            renderStatusMap(list);
        });
    }

    /**
     * 3. 렌더링 함수 (가로 숫자/세로 알파벳 매핑)
     */
    function renderStatusMap(seatList) {
        var $container = $('#seatArea').empty();
        $container.append('<div class="floor-label" style="top: 0px;">─── 1st FLOOR ───</div>');
        $container.append('<div class="floor-label floor-2-label" style="top: 600px;">─── 2nd FLOOR ───</div>');
        
        var groups = {};
        seatList.forEach(function(seat) {
            if (!groups[seat.seat_group_id]) {
                groups[seat.seat_group_id] = {
                    name: seat.group_name || '구역',
                    angle: seat.angle || 0,
                    posX: seat.pos_x, posY: seat.pos_y,
                    maxX: 0, maxY: 0
                };
            }
            // 가로 숫자(seat_y), 세로 알파벳(seat_x)
            var rx = (seat.seat_y - 1) * (seat.col_gap || 35);
            var ry = (seat.seat_x.charCodeAt(0) - 65) * (seat.row_gap || 35);
            var g = groups[seat.seat_group_id];
            if (rx > g.maxX) g.maxX = rx; 
            if (ry > g.maxY) g.maxY = ry;
        });

        Object.keys(groups).forEach(function(id) {
            var g = groups[id];
            var $box = $('<div class="group-boundary-box"></div>')
                .css({
                    left: g.posX + 'px', top: g.posY + 'px',
                    width: (g.maxX + 72) + 'px', height: (g.maxY + 72) + 'px',
                    position: 'absolute', transform: 'rotate(' + g.angle + 'deg)',
                    'transform-origin': '0 0' 
                }).appendTo($container);

            $box.append($('<div class="group-name-label"></div>').text(g.name));
            
            seatList.filter(s => s.seat_group_id == id).forEach(function(seat) {
                var relX = (seat.seat_y - 1) * (seat.col_gap || 35) + 20;
                var relY = (seat.seat_x.charCodeAt(0) - 65) * (seat.row_gap || 35) + 20;
                var seatLabel = seat.seat_x + "행 " + seat.seat_y + "열";
                
                var rawGrade = seat.grade_name || "A"; 
                var gradeType = (['vip', 'r', 's'].indexOf(rawGrade.toLowerCase()) > -1) ? rawGrade.toLowerCase() : 'a';
                var imgUrl = contextPath + "/static/assets/seatImg/available_" + gradeType + ".jpg";

                $('<div class="admin-seat"></div>')
                    .attr({ 'data-seat-id': seat.seat_id, 'data-label': seatLabel })
                    .css({ 
                        left: relX + 'px', top: relY + 'px', 
                        backgroundImage: "url('" + imgUrl + "')", position: 'absolute'
                    })
                    .on('click', function(e) {
                        e.stopPropagation();
                        var sId = String(seat.seat_id);
                        if (e.ctrlKey) {
                            if (window.selectedSeatIds.includes(sId)) {
                                window.selectedSeatIds = window.selectedSeatIds.filter(id => id !== sId);
                                window.selectedSeatObjs = window.selectedSeatObjs.filter(o => o.id !== sId);
                                $(this).removeClass('selected-multi');
                            } else {
                                window.selectedSeatIds.push(sId);
                                window.selectedSeatObjs.push({id: sId, label: seatLabel});
                                $(this).addClass('selected-multi');
                            }
                        } else {
                            $('.admin-seat').removeClass('selected-multi');
                            window.selectedSeatIds = [sId];
                            window.selectedSeatObjs = [{id: sId, label: seatLabel}];
                            $(this).addClass('selected-multi');
                        }
                        updateSelectionInfo(rawGrade.toUpperCase());
                    })
                    .appendTo($box);
            });
        });
    }

    /**
     * 4. 정보창 업데이트
     */
    function updateSelectionInfo(gradeName) {
        var count = window.selectedSeatIds.length;
        var nameText = "-";
        if (count > 0) {
            nameText = window.selectedSeatObjs[0].label;
            if (count > 1) nameText += " 외 " + (count - 1) + "개";
        }
        $('#selName').html(nameText);
        
        if (count === 0) $('#selState').text("-");
        else if (count > 1) $('#selState').text(count + "개 선택됨");
        else $('#selState').text(gradeName || "-");
    }

    /**
     * 5. 등급 임시 변경
     */
    function changeGrade(gradeId) {
        if (window.selectedSeatIds.length === 0) return alert("좌석을 선택하세요.");
        var gradeMap = { 1: 'vip', 2: 'r', 3: 's', 4: 'a' };
        var gradeType = gradeMap[gradeId];
        var imgUrl = contextPath + "/static/assets/seatImg/available_" + gradeType + ".jpg";

        window.selectedSeatIds.forEach(function(id) {
            window.pendingChanges[id] = gradeId;
            $('.admin-seat[data-seat-id="' + id + '"]').css({
                'background-image': "url('" + imgUrl + "')",
                'outline': '2px solid #2563eb'
            });
        });
    }

    /**
     * 6. 서버 최종 저장
     */
    function saveBatchLayout() {
        var seatIds = Object.keys(window.pendingChanges);
        if (seatIds.length === 0) return alert("변경된 내용이 없습니다.");
        if (!confirm(seatIds.length + "개 좌석 등급을 저장하시겠습니까?")) return;

        var requests = seatIds.map(function(id) {
            return $.post(contextPath + '/admin/roundseat/updateGrade', { 
                seat_id: id, seat_grade_id: window.pendingChanges[id] 
            });
        });

        Promise.all(requests).then(function() {
            alert("저장 성공");
            window.pendingChanges = {}; 
            loadSeatLayout(); 
        });
    }
</script>
</body>
</html>