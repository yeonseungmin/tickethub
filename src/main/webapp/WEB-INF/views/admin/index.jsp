<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="com.ch.tickethub.dto.Dashboard" %>
<%@ page import="com.ch.tickethub.dto.Genre" %>
<%@ page import="com.ch.tickethub.dto.Round" %>
<%@ page import="com.ch.tickethub.dto.Report" %>
<% 
    Dashboard dashboard = (Dashboard) request.getAttribute("dashboard"); 
    // null 체크 
    long totalRevenue = dashboard != null ? dashboard.getTotalRevenue() : 0L; 
    int totalMembers = dashboard != null ? dashboard.getTotalMembers() : 0; 
    int totalTickets = dashboard != null ? dashboard.getTotalTickets() : 0;
    int activeWorks = dashboard != null ? dashboard.getActiveWorks() : 0; 
    int pendingReports = dashboard != null ? dashboard.getPendingReports() : 0; 
    List<Genre> genreList = dashboard != null ? dashboard.getGenreList() : null;
    List<Round> upcomingRounds = dashboard != null ? dashboard.getUpcomingRounds() : null;
    List<Report> reportList = dashboard != null ? dashboard.getReportList() : null;

    NumberFormat nf = NumberFormat.getInstance();
%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>TicketHub 관리자 대시보드</title>
    <%@ include file="./inc/head_link.jsp" %>
    <link rel="stylesheet" href="/static/assets/css/admin.css">
</head>

<body class="hold-transition sidebar-mini layout-fixed">
    <div class="wrapper">

        <%@include file="./inc/preloader.jsp" %>

        <%@ include file="./inc/navbar.jsp" %>
        
        <%@ include file="./inc/sidebar.jsp" %>

        <div class="content-wrapper">
            <section class="content">
                <div class="container-fluid">

                    <div class="dashboard-header">
                        <h1>Dashboard</h1>
                        <p id="dashboard-date-text"></p>
                    </div>

                    <div class="row">
                        <div class="col-xl col-lg-4 col-md-6 col-12">
                            <div class="stat-card-new">
                                <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); color: #6366f1;">
                                    <i class="fas fa-won-sign"></i>
                                </div>
                                <p class="stat-label">누적 매출</p>
                                <h3 class="stat-value">₩<%= nf.format(totalRevenue) %></h3>
                            </div>
                        </div>
                        <div class="col-xl col-lg-4 col-md-6 col-12">
                            <div class="stat-card-new">
                                <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
                                    <i class="fas fa-users"></i>
                                </div>
                                <p class="stat-label">총 회원수</p>
                                <h3 class="stat-value"><%= nf.format(totalMembers) %> 명</h3>
                            </div>
                        </div>
                        <div class="col-xl col-lg-4 col-md-6 col-12">
                            <div class="stat-card-new">
                                <div class="stat-icon" style="background: rgba(59, 130, 246, 0.1); color: #3b82f6;">
                                    <i class="fas fa-ticket-alt"></i>
                                </div>
                                <p class="stat-label">예매 티켓수</p>
                                <h3 class="stat-value"><%= nf.format(totalTickets) %> 매</h3>
                            </div>
                        </div>
                        <div class="col-xl col-lg-6 col-md-6 col-12">
                            <div class="stat-card-new">
                                <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: #f59e0b;">
                                    <i class="fas fa-theater-masks"></i>
                                </div>
                                <p class="stat-label">진행 중 공연</p>
                                <h3 class="stat-value"><%= activeWorks %> 건</h3>
                            </div>
                        </div>
                        <div class="col-xl col-lg-6 col-md-6 col-12">
                            <div class="stat-card-new">
                                <div class="stat-icon" style="background: rgba(239, 68, 68, 0.1); color: #ef4444;">
                                    <i class="fas fa-exclamation-triangle"></i>
                                </div>
                                <p class="stat-label">신고 대기</p>
                                <h3 class="stat-value"><%= pendingReports %> 건</h3>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-6">
                            <div class="card dashboard-card">
                                <div class="card-header">
                                    <h3 class="card-title"><i class="fas fa-chart-pie mr-2"></i>장르별 공연 분포</h3>
                                </div>
                                <div class="card-body chart-body">
                                    <div class="chart-container">
                                        <div class="chart-center-text">
                                            <span class="chart-total-label">Total</span>
                                            <span class="chart-total-sub">장르 비율</span>
                                        </div>
                                        <canvas id="genreChart"></canvas>
                                    </div>
                                    <div id="customLegend" class="chart-legend"></div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-6">
                            <div class="card dashboard-card">
                                <div class="card-header">
                                    <h3 class="card-title"><i class="fas fa-calendar-alt mr-2"></i>최신 공연 일정</h3>
                                </div>
                                <div class="card-body" style="max-height: 340px; overflow-y: auto;">
                                    <% 
                                    if (upcomingRounds != null && !upcomingRounds.isEmpty()) { 
                                        for (Round round : upcomingRounds) { 
                                            if (round.getWork() != null) { 
                                    %>
                                    <div class="schedule-item">
                                        <span class="schedule-date"><%= round.getRound_date() %></span>
                                        <span class="schedule-genre">
                                            <%= round.getWork().getGenre() != null ? round.getWork().getGenre().getGenre_name() : "기타" %>
                                        </span>
                                        <span style="flex: 1;"><%= round.getWork().getWork_title() %></span>
                                        <span style="color: #666; font-size: 13px; font-weight: 500;">
                                            <%= round.getRound_start_time() %>
                                        </span>
                                    </div>
                                    <% 
                                            } 
                                        } 
                                    } else { 
                                    %>
                                    <p style="text-align: center; color: #aaa; padding: 60px 0; font-size: 14px;">예정된 공연이 없습니다.</p>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-12">
                            <div class="card dashboard-card">
                                <div class="card-header">
                                    <h3 class="card-title">
                                        <i class="fas fa-flag mr-2" style="color: #dc3545;"></i>신고된 리뷰 (처리 대기)
                                    </h3>
                                </div>
                                <div class="card-body">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>신고일</th>
                                                <th>작성자</th>
                                                <th>신고 사유</th>
                                                <th>상태</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% 
                                            if (reportList != null && !reportList.isEmpty()) { 
                                                for (Report report : reportList) { 
                                            %>
                                            <tr>
                                                <td><%= report.getReport_date() %></td>
                                                <td>
                                                    <%= report.getReview() != null && report.getReview().getMember() != null ? report.getReview().getMember().getLoginId() : "-" %>
                                                </td>
                                                <td>
                                                    <%= report.getReportCategory() != null ? report.getReportCategory().getReport_reason() : "-" %>
                                                </td>
                                                <td><span class="badge badge-warning">대기</span></td>
                                            </tr>
                                            <% 
                                                } 
                                            } else { 
                                            %>
                                            <tr>
                                                <td colspan="4" style="text-align: center; color: #aaa; padding: 40px 0; font-size: 14px;">처리 대기 중인 신고가 없습니다.</td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </section>
        </div>

        <%@ include file="./inc/footer.jsp" %>
        <%@ include file="./inc/control_sidebar.jsp" %>

    </div>
    <%@ include file="./inc/footer_link.jsp" %>

    <script>
        $(function () {
            <%
                java.util.List<com.ch.tickethub.dto.Genre> filteredList = new java.util.ArrayList<>();
                if (genreList != null) {
                    for (com.ch.tickethub.dto.Genre g : genreList) {
                        if (!"전시/행사".equals(g.getGenre_name())) {
                            filteredList.add(g);
                        }
                    }
                }
            %>

            var genreLabels = [
                <% 
                for (int i = 0; i < filteredList.size(); i++) {
                    out.print("'" + filteredList.get(i).getGenre_name() + "'");
                    if (i < filteredList.size() - 1) out.print(",");
                }
                %>
            ];

            var genreData = [
                <% 
                for (int i = 0; i < filteredList.size(); i++) {
                    int count = filteredList.get(i).getWorkList() != null ? filteredList.get(i).getWorkList().size() : 0;
                    out.print(count);
                    if (i < filteredList.size() - 1) out.print(",");
                }
                %>
            ];

            var chartColors = ['#8b5cf6', '#3b82f6', '#10b981', '#f59e0b', '#ec4899', '#06b6d4'];
            var ctx = document.getElementById('genreChart').getContext('2d');

            var myChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: genreLabels,
                    datasets: [{
                        data: genreData,
                        backgroundColor: chartColors,
                        borderWidth: 2,
                        borderColor: '#ffffff',
                        hoverOffset: 6,
                        hoverBorderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '60%',
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            enabled: true,
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            padding: 12,
                            cornerRadius: 8,
                            displayColors: true
                        }
                    },
                    layout: { padding: 0 }
                }
            });

            function generateCustomLegend(chart) {
                var legendHtml = [];
                var data = chart.data;
                legendHtml.push('<ul class="legend-list">');
                for (var i = 0; i < data.labels.length; i++) {
                    legendHtml.push('<li>');
                    legendHtml.push('<span class="legend-dot" style="background-color:' + data.datasets[0].backgroundColor[i] + '"></span>');
                    legendHtml.push('<span class="legend-text">' + data.labels[i] + '</span>');
                    legendHtml.push('</li>');
                }
                legendHtml.push('</ul>');
                document.getElementById('customLegend').innerHTML = legendHtml.join("");
            }

            generateCustomLegend(myChart);
        });
    </script>

    <script>
        $(() => {   // ====== 비동기 클릭 이벤트 함수 =======
            
            // 전역 AJAX 401 처리: content-wrapper에 로그인 박히는 문제 방지
            $(document).ajaxError(function (event, jqxhr) {
                if (jqxhr.status === 401) {
                    // 서버가 Location 헤더 줬으면 그쪽으로, 아니면 기본 로그인으로
                    const loc = jqxhr.getResponseHeader("Location") || "/auth/login";
                    window.location.href = loc;
                }
            });

            // 메인배너 관리 클릭 이벤트
            $("#menu-main-banner").click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/mainpage/mainbanner/banner",
                    method: "GET",
                    success: function (result) {
                        console.log("메인배너관리 클릭됨!!");
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 인기작 관리 클릭 이벤트
            $("#menu-hot-work").click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/mainpage/hotwork/hotwork",
                    method: "GET",
                    success: function (result) {
                        console.log("인기작관리 클릭됨!!");
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 오픈예정 관리 클릭 이벤트
            $("#menu-opening-work").click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/mainpage/openingwork/openingwork",
                    method: "GET",
                    success: function (result) {
                        console.log("오픈예정관리 클릭됨!!");
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 장르별 화제작 관리 클릭 이벤트
            $("#menu-genre-ranking").click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/mainpage/genreranking/genreranking",
                    method: "GET",
                    success: function (result) {
                        console.log("장르별 화제작관리 클릭됨!!");
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 베스트 리뷰 관리 클릭 이벤트
            $("#menu-bestreview-work").click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/mainpage/bestreview/bestreview",
                    method: "GET",
                    success: function (result) {
                        console.log("베스트 리뷰관리 클릭됨!!");
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 인물 관리 클릭 이벤트
            $($(".performance .nav-item")[0]).click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/performance/person",
                    method: "GET",
                    success: function (result) {
                        console.log("인물관리 클릭됨!!");
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 장소 관리 클릭 이벤트
            $($(".performance .nav-item")[1]).click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/performance/place",
                    method: "GET",
                    success: function (result) {
                        console.log("장소관리 클릭됨!!");
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 주최/기획 관리 클릭 이벤트
            $($(".performance .nav-item")[2]).click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/performance/publisher",
                    method: "GET",
                    success: function (result) {
                        console.log("주최/기획 관리 클릭됨!!");
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 작품 관리 클릭 이벤트
            $($(".performance .nav-item")[3]).click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/performance/work",
                    method: "GET",
                    success: function (result) {
                        console.log("작품 관리 클릭됨!!");
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 회차 관리 클릭 이벤트
            $($(".performance .nav-item")[4]).click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/performance/round",
                    method: "GET",
                    success: function (result) {
                        console.log("회차 관리 클릭됨!!");
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 신고 관리 클릭 이벤트
            $($(".performance .nav-item")[5]).click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/performance/report",
                    method: "GET",
                    success: function (result) {
                        console.log("신고 관리 클릭됨!!");
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 좌석 상태 관리 클릭 (첫 번째 메뉴)
            $($(".seat .nav-item")[0]).click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/seatmanager/seat/state/main", // 수정됨
                    method: "GET",
                    success: function (result) {
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 좌석 등급 관리 클릭 (두 번째 메뉴)
            $($(".seat .nav-item")[1]).click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/seatmanager/seat/grade/main", // 수정됨
                    method: "GET",
                    success: function (result) {
                        $(".content-wrapper").html(result);
                    }
                });
            });

            // 회원 목록 클릭 이벤트
            $("#menu-members").click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/members",    // 컨트롤러를 /admin/members로 맞추기..
                    method: "GET",
                    success: function (result) {
                        console.log("회원 목록 클릭됨!!");
                        $(".content-wrapper").html(result);
                    }
                });
            });
            
            // 주문정보 클릭 이벤트 (비동기 로딩)
            $("#menu-order-info").click(function (e) {
                e.preventDefault();
                $.ajax({
                    url: "/admin/order/list",
                    method: "GET",
                    success: function (result) {
                        console.log("주문정보 메뉴 클릭됨");
                        $(".content-wrapper").html(result);
                        
                        // (선택사항) 브라우저 뒤로가기 대응을 위한 state 저장
                        if (history.pushState) {
                            history.pushState({ url: "/admin/order/list" }, null, "#order-list");
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("주문 정보를 불러오는데 실패했습니다.", error);
                        alert("데이터를 불러오는 중 오류가 발생했습니다.");
                    }
                });
            });

            $("#btn-admin-home").click(function (e) {
                e.preventDefault();
                window.location.href = "/admin/main";
            });
        });

        (function () {
            const ctx = "${pageContext.request.contextPath}";

            window.addEventListener("popstate", function (e) {
                const st = e.state;

                // state 없으면: (pushState가 없어서) 아무 것도 못함
                // -> 여기서 return 하는 건 정상. "안되는" 주 원인도 여기.
                if (!st) return;

                // url 기반 복원
                if (st.url) {
                    $.ajax({
                        url: st.url.startsWith("http") ? st.url : (st.url.startsWith(ctx) ? st.url : ctx + st.url),
                        method: "GET",
                        success: function (result) {
                            $(".content-wrapper").html(result);
                        }
                    });
                    return;
                }

                // detail 기반 복원 (view/memberId 저장해둔 경우)
                if (st.view === "detail" && st.memberId) {
                    $.ajax({
                        url: ctx + "/admin/members/detail",
                        data: { memberId: st.memberId },
                        success: function (result) {
                            $(".content-wrapper").html(result);
                        }
                    });
                }
            });
        })();

        // Dashboard 날짜 동적 표시
        (function () {
            var today = new Date();
            var year = today.getFullYear();
            var month = today.getMonth() + 1;
            var day = today.getDate();
            var weekdays = ['일', '월', '화', '수', '목', '금', '토'];
            var weekday = weekdays[today.getDay()];

            var dateStr = year + '년 ' + month + '월 ' + day + '일 ' + weekday + '요일 기준 현황입니다.';
            var el = document.getElementById('dashboard-date-text');
            if (el) el.textContent = dateStr;
        })();
    </script>
</body>

</html>