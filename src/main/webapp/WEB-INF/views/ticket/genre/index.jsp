<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% 
    // URL 파라미터에서 type 읽기
    String genreType = request.getParameter("type");
    if (genreType == null || genreType.isEmpty()) {
        genreType = "concert";
    }

    // 장르별 genre_id 매핑
    int genreId = 1;
    String genreNameKorean = "콘서트";

    if ("concert".equals(genreType)) {
        genreId = 1;
        genreNameKorean = "콘서트";
    } else if ("musical".equals(genreType)) {
        genreId = 2;
        genreNameKorean = "뮤지컬";
    } else if ("play".equals(genreType)) {
        genreId = 3;
        genreNameKorean = "연극";
    } else if ("classic".equals(genreType)) {
        genreId = 4;
        genreNameKorean = "클래식/무용";
    } else if ("kids".equals(genreType)) {
        genreId = 5;
        genreNameKorean = "어린이/가족";
    }

    // 현재 메뉴 하이라이트 처리용
    request.setAttribute("activeNav", genreType);
%>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><%=genreNameKorean%> - TicketHUB</title>
    <%@ include file="../inc/head_link.jsp" %>
    <link rel="stylesheet" href="/static/assets/css/home.css" />
    <link rel="stylesheet" href="/static/assets/css/genre.css" />
</head>
<body>
    <div class="page">
        <%@ include file="../inc/header.jsp" %>

        <main class="genre-page" aria-label="장르 목록">
            <!-- 배너 섹션: container 안에 넣어서 너비 제한 -->
            <div class="container">
                <section class="genre-banner" id="genreBanner" aria-label="추천 작품">
                    <div class="carousel" data-carousel>
                        <div class="carousel__viewport" data-carousel-viewport>
                            <div class="carousel__track" id="bannerTrack" data-carousel-track>
                                <div class="loading-text" style="text-align: center; padding: 100px; color: #888; width: 100%;">
                                    작품을 불러오는 중...
                                </div>
                            </div>
                        </div>
                        <button class="carousel__nav carousel__nav--prev" type="button" data-carousel-prev aria-label="이전">
                            <span aria-hidden="true">‹</span>
                        </button>
                        <button class="carousel__nav carousel__nav--next" type="button" data-carousel-next aria-label="다음">
                            <span aria-hidden="true">›</span>
                        </button>
                    </div>
                </section>
            </div>

            <!-- 장르별 둘러보기 섹션 -->
            <div class="container">
                <!-- 제목: "{장르명} 둘러보기" -->
                <h2 class="genre-browse-title" id="genreBrowseTitle"><%=genreNameKorean%> 둘러보기</h2>

                <section class="work-grid" id="workGrid" aria-label="작품 목록">
                </section>

                <div class="section-more section-more--center" style="margin-top: 34px; display: none;" id="loadMoreSection">
                    <button class="btn btn--outline" type="button" id="btnLoadMore">더보기 +</button>
                </div>
            </div>
        </main>

        <%@ include file="../inc/footer.jsp" %>
    </div>

    <%@ include file="../inc/footer_link.jsp" %>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // 현재 선택된 장르 정보
        let currentGenreId = <%=genreId%>;
        let currentGenreType = '<%=genreType%>';

        // 장르 타입 → ID 매핑
        const genreMap = {
            'concert': { id: 1, name: '콘서트' },
            'musical': { id: 2, name: '뮤지컬' },
            'play': { id: 3, name: '연극' },
            'classic': { id: 4, name: '클래식/무용' },
            'kids': { id: 5, name: '어린이/가족' }
        };

        // 페이지 로드 시 작품 목록 불러오기
        $(function () {
            loadWorks(currentGenreId);

            // 네비게이션 탭 클릭 이벤트 (AJAX로 전환)
            $('[data-nav-tab]').on('click', function (e) {
                e.preventDefault();

                // href에서 type 파라미터 추출
                let href = $(this).attr('href');
                let type = 'concert';

                if (href.includes('type=')) {
                    type = href.split('type=')[1];
                }

                if (genreMap[type]) {
                    // 탭 활성화 상태 변경
                    $('.nav__item').removeClass('is-active');
                    $(this).closest('.nav__item').addClass('is-active');

                    // 장르 정보 업데이트
                    currentGenreType = type;
                    currentGenreId = genreMap[type].id;
                    document.title = genreMap[type].name + ' - TicketHUB';

           	        // "{장르명} 둘러보기" 제목도 업데이트
                    $('#genreBrowseTitle').text(genreMap[type].name + ' 둘러보기');
                    
                    // URL 변경 (새로고침 없이)
                    history.pushState({ type: type }, '', '/genre?type=' + type);

                    // 작품 목록 다시 불러오기
                    loadWorks(currentGenreId);
                }
            });
        });

        // 작품 목록 불러오기 (AJAX)
        function loadWorks(genreId) {
            let $bannerTrack = $('#bannerTrack');
            let $grid = $('#workGrid');

            // 로딩 표시
            $bannerTrack.html('<div class="loading-text" style="text-align: center; padding: 100px; color: #888; width: 100%;">작품을 불러오는 중...</div>');
            $grid.empty();

            $.ajax({
                url: '/api/genre/works',
                method: 'GET',
                data: { genre_id: genreId },
                success: function (workList) {
                    displayWorks(workList);
                },
                error: function (xhr, status, err) {
                    $bannerTrack.html('<div style="text-align: center; padding: 100px; color: #e74c3c; width: 100%;">작품 목록을 불러오는 데 실패했습니다.</div>');
                    console.error('Error loading works:', err);
                }
            });
        }

        // 작품 목록 화면에 표시
        function displayWorks(workList) {
            let $bannerTrack = $('#bannerTrack');
            let $grid = $('#workGrid');
            let $loadMore = $('#loadMoreSection');

            $bannerTrack.empty();
            $grid.empty();

            if (!workList || workList.length === 0) {
                $bannerTrack.html('<div style="text-align: center; padding: 100px; color: #888; width: 100%;">등록된 작품이 없습니다.</div>');
                $loadMore.hide();
                return;
            }

            // 상위 8개는 배너로
            let bannerWorks = workList.slice(0, 8);
            // 나머지는 그리드로
            let gridWorks = workList.slice(8);

            // 배너 카드 생성
            for (let work of bannerWorks) {
                let bannerHtml = `
                    <article class="carousel__item banner-card">
                        <a class="poster" href="/detail?work_id=` + work.work_id + `" aria-label="작품 상세">
                            <img class="poster__img" src="/photo/work/p` + work.work_id + `/` + work.work_poster_url + `" alt="포스터" 
                                onerror="this.src='/static/assets/img/poster-placeholder.svg'" />
                            <span class="poster__overlay">
                                <span class="poster__name">` + work.work_title + `</span>
                                <span class="poster__meta">` + work.work_start_date + ` - ` + work.work_end_date + `</span>
                            </span>
                        </a>
                    </article>`;
                $bannerTrack.append(bannerHtml);
            }

            // 그리드 카드 생성 (9번째부터)
            if (gridWorks.length > 0) {
                for (let work of gridWorks) {
                    let cardHtml = `
                        <article class="work-card">
                            <a class="poster work-card__poster" href="/detail?work_id=` + work.work_id + `" aria-label="작품 상세">
                                <img class="poster__img" src="/photo/work/p` + work.work_id + `/` + work.work_poster_url + `" alt="포스터" 
                                    onerror="this.src='/static/assets/img/poster-placeholder.svg'" />
                            </a>
                            <div class="work-card__badges">
                                <span class="pill">예매중</span>
                            </div>
                            <div class="work-card__title">` + work.work_title + `</div>
                            <div class="work-card__meta">
                                <strong>` + work.work_start_date + ` - ` + work.work_end_date + `</strong>
                            </div>
                        </article>`;
                    $grid.append(cardHtml);
                }
                $loadMore.show();
            } else {
                $loadMore.hide();
            }
        }

        // 브라우저 뒤로가기/앞으로가기 처리
        window.onpopstate = function (event) {
            if (event.state && event.state.type) {
                let type = event.state.type;
                if (genreMap[type]) {
                    currentGenreType = type;
                    currentGenreId = genreMap[type].id;

                    // UI 업데이트
                    $('.nav__item').removeClass('is-active');
                    $('[data-nav-tab][href*="' + type + '"]').closest('.nav__item').addClass('is-active');
                    document.title = genreMap[type].name + ' - TicketHUB';

                    loadWorks(currentGenreId);
                }
            }
        };
    </script>
    <script defer src="/static/assets/js/home.js"></script>
</body>
</html>