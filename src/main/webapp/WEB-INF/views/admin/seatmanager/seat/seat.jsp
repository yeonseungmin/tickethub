<%@page import="com.ch.tickethub.dto.SeatGroup"%>
<%@page import="com.ch.tickethub.dto.Seat"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- 공통 헤더 CSS -->
<link rel="stylesheet" href="./inc/header.css">

<!-- 좌석 관리자 CSS -->
<link rel="stylesheet" href="/static/assets/css/seat.css">

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<!-- ===================== -->
<!-- 상단 네비게이션 -->
<!-- ===================== -->
<div class="topnav">
  <a class="nav-link registform" href="#">작품 등록</a>
  <a class="nav-link list" href="#">작품 목록</a>
  <a class="nav-link delete" href="#">작품 삭제</a>
  <a class="nav-link update" href="#">작품 수정</a>
</div>

<div style="padding-left:16px"></div>

<!-- content.jsp 포함 -->
<%@ include file="../inc/content.jsp" %>

<!-- ===================== -->
<!-- 좌석 관리자 메인 -->
<!-- ===================== -->
<div class="content">

    <div class="admin-seat-wrapper">

        <!-- ===================== -->
        <!-- 좌측: 좌석 배치도 -->
        <!-- ===================== -->
        <div class="seat-map-container">

            <div style="text-align:center;
                        color:#444;
                        font-size:24px;
                        letter-spacing:15px;
                        margin-bottom:60px;">
                S T A G E
            </div>

            <%
                // 컨트롤러에서 내려온 데이터 (나중에 연결)
                List<Seat> seatList =
                    (List<Seat>)request.getAttribute("seatList");

                List<SeatGroup> seatGroupList =(List<com.ch.tickethub.dto.SeatGroup>)request.getAttribute("seatGroupList");

               
               
                if(seatGroupList != null){
                    for(com.ch.tickethub.dto.SeatGroup group : seatGroupList){
            %>
                <div class="sector-group"
                     style="left:<%=group.getPos_x()%>px; top:<%=group.getPos_y()%>px;">

                    <div class="group-label"><%=group.getGroup_name()%></div>

                    <%
                        if(seatList != null){
                            for(com.ch.tickethub.dto.Seat seat : seatList){
                                if(seat.getSeat_group_id() == group.getSeat_group_id()){
                    %>
                        <img src="/resources/images/seat/default.png"
                             class="seat-box"
                             id="seat-<%=seat.getSeat_id()%>"
                             data-name="<%=seat.getSeat_name()%>"
                             data-floor="<%=seat.getFloor()%>"
                             data-state="<%=seat.getSeat_state()%>"
                             onclick="selectSeat(<%=seat.getSeat_id()%>)">
                    <%
                                }
                            }
                        }
                    %>
                </div>
            <%
                    }
                }
            %>

        </div>

        <!-- ===================== -->
        <!-- 우측: 선택 패널 -->
        <!-- ===================== -->
        <div class="management-side-panel">

            <h3 style="margin-top:0; color:#007bff;">Seat Manager</h3>

            <div id="selection-display">
                <p>좌석번호: <strong id="selName">-</strong></p>
                <p>층수: <span id="selFloor">-</span>층</p>
                <p>상태: <span id="selState">-</span></p>
            </div>

            <button class="admin-btn" style="background:#28a745"
                    onclick="changeStatus('AVAILABLE')">AVAILABLE</button>

            <button class="admin-btn" style="background:#ffc107; color:#000"
                    onclick="changeStatus('PREEMPTED')">PREEMPTED</button>

            <button class="admin-btn" style="background:#dc3545"
                    onclick="changeStatus('RESERVED')">RESERVED</button>

            <button class="admin-btn" style="background:#6c757d"
                    onclick="changeStatus('CANCELED')">CANCELED</button>
        </div>

    </div>
</div>

<script>
let selectedSeatId = null;

function selectSeat(seatId) {
    selectedSeatId = seatId;

    const el = $("#seat-" + seatId);

    $(".seat-box").removeClass("active-select");
    el.addClass("active-select");

    $("#selName").text(el.data("name"));
    $("#selFloor").text(el.data("floor"));
    $("#selState").text(el.data("state"));
}

function changeStatus(status) {
    if (!selectedSeatId) {
        alert("좌석을 선택하세요");
        return;
    }

    $.ajax({
        url: "/admin/seat/status/update",
        type: "POST",
        data: {
            seat_id: selectedSeatId,
            seat_state: status
        },
        success: function () {
            alert("상태 변경 완료");
            location.reload();
        }
    });
}
</script>

</body>
</html>
