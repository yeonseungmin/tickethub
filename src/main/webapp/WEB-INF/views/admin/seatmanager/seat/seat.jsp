<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tickethub.model.SeatDetailDTO" %> 

<div class="admin-seat-wrapper">
    <div class="management-side-panel">
        <h3 style="margin-top:0; color:#007bff;">Seat Manager</h3>
        
        <div id="selection-display" style="background:#1e1e1e; padding:20px; margin:20px 0; border-radius:8px;">
            <p>좌석번호: <strong id="selName" style="color:#fff">-</strong></p>
            <p>층수: <span id="selFloor">-</span>층</p>
            <p>등급: <span id="selGrade">-</span></p>
            <p>현재상태: <span id="selStatus" style="font-weight:bold;">-</span></p>
        </div>

        <p style="font-size:12px; color:#aaa; margin-bottom:10px;">상태 강제 변경 (DB ENUM)</p>
        <button class="admin-btn" style="background:#28a745" onclick="processStatus('AVAILABLE')">AVAILABLE (예매가능)</button>
        <button class="admin-btn" style="background:#ffc107; color:#000" onclick="processStatus('PREEMPTED')">PREEMPTED (홀딩)</button>
        <button class="admin-btn" style="background:#dc3545" onclick="processStatus('RESERVED')">RESERVED (예약완료)</button>
        <button class="admin-btn" style="background:#6c757d" onclick="processStatus('CANCELED')">CANCELED (취소)</button>
    </div>

    <div class="seat-map-container">
        <div style="text-align:center; color:#444; font-size:24px; letter-spacing:15px; margin-bottom:60px;">S T A G E</div>
        
        <%
            List<SeatDetailDTO> list = (List<SeatDetailDTO>)request.getAttribute("roundSeatList");
            String currentGroup = ""; // 구역(place_id 내 group_name 역할) 체킹

            if(list != null) {
                for(SeatDetailDTO rs : list) {
                    // 구역(Group)이 바뀔 때만 새로운 감싸는 div 생성
                    if(!currentGroup.equals(rs.getGroupName())) {
                        if(!currentGroup.equals("")) out.print("</div>"); 
                        currentGroup = rs.getGroupName();
                        
                        // Seat 테이블의 seat_x, seat_y를 구역의 절대 위치로 사용
                        out.print("<div class='sector-group' style='left:" + rs.getSeatX() + "px; top:" + rs.getSeatY() + "px;'>");
                        out.print("<div class='group-label'>" + currentGroup + "</div>");
                    }
                    
                    // 상태(Status)에 따라 Seat_grade의 이미지 매핑
                    String imgUrl = rs.getOffImgUrl(); // 기본
                    String status = rs.getStatus(); // AVAILABLE, PREEMPTED, RESERVED, CANCELED
                    
                    if("AVAILABLE".equals(status)) imgUrl = rs.getOnImgUrl();
                    else if("RESERVED".equals(status)) imgUrl = rs.getSoldImgUrl();
                    else if("PREEMPTED".equals(status)) imgUrl = rs.getOffImgUrl(); // 또는 별도 점유이미지
        %>
                    <img src="<%= imgUrl %>" 
                         class="seat-box" 
                         id="seat-<%= rs.getSeatId() %>"
                         data-name="<%= rs.getSeatName() %>"
                         data-floor="<%= rs.getFloor() %>"
                         data-grade="<%= rs.getGradeName() %>"
                         data-status="<%= rs.getStatus() %>"
                         onclick="handleSeatClick('<%= rs.getSeatId() %>')">
        <%
                }
                out.print("</div>"); 
            }
        %>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
let activeId = null;

function handleSeatClick(id) {
    activeId = id;
    const $el = $("#seat-" + id);
    
    $(".seat-box").removeClass("active-select");
    $el.addClass("active-select");

    // UI 데이터 업데이트
    $("#selName").text($el.data("name"));
    $("#selFloor").text($el.data("floor"));
    $("#selGrade").text($el.data("grade"));
    $("#selStatus").text($el.data("status"));
}

function processStatus(status) {
    if(!activeId) return alert("좌석을 선택해주세요.");
    
    $.ajax({
        url: "/admin/seat/updateStatus",
        type: "POST",
        data: {
            seat_id: activeId,
            status: status,
            round_id: "<%= request.getAttribute("roundId") %>"
        },
        success: function(res) {
            alert("상태가 " + status + "로 변경되었습니다.");
            location.reload();
        }
    });
}
</script>