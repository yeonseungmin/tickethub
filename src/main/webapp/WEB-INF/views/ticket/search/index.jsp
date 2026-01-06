<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  request.setAttribute("activeNav", ""); // 검색은 장르 탭 활성화 없음
  String q = request.getParameter("q");
  if (q == null) q = "";
%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>검색 - TicketHUB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/search.css?v=dev4" />
  </head>
  <body>
    <div class="page">
      <%@ include file="../inc/header.jsp" %>

      <main class="search-page" aria-label="검색 결과">
        <div class="container">
          <div class="search-title">
            <div>
              <h1 class="search-title__h1">검색 결과</h1>
              <p class="search-title__meta">
                <span class="search-count">티켓 (2)</span>
                <% if (!q.isEmpty()) { %>
                  · "<%= q %>" 검색
                <% } %>
              </p>
            </div>
          </div>

          <!-- (선택) 탭 UI: 추후 출연진/공연 분리할 때 그대로 확장 가능 -->
          <div class="search-tabs" role="tablist" aria-label="검색 타입">
            <button class="search-tab is-active" type="button" role="tab" aria-selected="true">티켓</button>
            <button class="search-tab" type="button" role="tab" aria-selected="false" disabled>출연진(준비중)</button>
          </div>

          <!--
            TODO(백엔드/검색 연동):
            - q 파라미터로 work_title / 출연진(별도 테이블) 기반 검색
            - 결과는 List<Work> 형태로 내려받아 아래 카드 반복 렌더링
            - 링크: /performance/detail?id={work_id}
            - 이미지: work_poster_url (없으면 placeholder)
          -->
          <section class="search-grid" aria-label="티켓 검색 결과 목록">
            <article class="search-card">
              <a class="poster search-card__poster" href="${pageContext.request.contextPath}/performance/detail?id=1" aria-label="작품 상세">
                <img class="poster__img" src="${pageContext.request.contextPath}/assets/img/poster-placeholder.svg" alt="포스터" />
              </a>
              <div class="search-card__body">
                <div class="search-card__title">대한민국상생 K-POP 콘서트 WITH 춘천 2024 세계태권...</div>
                <div class="search-card__line">춘천 송암스포츠타운 보조경기장...</div>
                <div class="search-card__sub">2024.10.03</div>
                <div class="search-card__rating">
                  <span class="stars" aria-hidden="true">★</span>
                  <span>(9.6) 리뷰 16</span>
                </div>
                <div class="work-card__badges">
                  <span class="pill">판매종료</span>
                </div>
              </div>
            </article>

            <article class="search-card">
              <a class="poster search-card__poster" href="${pageContext.request.contextPath}/performance/detail?id=2" aria-label="작품 상세">
                <img class="poster__img" src="${pageContext.request.contextPath}/assets/img/poster-placeholder.svg" alt="포스터" />
              </a>
              <div class="search-card__body">
                <div class="search-card__title">QWER DEBUT 쇼케이스</div>
                <div class="search-card__line">무신사 개러지</div>
                <div class="search-card__sub">2023.10.18</div>
                <div class="search-card__rating">
                  <span class="stars" aria-hidden="true">★</span>
                  <span>(10) 리뷰 6</span>
                </div>
                <div class="work-card__badges">
                  <span class="pill">판매종료</span>
                </div>
              </div>
            </article>
          </section>
        </div>
      </main>

      <%@ include file="../inc/footer.jsp" %>
    </div>
  </body>
</html>


