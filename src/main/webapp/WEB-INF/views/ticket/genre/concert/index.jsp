<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <% // header.jsp에서 현재 메뉴 하이라이트 처리용 request.setAttribute("activeNav", "concert" ); %>
    <!doctype html>
    <html lang="ko">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>콘서트 - TicketHUB</title>
      <%@ include file="../../inc/head_link.jsp" %>
        <link rel="stylesheet" href="/static/assets/css/home.css" />
        <link rel="stylesheet" href="/static/assets/css/genre.css" />
    </head>

    <body>
      <div class="page">
        <%@ include file="../../inc/header.jsp" %>

          <main class="genre-page" aria-label="장르 목록">
            <div class="container">

              <!-- 상단 배너(가로 슬라이더) - TODO(백엔드/관리자 연동): main_pick(HERO) 또는 장르별 배너 설정으로 대체 -->
              <section class="genre-page__section" aria-label="추천 배너">
                <div class="carousel" data-carousel>
                  <div class="carousel__viewport" data-carousel-viewport>
                    <div class="carousel__track" data-carousel-track>
                      <% for (int i=1; i <=6; i++) { %>
                        <article class="carousel__item banner-card">
                          <a class="poster" href="/performance/detail?id=<%=100+i%>" aria-label="배너 <%=i%>">
                            <img class="poster__img" src="/static/assets/img/poster-placeholder.svg" alt="배너 포스터" />
                            <span class="poster__overlay">
                              <span class="poster__name">콘서트 배너 작품명(예시) <%=i%></span>
                              <span class="poster__meta">2026.01.0<%= (i % 9) + 1 %> - 2026.02.0<%= (i % 9) + 1 %> ·
                                    공연장(예시)</span>
                            </span>
                          </a>
                        </article>
                        <% } %>
                    </div>
                  </div>
                  <button class="carousel__nav carousel__nav--prev" type="button" data-carousel-prev aria-label="이전 배너">
                    <span aria-hidden="true">‹</span>
                  </button>
                  <button class="carousel__nav carousel__nav--next" type="button" data-carousel-next aria-label="다음 배너">
                    <span aria-hidden="true">›</span>
                  </button>
                </div>
              </section>

              <!-- 오픈 예정(가로 슬라이더) - TODO(백엔드/관리자 연동): main_pick(OPENING) / work.tick_start_date 기반 노출 -->
              <section class="genre-page__section" aria-labelledby="openingTitle">
                <h2 id="openingTitle" class="section-title section-title--center section-title--sm">오픈 예정</h2>

                <div class="carousel" data-carousel>
                  <div class="carousel__viewport" data-carousel-viewport>
                    <div class="carousel__track" data-carousel-track>
                      <% for (int i=1; i <=10; i++) { %>
                        <article class="carousel__item opening-card-h">
                          <a class="poster" href="/performance/detail?id=<%=200+i%>" aria-label="오픈 예정 작품">
                            <img class="poster__img" src="/static/assets/img/poster-placeholder.svg" alt="포스터" />
                            <span class="tag tag--red tag--sm">HOT</span>
                            <span class="poster__overlay">
                              <span class="poster__name">오픈 예정 작품명(예시) <%=i%></span>
                              <span class="poster__meta">12.30(화) 15:00 · 티켓오픈</span>
                            </span>
                          </a>
                        </article>
                        <% } %>
                    </div>
                  </div>
                  <button class="carousel__nav carousel__nav--prev" type="button" data-carousel-prev aria-label="이전 목록">
                    <span aria-hidden="true">‹</span>
                  </button>
                  <button class="carousel__nav carousel__nav--next" type="button" data-carousel-next aria-label="다음 목록">
                    <span aria-hidden="true">›</span>
                  </button>
                </div>

                <div class="section-more section-more--center" style="margin-top: 22px;">
                  <a class="btn btn--outline" href="#" aria-label="오픈 예정 전체보기">오픈 예정 공연 전체보기 &gt;</a>
                </div>
              </section>

              <div class="genre-header">
                <div>
                  <h1 class="genre-header__title">콘서트</h1>
                  <p class="genre-header__meta">등록된 콘서트 작품을 한눈에 확인하세요.</p>
                </div>

                <!-- TODO(백엔드/관리자 연동): 필터/정렬 파라미터를 실제 검색 조건으로 연결 -->
                <div class="genre-tools" aria-label="필터/정렬">
                  <label class="chip">
                    지역
                    <select name="region" aria-label="지역 선택">
                      <option value="all" selected>전체</option>
                    </select>
                  </label>
                  <label class="chip">
                    정렬
                    <select name="sort" aria-label="정렬 선택">
                      <option value="popular" selected>인기순</option>
                      <option value="recent">최신순</option>
                    </select>
                  </label>
                </div>
              </div>

              <div class="divider" aria-hidden="true"></div>

              <!--
            TODO(백엔드/관리자 연동):
            - 관리자에서 work(작품) 등록 → 콘서트 장르(work_type/genre_id 등)로 조회된 목록을 내려받아 반복 렌더링
            - 각 카드 링크 규칙: /performance/detail?id={work_id}
            - 이미지 규칙: work_poster_url(또는 poster_url)
          -->
              <section class="work-grid" aria-label="콘서트 목록">
                <%-- 아래는 더미 카드. 백엔드 연동 시 반복 렌더링으로 교체 --%>

                  <article class="work-card">
                    <a class="poster work-card__poster" href="/performance/detail?id=1" aria-label="작품 상세">
                      <img class="poster__img" src="/static/assets/img/poster-placeholder.svg" alt="포스터" />
                      <span class="tag tag--orange">단독</span>
                    </a>
                    <div class="work-card__badges">
                      <span class="pill">예매중</span>
                    </div>
                    <div class="work-card__title">콘서트 작품명(예시)</div>
                    <div class="work-card__meta">
                      <strong>2026.01.01 - 2026.02.01</strong><br />
                      공연장 정보(예시)
                    </div>
                  </article>

                  <% for (int i=2; i <=15; i++) { %>
                    <article class="work-card">
                      <a class="poster work-card__poster" href="/performance/detail?id=<%=i%>" aria-label="작품 상세">
                        <img class="poster__img" src="/static/assets/img/poster-placeholder.svg" alt="포스터" />
                      </a>
                      <div class="work-card__badges">
                        <span class="pill">예매예정</span>
                      </div>
                      <div class="work-card__title">콘서트 작품명(예시) <%=i%>
                      </div>
                      <div class="work-card__meta">
                        <strong>2026.01.0<%= (i % 9) + 1 %> - 2026.02.0<%= (i % 9) + 1 %></strong><br />
                        공연장 정보(예시)
                      </div>
                    </article>
                    <% } %>
              </section>

              <div class="section-more section-more--center" style="margin-top: 34px;">
                <button class="btn btn--outline" type="button">더보기 +</button>
              </div>
            </div>
          </main>

          <%@ include file="../../inc/footer.jsp" %>
      </div>

      <%@ include file="../../inc/footer_link.jsp" %>
        <script defer src="/static/assets/js/home.js"></script>
    </body>

    </html>