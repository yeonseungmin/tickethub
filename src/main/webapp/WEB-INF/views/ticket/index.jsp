<%@ page contentType="text/html; charset=UTF-8" %>
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
        <!-- 수정사항 -->
        <!-- HERO / 메인 배너 -->
        <section class="hero" data-hero>
          <div class="hero__viewport">
            <div class="hero__track" data-hero-track>

              <!-- 슬라이드 1 -->
              <article class="hero__slide hero__slide--" data-hero-slide
                onclick="location.href='/performance/detail?id=1'"
                style="background-image:url('static/assets/img/musical_rent.jpg'); cursor:pointer;">
                <div class="hero__content">
                </div>
              </article>

              <!-- 슬라이드 2 -->
              <article class="hero__slide hero__slide--" data-hero-slide
                onclick="location.href='/performance/detail?id=2'"
                style="background-image:url('static/assets/img/concert_OneRepublic.jpg'); cursor:pointer;">
                <div class="hero__content">
                </div>
              </article>

              <!-- 슬라이드 3 -->
              <article class="hero__slide hero__slide--" data-hero-slide
                onclick="location.href='/performance/detail?id=3'"
                style="background-image:url('static/assets/img/Spirited_Away.png'); cursor:pointer;">
                <div class="hero__content">
                </div>
              </article>

              <!-- 슬라이드 4 -->
              <article class="hero__slide hero__slide--" data-hero-slide
                onclick="location.href='/performance/detail?id=4'"
                style="background-image:url('static/assets/img/concert_AshIsland.jpg'); cursor:pointer;">
                <div class="hero__content">
                </div>
              </article>

              <!-- 슬라이드 5 -->
              <article class="hero__slide hero__slide--" data-hero-slide
                onclick="location.href='/performance/detail?id=5'"
                style="background-image:url('static/assets/img/Voyage.png'); cursor:pointer;">
                <div class="hero__content">
                </div>
              </article>

            </div>

            <button class="hero__nav hero__nav--prev" type="button" data-hero-prev aria-label="이전 배너">
              <span aria-hidden="true">‹</span>
            </button>
            <button class="hero__nav hero__nav--next" type="button" data-hero-next aria-label="다음 배너">
              <span aria-hidden="true">›</span>
            </button>

            <div class="hero__dots" role="tablist" aria-label="배너 인디케이터">
              <button class="hero__dot is-active" type="button" data-hero-dot aria-label="배너 1"></button>
              <button class="hero__dot" type="button" data-hero-dot aria-label="배너 2"></button>
              <button class="hero__dot" type="button" data-hero-dot aria-label="배너 3"></button>
              <button class="hero__dot" type="button" data-hero-dot aria-label="배너 4"></button>
              <button class="hero__dot" type="button" data-hero-dot aria-label="배너 5"></button>
            </div>
          </div>
        </section>

        <!-- 현재 인기작 -->
        <section class="hot" aria-labelledby="hotTitle">
          <div class="container">
            <h2 id="hotTitle" class="section-title section-title--center">현재 인기작</h2>

            <div class="hot-grid">
              <!-- 왼쪽 큰 포스터 -->
              <article class="hot-featured">
                <a class="poster poster--featured" href="#">
                  <img class="poster__img" src="static/assets/img/KimSeJeong_FanConcert.png" alt="대표 인기작 포스터" />
                </a>
                <div class="hot-featured__info">
                  <h3 class="hot-featured__name">작품 제목</h3>
                  <p class="hot-featured__meta">2026.02.15 - 2026.02.16 · 올림픽공원 체조경기장</p>
                </div>
              </article>

              <!-- 오른쪽 6개 -->
              <div class="hot-cards">
                <article class="hot-card">
                  <a class="poster" href="#">
                    <img class="poster__img" src="static/assets/img/poster-placeholder.svg" alt="인기작 포스터" />
                    <span class="tag tag--orange">단독</span>
                    <span class="poster__overlay">
                      <span class="poster__name">THE NERD CONNECTION 2025</span>
                      <span class="poster__meta">2025.12.28 - 2025.12.29 · KSPO DOME</span>
                    </span>
                  </a>
                </article>

                <article class="hot-card">
                  <a class="poster" href="#">
                    <img class="poster__img" src="static/assets/img/poster-placeholder.svg" alt="인기작 포스터" />
                    <span class="tag tag--red">전국</span>
                    <span class="poster__overlay">
                      <span class="poster__name">뮤지컬 맘마미아</span>
                      <span class="poster__meta">2025.11.05 - 2026.04.13 · 샤롯데씨어터</span>
                    </span>
                  </a>
                </article>

                <article class="hot-card">
                  <a class="poster" href="#">
                    <img class="poster__img" src="static/assets/img/poster-placeholder.svg" alt="인기작 포스터" />
                    <span class="poster__overlay">
                      <span class="poster__name">파리나: 섬파리 소멸의장</span>
                      <span class="poster__meta">2026.01.05 - 2026.01.13 · 예술의전당</span>
                    </span>
                  </a>
                </article>

                <article class="hot-card">
                  <a class="poster" href="#">
                    <img class="poster__img" src="static/assets/img/poster-placeholder.svg" alt="인기작 포스터" />
                    <span class="poster__overlay">
                      <span class="poster__name">연극 타지마할의 궁위병</span>
                      <span class="poster__meta">2025.11.12 - 2026.01.04 · LG아트센터</span>
                    </span>
                  </a>
                </article>

                <article class="hot-card">
                  <a class="poster" href="#">
                    <img class="poster__img" src="static/assets/img/poster-placeholder.svg" alt="인기작 포스터" />
                    <span class="poster__overlay">
                      <span class="poster__name">히곡쓰 오래보자</span>
                      <span class="poster__meta">2025.10.18 - 2026.01.05 · 대학로</span>
                    </span>
                  </a>
                </article>

                <article class="hot-card">
                  <a class="poster" href="#">
                    <img class="poster__img" src="static/assets/img/poster-placeholder.svg" alt="인기작 포스터" />
                    <span class="tag tag--orange">단독</span>
                    <span class="poster__overlay">
                      <span class="poster__name">라도이 단독 콘서트</span>
                      <span class="poster__meta">2025.12.02 - 2025.12.28 · YES24 LIVE HALL</span>
                    </span>
                  </a>
                </article>
              </div>
            </div>
          </div>
        </section>

        <!-- 오픈 예정 -->
        <section class="opening" aria-labelledby="openingTitle">
          <div class="container">
            <h2 id="openingTitle" class="section-title section-title--center">오픈 예정</h2>

            <div class="opening-grid">
              <article class="opening-card">
                <a class="opening-card__thumb" href="#">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                  <span class="tag tag--red tag--sm">HOT</span>
                </a>
                <div class="opening-card__body">
                  <div class="opening-card__date">12.17(수) 14:00</div>
                  <div class="opening-card__title">뮤지컬 &lt;위키드&gt;</div>
                  <div class="opening-card__meta">샤롯데씨어터</div>
                  <span class="pill">단독판매</span>
                </div>
              </article>

              <article class="opening-card">
                <a class="opening-card__thumb" href="#">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                  <span class="tag tag--blue tag--sm">단독판매</span>
                </a>
                <div class="opening-card__body">
                  <div class="opening-card__date">12.19(금) 14:00</div>
                  <div class="opening-card__title">뮤지컬 &lt;레미제라블&gt;</div>
                  <div class="opening-card__meta">블루스퀘어</div>
                </div>
              </article>

              <article class="opening-card">
                <a class="opening-card__thumb" href="#">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                  <span class="tag tag--red tag--sm">HOT</span>
                </a>
                <div class="opening-card__body">
                  <div class="opening-card__date">12.16(화) 14:00</div>
                  <div class="opening-card__title">콘서트 &lt;아이유&gt;</div>
                  <div class="opening-card__meta">잠실종합운동장</div>
                  <span class="pill">단독판매</span>
                </div>
              </article>

              <article class="opening-card">
                <a class="opening-card__thumb" href="#">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                  <span class="tag tag--red tag--sm">HOT</span>
                </a>
                <div class="opening-card__body">
                  <div class="opening-card__date">내일 20:00</div>
                  <div class="opening-card__title">연극 &lt;햄릿&gt;</div>
                  <div class="opening-card__meta">대학로 예술극장</div>
                  <span class="pill">단독판매</span>
                </div>
              </article>

              <article class="opening-card">
                <a class="opening-card__thumb" href="#">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                  <span class="tag tag--red tag--sm">HOT</span>
                </a>
                <div class="opening-card__body">
                  <div class="opening-card__date">12.16(화) 14:00</div>
                  <div class="opening-card__title">전시 &lt;모네전&gt;</div>
                  <div class="opening-card__meta">서울시립미술관</div>
                </div>
              </article>

              <article class="opening-card">
                <a class="opening-card__thumb" href="#">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                </a>
                <div class="opening-card__body">
                  <div class="opening-card__date">12.19(금) 14:00</div>
                  <div class="opening-card__title">뮤지컬 &lt;시카고&gt;</div>
                  <div class="opening-card__meta">LG아트센터</div>
                  <span class="pill">페스티벌</span>
                </div>
              </article>
            </div>

            <div class="section-more section-more--center">
              <a class="text-link" href="#">오픈 예정 전체보기 &gt;</a>
            </div>
          </div>
        </section>

        <!-- 장르별 랭킹 -->
        <main class="container page-main">
          <section class="ranking" aria-labelledby="rankingTitle">
            <h2 id="rankingTitle" class="section-title section-title--center">장르별 화제작</h2>

            <div class="genre-tabs" data-genre-tabs>
              <button class="genre-tabs__btn is-active" type="button">#뮤지컬</button>
              <button class="genre-tabs__btn" type="button">#콘서트</button>
              <button class="genre-tabs__btn" type="button">#연극</button>
              <button class="genre-tabs__btn" type="button">#클래식</button>
              <button class="genre-tabs__btn" type="button">#전시</button>
            </div>

            <div class="ranking-grid">
              <article class="rank-card">
                <a class="rank-card__poster" href="#">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                  <span class="rank-badge">1위</span>
                </a>
                <div class="rank-card__body">
                  <div class="rank-card__title">2026 KIM SEJEONG FAN CONCERT 〈열 번째 편지〉 TO SEOUL</div>
                  <div class="rank-card__meta">2025.11.29 - 2026.03.02 · LG아트센터</div>
                </div>
              </article>

              <article class="rank-card">
                <a class="rank-card__poster" href="#">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                  <span class="rank-badge">2위</span>
                </a>
                <div class="rank-card__body">
                  <div class="rank-card__title">뮤지컬 [위키드] 내한공연 - 부산 (WICKED)</div>
                  <div class="rank-card__meta">2025.11.15 - 2026.01.18 · 부산 드림씨어터</div>
                </div>
              </article>

              <article class="rank-card">
                <a class="rank-card__poster" href="#">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                  <span class="rank-badge">3위</span>
                </a>
                <div class="rank-card__body">
                  <div class="rank-card__title">뮤지컬 [나르치스와 골드문트]</div>
                  <div class="rank-card__meta">2025.12.23 - 2026.03.22 · 예스24스테이지 2관</div>
                </div>
              </article>
            </div>

            <div class="section-more section-more--center">
              <a class="btn btn--outline" href="#">랭킹 더보기 +</a>
            </div>
          </section>
        </main>

        <!-- 베스트 관람후기 -->
        <section class="reviews" aria-labelledby="reviewsTitle">
          <div class="container">
            <h2 id="reviewsTitle" class="section-title section-title--center">베스트 관람후기</h2>

            <div class="reviews-grid">
              <article class="review-item">
                <div class="review-item__left">
                  <div class="review-item__category">뮤지컬 &lt;2026 KIM SEJEONG FAN CONCERT 〈열 번째 편지〉 TO SEOUL&gt;</div>
                  <a class="review-item__title" href="#">2026 KIM SEJEONG FAN CONCERT 〈열 번째 편지〉 TO SEOUL</a>
                  <p class="review-item__content">
                    세트리스트가 너무 치밀하게 짜여져서 2시간 30분이 순식간에 지나가고, 밴드 라이브랑 목소리가 미쳤어요. 또 가고 싶어요!
                  </p>
                  <div class="review-item__meta">
                    <span class="review-item__author">👤 f@i*******</span>
                    <span class="review-item__sep"></span>
                    <span class="review-item__rating">
                      <span class="stars" aria-hidden="true">★★★★★</span>
                      <span class="review-item__score">9.9</span>
                    </span>
                  </div>
                </div>
                <a class="review-item__poster" href="#" aria-label="후기 포스터">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                </a>
              </article>

              <article class="review-item">
                <div class="review-item__left">
                  <div class="review-item__category">뮤지컬 &lt;로빈&gt;</div>
                  <a class="review-item__title" href="#">로빈</a>
                  <p class="review-item__content">
                    원래 눈물이 잘 없는 편인데 이 작품 자첫하면서 펑펑 울었습니다. 이번 겨울 회전 돌 작품입니다. 강추합니다.
                  </p>
                  <div class="review-item__meta">
                    <span class="review-item__author">👤 ku***</span>
                    <span class="review-item__sep"></span>
                    <span class="review-item__rating">
                      <span class="stars" aria-hidden="true">★★★★★</span>
                      <span class="review-item__score">9.4</span>
                    </span>
                  </div>
                </div>
                <a class="review-item__poster" href="#" aria-label="후기 포스터">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                </a>
              </article>

              <article class="review-item">
                <div class="review-item__left">
                  <div class="review-item__category">연극 &lt;내가 하면 로맨스&gt;</div>
                  <a class="review-item__title" href="#">내가 하면 로맨스</a>
                  <p class="review-item__content">
                    생각보다 수위가 높아서 놀랬는데 배우분들이 재밌게 연기로 풀어가 주셔서 계속 웃으면서 봤어요. 다음에 또 보고 싶어요!
                  </p>
                  <div class="review-item__meta">
                    <span class="review-item__author">👤 8w*******</span>
                    <span class="review-item__sep"></span>
                    <span class="review-item__rating">
                      <span class="stars" aria-hidden="true">★★★★★</span>
                      <span class="review-item__score">9.4</span>
                    </span>
                  </div>
                </div>
                <a class="review-item__poster" href="#" aria-label="후기 포스터">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                </a>
              </article>

              <article class="review-item">
                <div class="review-item__left">
                  <div class="review-item__category">뮤지컬 &lt;〈앤ANNE〉 10th Anniversary&gt;</div>
                  <a class="review-item__title" href="#">〈앤ANNE〉 10th Anniversary</a>
                  <p class="review-item__content">
                    원작을 읽고 캐나다도 다녀올 정도로 팬입니다. 1열에서 봤어요. 배우님들의 귀한 연기를 가까이에서 볼 수 있어 영광이었습니다.
                  </p>
                  <div class="review-item__meta">
                    <span class="review-item__author">👤 pmj***</span>
                    <span class="review-item__sep"></span>
                    <span class="review-item__rating">
                      <span class="stars" aria-hidden="true">★★★★★</span>
                      <span class="review-item__score">9.9</span>
                    </span>
                  </div>
                </div>
                <a class="review-item__poster" href="#" aria-label="후기 포스터">
                  <img src="static/assets/img/poster-placeholder.svg" alt="포스터" />
                </a>
              </article>
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
  </body>

  </html>