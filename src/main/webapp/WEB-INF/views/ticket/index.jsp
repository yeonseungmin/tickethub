<%@page import="com.ch.tickethub.dto.MainBanner" %>
  <%@page import="com.ch.tickethub.dto.HotWork" %>
    <%@page import="com.ch.tickethub.dto.OpeningWork" %>
      <%@page import="com.ch.tickethub.dto.GenreRanking" %>
        <%@page import="java.util.List" %>
          <%@ page contentType="text/html; charset=UTF-8" %>
            <% List<MainBanner> bannerList = (List<MainBanner>) request.getAttribute("bannerList");
                List<HotWork> hotWorkList = (List<HotWork>) request.getAttribute("hotWorkList");
                    List<OpeningWork> openingWorkList = (List<OpeningWork>) request.getAttribute("openingWorkList");
                        List<GenreRanking> genreRankingList = (List<GenreRanking>)
                            request.getAttribute("genreRankingList");
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

                                  <!-- HERO / 메인 배너 -->
                                  <section class="hero" data-hero>
                                    <div class="hero__viewport">
                                      <div class="hero__track" data-hero-track>
                                        <% if(bannerList !=null && !bannerList.isEmpty()) { %>
                                          <% for(MainBanner banner : bannerList) { %>
                                            <article class="hero__slide" data-hero-slide
                                              onclick="location.href='/performance/detail?id=<%=banner.getWork_id()%>'"
                                              style="background-image:url('/banner/<%=banner.getMain_image_url()%>'); cursor:pointer;">
                                              <div class="hero__content"></div>
                                            </article>
                                            <% } %>
                                              <% } else { %>
                                                <article class="hero__slide" data-hero-slide
                                                  style="background-color: #333;">
                                                  <div class="hero__content">
                                                    <h2 style="color:white; text-align:center; padding-top:200px;">등록된
                                                      배너가 없습니다.</h2>
                                                  </div>
                                                </article>
                                                <% } %>
                                      </div>

                                      <button class="hero__nav hero__nav--prev" type="button" data-hero-prev
                                        aria-label="이전 배너">
                                        <span aria-hidden="true">‹</span>
                                      </button>
                                      <button class="hero__nav hero__nav--next" type="button" data-hero-next
                                        aria-label="다음 배너">
                                        <span aria-hidden="true">›</span>
                                      </button>

                                      <div class="hero__dots" role="tablist" aria-label="배너 인디케이터">
                                        <% if (bannerList !=null && !bannerList.isEmpty()) { for (int i=0; i <
                                          bannerList.size(); i++) { String activeClass=(i==0) ? "is-active" : "" ; int
                                          displayCount=i + 1; %>
                                          <button class="hero__dot <%= activeClass %>" type="button" data-hero-dot
                                            aria-label="배너 <%= displayCount %>"></button>
                                          <% } } %>
                                      </div>
                                    </div>
                                  </section>

                                  <!-- 현재 인기작 -->
                                  <section class="hot" aria-labelledby="hotTitle">
                                    <div class="container">
                                      <h2 id="hotTitle" class="section-title section-title--center">현재 인기작</h2>

                                      <div class="hot-grid">
                                        <!-- 왼쪽 큰 포스터 (첫 번째 인기작) -->
                                        <% if(hotWorkList !=null && !hotWorkList.isEmpty()) { %>
                                          <% HotWork firstHotWork=hotWorkList.get(0); %>
                                            <article class="hot-featured">
                                              <a class="poster poster--featured"
                                                href="/performance/detail?id=<%=firstHotWork.getWork_id()%>">
                                                <img class="poster__img"
                                                  src="/photo/work/p<%=firstHotWork.getWork_id()%>/<%=firstHotWork.getWork().getWork_poster_url()%>"
                                                  alt="대표 인기작 포스터" />
                                              </a>
                                              <div class="hot-featured__info">
                                                <h3 class="hot-featured__name">
                                                  <%=firstHotWork.getWork().getWork_title()%>
                                                </h3>
                                                <p class="hot-featured__meta">
                                                  <%=firstHotWork.getWork().getWork_start_date()%> -
                                                    <%=firstHotWork.getWork().getWork_end_date()%>
                                                </p>
                                              </div>
                                            </article>
                                            <% } else { %>
                                              <article class="hot-featured">
                                                <a class="poster poster--featured" href="#">
                                                  <img class="poster__img"
                                                    src="static/assets/img/poster-placeholder.svg" alt="대표 인기작 포스터" />
                                                </a>
                                                <div class="hot-featured__info">
                                                  <h3 class="hot-featured__name">등록된 인기작이 없습니다</h3>
                                                  <p class="hot-featured__meta">관리자 페이지에서 인기작을 등록해주세요</p>
                                                </div>
                                              </article>
                                              <% } %>

                                                <!-- 오른쪽 6개 (두 번째부터) -->
                                                <div class="hot-cards">
                                                  <% if(hotWorkList !=null && hotWorkList.size()> 1) {
                                                    int count = 0;
                                                    for(int i = 1; i < hotWorkList.size() && count < 6; i++) { HotWork
                                                      hotWork=hotWorkList.get(i); count++; %>
                                                      <article class="hot-card">
                                                        <a class="poster"
                                                          href="/performance/detail?id=<%=hotWork.getWork_id()%>">
                                                          <img class="poster__img"
                                                            src="/photo/work/p<%=hotWork.getWork_id()%>/<%=hotWork.getWork().getWork_poster_url()%>"
                                                            alt="인기작 포스터" />
                                                          <span class="poster__overlay">
                                                            <span class="poster__name">
                                                              <%=hotWork.getWork().getWork_title()%>
                                                            </span>
                                                            <span class="poster__meta">
                                                              <%=hotWork.getWork().getWork_start_date()%> -
                                                                <%=hotWork.getWork().getWork_end_date()%>
                                                            </span>
                                                          </span>
                                                        </a>
                                                      </article>
                                                      <% } } %>
                                                </div>
                                      </div>
                                    </div>
                                  </section>

                                  <!-- 오픈 예정 -->
                                  <section class="opening" aria-labelledby="openingTitle">
                                    <div class="container">
                                      <h2 id="openingTitle" class="section-title section-title--center">오픈 예정</h2>

                                      <div class="opening-grid">
                                        <% if(openingWorkList !=null && !openingWorkList.isEmpty()) { for(OpeningWork
                                          openingWork : openingWorkList) { %>
                                          <article class="opening-card">
                                            <a class="opening-card__thumb"
                                              href="/performance/detail?id=<%=openingWork.getWork_id()%>">
                                              <img
                                                src="/photo/work/p<%=openingWork.getWork_id()%>/<%=openingWork.getWork().getWork_poster_url()%>"
                                                alt="포스터" />
                                            </a>
                                            <div class="opening-card__body">
                                              <div class="opening-card__date">
                                                <%=openingWork.getWork().getTicket_start_date()%>
                                              </div>
                                              <div class="opening-card__title">
                                                <%=openingWork.getWork().getWork_title()%>
                                              </div>
                                              <div class="opening-card__meta">
                                                <%=openingWork.getWork().getWork_start_date()%> -
                                                  <%=openingWork.getWork().getWork_end_date()%>
                                              </div>
                                            </div>
                                          </article>
                                          <% } } else { %>
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
                                        <% if(genreRankingList !=null && !genreRankingList.isEmpty()) { int rank=1;
                                          for(GenreRanking genreRanking : genreRankingList) { %>
                                          <article class="rank-card">
                                            <a class="rank-card__poster"
                                              href="/performance/detail?id=<%=genreRanking.getWork_id()%>">
                                              <img
                                                src="/photo/work/p<%=genreRanking.getWork_id()%>/<%=genreRanking.getWork().getWork_poster_url()%>"
                                                alt="포스터" />
                                              <span class="rank-badge">
                                                <%=rank%>위
                                              </span>
                                            </a>
                                            <div class="rank-card__body">
                                              <div class="rank-card__title">
                                                <%=genreRanking.getWork().getWork_title()%>
                                              </div>
                                              <div class="rank-card__meta">
                                                <%=genreRanking.getWork().getWork_start_date()%> -
                                                  <%=genreRanking.getWork().getWork_end_date()%>
                                              </div>
                                            </div>
                                          </article>
                                          <% rank++; } } else { %>
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

                                  <!-- 베스트 관람후기 (팀원 영역 - 하드코딩 유지) -->
                                  <section class="reviews" aria-labelledby="reviewsTitle">
                                    <div class="container">
                                      <h2 id="reviewsTitle" class="section-title section-title--center">베스트 관람후기</h2>

                                      <div class="reviews-grid">
                                        <article class="review-item">
                                          <div class="review-item__left">
                                            <div class="review-item__category">뮤지컬 &lt;2026 KIM SEJEONG FAN CONCERT 〈열
                                              번째 편지〉 TO SEOUL&gt;</div>
                                            <a class="review-item__title" href="#">2026 KIM SEJEONG FAN CONCERT 〈열 번째
                                              편지〉 TO SEOUL</a>
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
                                            <div class="review-item__category">뮤지컬 &lt;〈앤ANNE〉 10th Anniversary&gt;
                                            </div>
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