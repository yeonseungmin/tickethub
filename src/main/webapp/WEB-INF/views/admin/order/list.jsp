<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid">
    <div class="dashboard-header">
        <h1>주문 정보</h1>
        <p>전체 예매 및 결제 내역을 확인합니다.</p>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="card dashboard-card">
                <div class="card-header">
                    <h3 class="card-title"><i class="fas fa-shopping-cart mr-2"></i>최신 주문 내역</h3>
                </div>
                <div class="card-body" style="max-height: 650px; overflow-y: auto;">
                    <c:choose>
                        <c:when test="${not empty orders}">
                            <c:forEach var="order" items="${orders}">
                                <div class="schedule-item" style="padding: 15px; border-bottom: 1px solid #f4f4f4; display: flex; align-items: center;">
                                    <!-- 주문 일시 -->
                                    <span class="schedule-date" style="width: 160px; font-size: 14px;">
                                        <fmt:formatDate value="${order.regdate}" pattern="yyyy-MM-dd HH:mm"/>
                                    </span>
                                    
                                    <!-- 구매자 (장르 태그 스타일 활용) -->
                                    <span class="schedule-genre" style="background: rgba(99, 102, 241, 0.1); color: #6366f1; min-width: 80px; text-align: center;">
                                        ${order.member_name}
                                    </span>
                                    
                                    <!-- 공연 제목 -->
                                    <span style="flex: 1; font-weight: 500; margin-left: 15px;">${order.work_title}</span>
                                    
                                    <!-- 매수 -->
                                    <span style="width: 80px; text-align: center; color: #666; font-size: 13px;">
                                        ${order.seat_count}매
                                    </span>
                                    
                                    <!-- 결제 금액 -->
                                    <span style="width: 130px; text-align: right; font-weight: 700; color: #10b981; font-size: 15px;">
                                        ₩<fmt:formatNumber value="${order.total_paid}" type="number"/>
                                    </span>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; color: #aaa; padding: 80px 0;">
                                <i class="fas fa-info-circle mb-2" style="font-size: 24px;"></i>
                                <p>주문 내역이 존재하지 않습니다.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>
