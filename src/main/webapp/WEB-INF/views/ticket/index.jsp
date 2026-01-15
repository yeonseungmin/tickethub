<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ch.tickethub.dto.BestReview" %>
<%@ page import="com.ch.tickethub.dto.MainBanner" %>
<%@ page import="com.ch.tickethub.dto.HotWork" %>
<%@ page import="com.ch.tickethub.dto.OpeningWork" %>
<%@ page import="com.ch.tickethub.dto.GenreRanking" %>
<%
    // Controller에서 넘겨준 데이터 받기
    List<MainBanner> bannerList = (List<MainBanner>) request.getAttribute("bannerList");
    List<HotWork> hotWorkList = (List<HotWork>) request.getAttribute("hotWorkList");
    List<OpeningWork> openingWorkList = (List<OpeningWork>) request.getAttribute("openingWorkList");
    List<GenreRanking> genreRankingList = (List<GenreRanking>) request.getAttribute("genreRankingList");
    List<BestReview> bestReviewList = (List<BestReview>) request.getAttribute("bestReviewList");
%>
<!doctype html>
<html lang="ko">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Ticket Hub 메인</title>
    <%@ include file="inc/head_link.jsp" %>
    <link rel="stylesheet" href="/static/assets/css/home.css" />
</head>

<body>
    <div class="page">
        <%@ include file="inc/header.jsp" %>

        <section class="hero" data-hero>
            <div class="hero__viewport">
                <div class="hero__track" data-hero-track>
                    <% if (bannerList != null && !bannerList.isEmpty()) { %>
                        <% for (MainBanner banner : bannerList) { %>
                        <article class="hero__slide" data-hero-slide onclick="location.href='/detail?work_id=<%=banner.getWork_id()%>'" style="background-image:url('/banner/<%=banner.getMain_image_url()%>'); cursor:pointer;">
                            <div class="hero__content">
                            </div>
                        </article>
                        <% } %>
                    <% } else { %>
                        <article class="hero__slide" data-hero-slide style="background-color: #333;">
                            <div class="hero__content">
                                <h2 style="color: white; text-align: center; padding-top: 200px;">등록된 배너가 없습니다.</h2>
                            </div>
                        </article>
                    <% } %>
                </div>

                <button class="hero__nav hero__nav--prev" type="button" data-hero-prev aria-label="이전 배너">
                    <span aria-hidden="true">‹</span>
                </button>
                <button class="hero__nav hero__nav--next" type="button" data-hero-next aria-label="다음 배너">
                    <span aria-hidden="true">›</span>
                </button>

                <div class="hero__dots" role="tablist" aria-label="배너 인디케이터">
                    <% if (bannerList != null && !bannerList.isEmpty()) {
                        for (int i = 0; i < bannerList.size(); i++) {
                            String activeClass = (i == 0) ? "is-active" : "";
                            int displayCount = i + 1;
                    %>
                    <button class="hero__dot <%= activeClass %>" type="button" data-hero-dot aria-label="배너 <%= displayCount %>"></button>
                    <%  } } %>
                </div>
            </div>
        </section>

        <section class="hot" aria-labelledby="hotTitle">
            <div class="container">
                <h2 id="hotTitle" class="section-title section-title--center">현재 인기작</h2>

                <div class="hot-grid">
                    <% if (hotWorkList != null && !hotWorkList.isEmpty()) {
                        HotWork firstHotWork = hotWorkList.get(0);
                    %>
                    <article class="hot-featured">
                        <a class="poster poster--featured" href="/detail?work_id=<%=firstHotWork.getWork_id()%>">
                            <img class="poster__img" src="/photo/work/p<%=firstHotWork.getWork_id()%>/<%=firstHotWork.getWork().getWork_poster_url()%>" alt="대표 인기작 포스터" />
                        </a>
                        <div class="hot-featured__info">
                            <h3 class="hot-featured__name"><%=firstHotWork.getWork().getWork_title()%></h3>
                            <p class="hot-featured__meta"><%=firstHotWork.getWork().getWork_start_date()%> - <%=firstHotWork.getWork().getWork_end_date()%></p>
                        </div>
                    </article>
                    <% } else { %>
                    <article class="hot-featured">
                        <a class="poster poster--featured" href="#">
                            <img class="poster__img" src="static/assets/img/poster-placeholder.svg" alt="대표 인기작 포스터" />
                        </a>
                        <div class="hot-featured__info">
                            <h3 class="hot-featured__name">등록된 인기작이 없습니다</h3>
                            <p class="hot-featured__meta">관리자 페이지에서 인기작을 등록해주세요</p>
                        </div>
                    </article>
                    <% } %>

                    <div class="hot-cards">
                        <% if (hotWorkList != null && hotWorkList.size() > 1) {
                            int count = 0;
                            for (int i = 1; i < hotWorkList.size() && count < 6; i++) {
                                HotWork hotWork = hotWorkList.get(i);
                                count++;
                        %>
                        <article class="hot-card">
                            <a class="poster" href="/detail?work_id=<%=hotWork.getWork_id()%>">
                                <img class="poster__img" src="/photo/work/p<%=hotWork.getWork_id()%>/<%=hotWork.getWork().getWork_poster_url()%>" alt="인기작 포스터" />
                                <span class="poster__overlay">
                                    <span class="poster__name"><%=hotWork.getWork().getWork_title()%></span>
                                    <span class="poster__meta"><%=hotWork.getWork().getWork_start_date()%> - <%=hotWork.getWork().getWork_end_date()%></span>
                                </span>
                            </a>
                        </article>
                        <%  } } %>
                    </div>
                </div>
            </div>
        </section>

        <section class="opening" aria-labelledby="openingTitle">
            <div class="container">
                <h2 id="openingTitle" class="section-title section-title--center">오픈 예정</h2>

                <div class="opening-grid">
                    <% if (openingWorkList != null && !openingWorkList.isEmpty()) {
                        int openingCount = 0;
                        for (OpeningWork openingWork : openingWorkList) {
                            if (openingCount >= 6) break;
                            openingCount++;
                    %>
                    <article class="opening-card">
                        <a class="opening-card__thumb" href="/detail?work_id=<%=openingWork.getWork_id()%>">
                            <img src="/photo/work/p<%=openingWork.getWork_id()%>/<%=openingWork.getWork().getWork_poster_url()%>" alt="포스터" />
                        </a>
                        <div class="opening-card__body">
                            <div class="opening-card__date"><%=openingWork.getWork().getTicket_start_date()%></div>
                            <div class="opening-card__title"><%=openingWork.getWork().getWork_title()%></div>
                            <div class="opening-card__meta"><%=openingWork.getWork().getWork_start_date()%> - <%=openingWork.getWork().getWork_end_date()%></div>
                        </div>
                    </article>
                    <%  } } else { %>
                    <article class="opening-card">
                        <a class="opening-card__thumb" href="#">
                            <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                        </a>
                        <div class="opening-card__body">
                            <div class="opening-card__title">등록된 오픈예정이 없습니다</div>
                            <div class="opening-card__meta">관리자 페이지에서 등록해주세요</div>
                        </div>
                    </article>
                    <% } %>
                </div>

                <div class="section-more section-more--center">
                    <a class="text-link" href="#">오픈 예정 전체보기 &gt;</a>
                </div>
            </div>
        </section>

        <main class="container page-main">
            <section class="ranking" aria-labelledby="rankingTitle">
                <h2 id="rankingTitle" class="section-title section-title--center">장르별 화제작</h2>

                <div class="genre-tabs" data-genre-tabs>
                    <a href="#" class="genre-tabs__btn is-active" data-genre="콘서트">#콘서트</a>
                    <a href="#" class="genre-tabs__btn" data-genre="뮤지컬">#뮤지컬</a>
                    <a href="#" class="genre-tabs__btn" data-genre="연극">#연극</a>
                    <a href="#" class="genre-tabs__btn" data-genre="클래식/무용">#클래식/무용</a>
                    <a href="#" class="genre-tabs__btn" data-genre="어린이/가족">#어린이/가족</a>
                </div>

                <div class="ranking-grid" id="genreRankingGrid">
                    <% 
                    // 초기 로딩: 스크립틀릿으로 '콘서트' 장르 3개만 우선 출력
                    if (genreRankingList != null && !genreRankingList.isEmpty()) {
                        int displayCount = 0;
                        for (GenreRanking genreRanking : genreRankingList) {
                            if (displayCount >= 3) break;
                            
                            String workGenre = "";
                            if (genreRanking.getWork() != null && genreRanking.getWork().getGenre() != null) {
                                workGenre = genreRanking.getWork().getGenre().getGenre_name();
                            }
                            
                            if ("콘서트".equals(workGenre)) {
                                displayCount++;
                    %>
                    <article class="rank-card">
                        <a class="rank-card__poster" href="/detail?work_id=<%=genreRanking.getWork_id()%>">
                            <img src="/photo/work/p<%=genreRanking.getWork_id()%>/<%=genreRanking.getWork().getWork_poster_url()%>" alt="포스터" />
                            <span class="rank-badge"><%=displayCount%>위</span>
                        </a>
                        <div class="rank-card__body">
                            <div class="rank-card__title"><%=genreRanking.getWork().getWork_title()%></div>
                            <div class="rank-card__meta">
                                <%=genreRanking.getWork().getWork_start_date()%> - <%=genreRanking.getWork().getWork_end_date()%>
                            </div>
                        </div>
                    </article>
                    <%      
                            } 
                        }
                        
                        if (displayCount == 0) {
                    %>
                        <div class="no-data-msg" style="grid-column: 1 / -1; text-align: center; padding: 40px 0; color: #666;">
                            해당 장르의 화제작이 없습니다.
                        </div>
                    <%
                        }
                    } else { 
                    %>
                    <article class="rank-card">
                        <a class="rank-card__poster" href="#">
                            <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                            <span class="rank-badge">1위</span>
                        </a>
                        <div class="rank-card__body">
                            <div class="rank-card__title">등록된 장르별 화제작이 없습니다</div>
                            <div class="rank-card__meta">관리자 페이지에서 등록해주세요</div>
                        </div>
                    </article>
                    <% } %>
                </div>

                <div class="section-more section-more--center">
                    <a class="btn btn--outline" href="#">랭킹 더보기 +</a>
                </div>
            </section>
        </main>

        <section class="reviews" aria-labelledby="reviewsTitle">
            <div class="container">
                <h2 id="reviewsTitle" class="section-title section-title--center">베스트 관람후기</h2>
                <div class="reviews-grid">
                    <% if (bestReviewList != null && !bestReviewList.isEmpty()) {
                        int reviewCount = 0;
                        for (BestReview bestReview : bestReviewList) {
                            if (reviewCount >= 4) break;
                            if (bestReview.getReview() != null && bestReview.getReview().getWork() != null) {
                                reviewCount++;
                    %>
                    <article class="review-item">
                        <div class="review-item__left">
                            <div class="review-item__category"><%=bestReview.getReview().getWork().getWork_title()%></div>
                            <a href="/detail?work_id=<%=bestReview.getReview().getWork().getWork_id()%>" class="review-item__title"><%=bestReview.getReview().getReview_title()%></a>
                            <p class="review-item__content"><%=bestReview.getReview().getReview_content()%></p>
                            <div class="review-item__meta">
                                <span class="review-item__author">👤 
                                    <% if (bestReview.getReview().getMember() != null && bestReview.getReview().getMember().getEmail() != null) { %>
                                        <%=bestReview.getReview().getMember().getEmail().substring(0, Math.min(3, bestReview.getReview().getMember().getEmail().length()))%>***
                                    <% } else { %>
                                        익명
                                    <% } %>
                                </span>
                                <span class="review-item__sep"></span>
                                <span class="review-item__rating">
                                    <span class="stars" aria-hidden="true">
                                        <% for(int i=0; i < bestReview.getReview().getRating(); i++) { %>★<% } %>
                                    </span>
                                    <span class="review-item__score"><%=bestReview.getReview().getRating()%></span>
                                </span>
                            </div>
                        </div>
                        <a href="/detail?work_id=<%=bestReview.getReview().getWork().getWork_id()%>" class="review-item__poster" aria-label="후기 포스터">
                            <img src="/photo/work/p<%=bestReview.getReview().getWork().getWork_id()%>/<%=bestReview.getReview().getWork().getWork_poster_url()%>" alt="포스터" />
                        </a>
                    </article>
                    <%      }
                        }
                       } else { %>
                    <article class="review-item">
                        <div class="review-item__left">
                            <div class="review-item__category">등록된 베스트 리뷰가 없습니다</div>
                            <a class="review-item__title" href="#">관리자 페이지에서 등록해주세요</a>
                            <p class="review-item__content">베스트 리뷰를 등록하면 여기에 표시됩니다.</p>
                            <div class="review-item__meta">
                                <span class="review-item__author">👤 관리자</span>
                                <span class="review-item__sep"></span>
                                <span class="review-item__rating">
                                    <span class="stars" aria-hidden="true">★★★★★</span>
                                    <span class="review-item__score">5</span>
                                </span>
                            </div>
                        </div>
                        <a class="review-item__poster" href="#" aria-label="후기 포스터">
                            <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                        </a>
                    </article>
                    <% } %>
                </div>
                <div class="section-more section-more--center">
                    <button class="btn btn--outline" type="button">관람후기 새로 보기 ↻</button>
                </div>
            </div>
        </section>

        <%@ include file="inc/footer.jsp" %>
    </div>

    <%@ include file="inc/footer_link.jsp" %>
    <script defer src="/static/assets/js/home.js"></script>
    <script>
    $(function() {
        // 장르 탭 클릭 이벤트
        $('.genre-tabs__btn').on('click', function(e) {
            e.preventDefault();
            
            // 탭 활성화 UI 처리
            $('.genre-tabs__btn').removeClass('is-active');
            $(this).addClass('is-active');
            
            const selectedGenre = $(this).data('genre');
            loadGenreRankings(selectedGenre);
        });

        function loadGenreRankings(genreName) {
            const $grid = $('#genreRankingGrid');
            
            $.ajax({
                url: '/genreranking/list',
                method: 'GET',
                dataType: 'json',
                success: function(data) {
                    $grid.empty();
                    
                    // 1. 데이터 필터링 & 2. 최대 3개 제한
                    const filteredData = data
                        .filter(item => item.work?.genre?.genre_name === genreName)
                        .slice(0, 3);
                    
                    // 데이터 없음 처리
                    if (filteredData.length === 0) {
                        $grid.html(`
                            <div class="no-data-msg" style="grid-column: 1 / -1; text-align: center; padding: 40px 0; color: #666;">
                                해당 장르의 화제작이 없습니다.
                            </div>
                        `);
                        return;
                    }
                    
                    // 3. HTML 생성 (템플릿 리터럴 사용)
                    const html = filteredData.map((item, index) => `
                        <article class="rank-card">
                            <a class="rank-card__poster" href="/detail?work_id=\${item.work_id}">
                                <img src="/photo/work/p\${item.work_id}/\${item.work.work_poster_url}" alt="포스터" />
                                <span class="rank-badge">\${index + 1}위</span>
                            </a>
                            <div class="rank-card__body">
                                <div class="rank-card__title">\${item.work.work_title}</div>
                                <div class="rank-card__meta">
                                    \${item.work.work_start_date} - \${item.work.work_end_date}
                                </div>
                            </div>
                        </article>
                    `).join('');

                    $grid.append(html);
                },
                error: function(xhr, status, err) {
                    console.error('장르별 랭킹 로드 실패:', err);
                }
            });
        }
    });
    </script>
</body>

</html>