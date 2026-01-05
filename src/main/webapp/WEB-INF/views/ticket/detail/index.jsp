<%@page import="com.ch.tickethub.dto.Work"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Work work = (Work)request.getAttribute("work");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공연 상세 정보</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <style>
        /* [스타일] Sticky Sidebar */
        .sticky-sidebar { position: -webkit-sticky; position: sticky; top: 20px; z-index: 1000; }

        /* [스타일] 탭 메뉴 커스텀 */
        .custom-tabs .nav-link { color: #333; font-weight: 600; border-radius: 0; }
        .custom-tabs .nav-link.active { color: #007bff !important; border-top: 3px solid #007bff; background-color: #fff; }

        /* [스타일] 달력 */
        .calendar-table { width: 100%; text-align: center; font-size: 14px; }
        .calendar-table th { padding: 8px 0; font-weight: normal; }
        .calendar-table th.sun { color: #dc3545; }
        .calendar-day {
            padding: 8px; cursor: pointer; border-radius: 50%; width: 35px; height: 35px; line-height: 19px; margin: 2px auto;
        }
        .calendar-day:hover:not(.disabled) { background-color: #f0f0f0; }
        .calendar-day.disabled { color: #ccc; cursor: default; }
        .calendar-day.sun:not(.disabled) { color: #dc3545; }
        .calendar-day.active {
            background-color: #007bff; color: white !important; font-weight: bold; box-shadow: 0 2px 5px rgba(0,123,255,0.4);
        }

        /* [스타일] 회차 선택 버튼 */
        .btn-round-select {
            border: 1px solid #ccc; color: #888; background-color: white; margin-right: 5px; margin-bottom: 5px; width: 80px;
        }
        .btn-round-select.active {
            border: 2px solid #007bff !important; color: #007bff !important; font-weight: bold;
        }

        /* [스타일] 상세 정보 리스트 */
        .info-list li {
            margin-bottom: 16px; 
            font-size: 15px; 
            border-bottom: 1px solid #f9f9f9; 
            padding-bottom: 16px;
        }
        .info-list li:last-child { border-bottom: none; }
        .info-label { display: inline-block; width: 80px; font-weight: bold; color: #555; vertical-align: top; margin-top: 2px; }
        
        /* info-content: 기본적으로 inline-block이지만, 장소 등에서 flex 필요시 유틸리티 클래스 추가 사용 */
        .info-content { display: inline-block; width: calc(100% - 90px); vertical-align: top; line-height: 1.6; }
        
        /* 가격 강조 스타일 */
        .price-emphasis { font-weight: 700; font-size: 1.1em; color: #333; margin-right: 2px; }

        /* [스타일] 캐스팅 리스트 (본문용) */
        .cast-member { text-align: center; margin-right: 20px; margin-bottom: 20px; width: 90px; display: inline-block; vertical-align: top;}
        .cast-img { width: 80px; height: 80px; object-fit: cover; border-radius: 50%; border: 1px solid #eee; margin-bottom: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .casting-container { max-height: 140px; overflow: hidden; transition: max-height 0.5s ease; }
        .casting-container.expanded { max-height: 2000px; }

        /* [스타일] 좋아요 버튼 */
        .btn-like-wrapper { margin-top: 15px; text-align: center; }
        .btn-like {
            border: none; background: transparent; padding: 5px 10px; color: #555; font-weight: bold; font-size: 1.1em;
            transition: transform 0.2s;
        }
        .btn-like:hover { transform: scale(1.1); color: #dc3545; }
        .btn-like.active { color: #dc3545; }
        
        /* [스타일] 사이드바 컴팩트 텍스트 */
        .sidebar-compact-text { font-size: 14px; line-height: 1.6; color: #333; }
        .text-soldout { color: #aaa !important; text-decoration: line-through; }
        .divider-slash { color: #ddd; margin: 0 5px; }

    </style>
</head>
<body class="layout-top-nav" style="background-color: #ffffff;">
<% System.out.println(work); %>
<div class="wrapper">
    <div class="content-wrapper">
        <div class="container pt-5">
            <div class="row">
                <div class="col-lg-8">
                    
                    <div class="mb-4 pb-3 border-bottom">
                        <h1 class="font-weight-bold mb-2" style="font-size: 32px;"><%=work.getWork_title() %></h1>
                        <div class="d-flex align-items-center">
                            <span class="badge badge-warning text-white mr-2 px-2 py-1" style="font-size: 14px;"><%=work.getGenre().getGenre_name() %> 1위</span>
                            <span class="text-warning mr-1"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></span>
                            <span class="font-weight-bold text-dark" style="font-size: 18px;">9.8</span>
                            <span class="text-muted ml-2 text-sm">(리뷰 1,240개)</span>
                        </div>
                    </div>

                    <div class="row mb-5">
                        
                        <div class="col-md-4">
                            <img src="/photo/work/p<%=work.getWork_id() %>/<%=work.getWork_poster_url() %>" class="img-fluid rounded shadow" style="width: 100%;">
                            
                            <div class="btn-like-wrapper">
                                <button class="btn btn-like" onclick="toggleLike(this)">
                                    <i class="far fa-heart mr-1"></i> <span id="likeCount"><%=work.getWork_like_count() %></span>
                                </button>
                            </div>
                        </div>

                        <div class="col-md-8 pl-md-5">
                            <ul class="list-unstyled info-list mt-1"> 
                                <li>
                                    <span class="info-label">장소</span>
                                    <span class="info-content d-inline-flex align-items-center">
                                        <span>블루스퀘어 신한카드홀</span>
                                        <button class="btn btn-xs btn-outline-secondary ml-2 rounded-circle" onclick="openPlacePopup()" title="지도 보기"><i class="fas fa-map-marker-alt"></i></button>
                                    </span>
                                </li>
                                <li>
                                    <span class="info-label">공연기간</span>
                                    <span class="info-content">2025.12.01 ~ 2026.02.28</span>
                                </li>
                                <li>
                                    <span class="info-label">공연시간</span>
                                    <span class="info-content">180분 (인터미션 20분)</span>
                                </li>
                                <li>
                                    <span class="info-label">관람연령</span>
                                    <span class="info-content">8세 이상 관람가</span>
                                </li>
                                <li>
                                    <span class="info-label">가격</span>
                                    <span class="info-content">
                                        VIP석 <span class="price-emphasis">170,000</span>원 <br>
                                        R석 <span class="price-emphasis">140,000</span>원 <br>
                                        S석 <span class="price-emphasis">110,000</span>원 <br>
                                        A석 <span class="price-emphasis">80,000</span>원
                                    </span>
                                </li>
                                <li>
                                    <span class="info-label">주최/기획</span>
                                    <span class="info-content">레미제라블코리아</span>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="card card-primary card-outline card-outline-tabs border-0 mt-5">
                        <div class="card-header p-0 border-bottom-0">
                            <ul class="nav nav-tabs custom-tabs" id="custom-tabs-four-tab" role="tablist">
                                <li class="nav-item">
                                    <a class="nav-link active" id="tab-info" data-toggle="pill" href="#content-info" role="tab" onclick="loadTab('info')">공연정보</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="tab-casting" data-toggle="pill" href="#content-casting" role="tab" onclick="loadTab('casting')">캐스팅정보</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="tab-sales" data-toggle="pill" href="#content-sales" role="tab" onclick="loadTab('sales')">판매정보</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="tab-review" data-toggle="pill" href="#content-review" role="tab" onclick="loadTab('review')">관람후기</a>
                                </li>
                            </ul>
                        </div>
                        <div class="card-body p-0">
                            <div class="tab-content">
                                <div class="tab-pane fade show active" id="content-info">
                                    
                                    <div class="p-4 bg-light mb-4">
                                        <h5 class="font-weight-bold mb-3">캐스팅</h5>
                                        <div class="casting-container" id="castingList">
                                            <div class="cast-member"><img src="https://via.placeholder.com/80" class="cast-img"><div class="font-weight-bold text-sm">장발장</div><div class="text-muted text-xs">홍길동</div></div>
                                            <div class="cast-member"><img src="https://via.placeholder.com/80" class="cast-img"><div class="font-weight-bold text-sm">자베르</div><div class="text-muted text-xs">김철수</div></div>
                                            <div class="cast-member"><img src="https://via.placeholder.com/80" class="cast-img"><div class="font-weight-bold text-sm">팡틴</div><div class="text-muted text-xs">이영희</div></div>
                                            <div class="cast-member"><img src="https://via.placeholder.com/80" class="cast-img"><div class="font-weight-bold text-sm">코제트</div><div class="text-muted text-xs">박민수</div></div>
                                            <div class="cast-member"><img src="https://via.placeholder.com/80" class="cast-img"><div class="font-weight-bold text-sm">마리우스</div><div class="text-muted text-xs">최지우</div></div>
                                            <div class="cast-member"><img src="https://via.placeholder.com/80" class="cast-img"><div class="font-weight-bold text-sm">앙졸라</div><div class="text-muted text-xs">정재영</div></div>
                                        </div>
                                        <div class="text-center mt-2">
                                            <button type="button" class="btn btn-sm btn-outline-secondary" id="btnMoreCasting" style="width: 200px; border-radius: 20px;">
                                                캐스팅 더보기 <i class="fas fa-chevron-down"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="text-center py-4">
                                        <h5 class="font-weight-bold mb-3 text-left pl-3">공연 상세 내용</h5>
                                        <img src="/photo/work/p<%=work.getWork_id() %>/<%=work.getWork_content_url() %>" class="img-fluid border">
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="content-casting"><div id="ajax-casting-area" class="py-5 text-center"><i class="fas fa-spinner fa-spin fa-2x"></i></div></div>
                                <div class="tab-pane fade" id="content-sales"><div id="ajax-sales-area" class="py-5 text-center"><i class="fas fa-spinner fa-spin fa-2x"></i></div></div>
                                <div class="tab-pane fade" id="content-review"><div id="ajax-review-area" class="py-5 text-center"><i class="fas fa-spinner fa-spin fa-2x"></i></div></div>
                            </div>
                        </div>
                    </div>
                </div>


                <div class="col-lg-4">
                    <div class="sticky-sidebar">
                        <div class="card shadow-sm border-0" style="border-top: 4px solid #007bff;">
                            
                            <div class="card-body p-3">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <button class="btn btn-sm btn-light rounded-circle"><i class="fas fa-chevron-left"></i></button>
                                    <h5 class="m-0 font-weight-bold">2026.01</h5>
                                    <button class="btn btn-sm btn-light rounded-circle"><i class="fas fa-chevron-right"></i></button>
                                </div>
                                <table class="calendar-table">
                                    <thead>
                                        <tr><th class="sun">일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th></tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><div class="calendar-day disabled sun">28</div></td><td><div class="calendar-day disabled">29</div></td><td><div class="calendar-day disabled">30</div></td><td><div class="calendar-day disabled">31</div></td><td><div class="calendar-day">1</div></td><td><div class="calendar-day">2</div></td><td><div class="calendar-day">3</div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="calendar-day sun active">4</div></td> <td><div class="calendar-day">5</div></td><td><div class="calendar-day">6</div></td><td><div class="calendar-day">7</div></td><td><div class="calendar-day">8</div></td><td><div class="calendar-day">9</div></td><td><div class="calendar-day">10</div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="calendar-day sun">11</div></td><td><div class="calendar-day">12</div></td><td><div class="calendar-day">13</div></td><td><div class="calendar-day">14</div></td><td><div class="calendar-day">15</div></td><td><div class="calendar-day">16</div></td><td><div class="calendar-day">17</div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="calendar-day sun">18</div></td><td><div class="calendar-day">19</div></td><td><div class="calendar-day">20</div></td><td><div class="calendar-day">21</div></td><td><div class="calendar-day">22</div></td><td><div class="calendar-day">23</div></td><td><div class="calendar-day">24</div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="calendar-day sun">25</div></td><td><div class="calendar-day">26</div></td><td><div class="calendar-day">27</div></td><td><div class="calendar-day">28</div></td><td><div class="calendar-day">29</div></td><td><div class="calendar-day">30</div></td><td><div class="calendar-day">31</div></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="dropdown-divider"></div>

                            <div class="card-body p-3">
                                <h6 class="font-weight-bold mb-2">회차 선택</h6>
                                <div>
                                    <button type="button" class="btn btn-round-select active" onclick="selectRound(this, 1)">14:00</button>
                                    <button type="button" class="btn btn-round-select" onclick="selectRound(this, 2)">19:00</button>
                                </div>
                            </div>

                            <div class="card-body p-3 bg-light" id="seat-info-area">
                                <h6 class="font-weight-bold mb-2" style="font-size: 14px;">잔여석 현황</h6>
                                <div class="sidebar-compact-text">
                                    <span class="font-weight-bold">VIP</span> 12석 <span class="divider-slash">/</span> 
                                    <span class="font-weight-bold">R</span> 45석 <span class="divider-slash">/</span> 
                                    <span class="font-weight-bold">S</span> 80석 <span class="divider-slash">/</span> 
                                    <span class="font-weight-bold">A</span> 150석
                                </div>
                            </div>

                            <div class="card-body p-3">
                                <h6 class="font-weight-bold mb-2">캐스팅</h6>
                                <div id="daily-casting-area" class="sidebar-compact-text">
                                    홍길동, 김철수, 이영희, 박민수
                                </div>
                            </div>

                            <div class="card-footer p-3">
                                <button class="btn btn-primary btn-block btn-lg font-weight-bold shadow">예매하기</button>
                            </div>

                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 1. 좋아요 버튼 토글
    function toggleLike(btn) {
        $(btn).toggleClass("active");
        let $icon = $(btn).find('i');
        let $count = $("#likeCount");
        let currentVal = parseInt($count.text().replace(/,/g, ''));

        if($(btn).hasClass("active")) {
            $icon.removeClass('far').addClass('fas');
            $count.text((currentVal + 1).toLocaleString());
        } else {
            $icon.removeClass('fas').addClass('far');
            $count.text((currentVal - 1).toLocaleString());
        }
    }

    // 2. 캐스팅 더보기
    $("#btnMoreCasting").click(function() {
        $("#castingList").toggleClass("expanded");
        let isExpanded = $("#castingList").hasClass("expanded");
        $(this).html(isExpanded ? '캐스팅 접기 <i class="fas fa-chevron-up"></i>' : '캐스팅 더보기 <i class="fas fa-chevron-down"></i>');
    });

    // 3. 회차 선택 (시뮬레이션)
    function selectRound(element, roundId) {
        $(".btn-round-select").removeClass("active");
        $(element).addClass("active");
        
        updateSideInfo(roundId);
    }

    function updateSideInfo(roundId) {
        if (roundId === 1) { // 14:00
            $("#seat-info-area .sidebar-compact-text").html(`
                <span class="font-weight-bold">VIP</span> <span class="text-soldout">매진</span> <span class="divider-slash">/</span> 
                <span class="font-weight-bold">R</span> 5석 <span class="divider-slash">/</span> 
                <span class="font-weight-bold">S</span> 20석 <span class="divider-slash">/</span> 
                <span class="font-weight-bold">A</span> 50석
            `);
            $("#daily-casting-area").text("홍길동, 김철수, 이영희, 박민수, 최지우");
        } else { // 19:00
             $("#seat-info-area .sidebar-compact-text").html(`
                <span class="font-weight-bold">VIP</span> 5석 <span class="divider-slash">/</span> 
                <span class="font-weight-bold">R</span> 10석 <span class="divider-slash">/</span> 
                <span class="font-weight-bold">S</span> 100석 <span class="divider-slash">/</span> 
                <span class="font-weight-bold">A</span> <span class="text-soldout">매진</span>
            `);
             $("#daily-casting-area").text("정재영, 홍길동, 박민수, 김영철, 하니");
        }
    }

    $(".calendar-day").not(".disabled").click(function() {
        $(".calendar-day").removeClass("active");
        $(this).addClass("active");
    });
</script>

</body>
</html>