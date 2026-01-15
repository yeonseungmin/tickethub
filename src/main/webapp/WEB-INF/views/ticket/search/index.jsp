<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ch.tickethub.dto.SearchResult" %>
<%
    request.setAttribute("activeNav", "");
    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) keyword = "";
    
    List<SearchResult> searchResultList = (List<SearchResult>) request.getAttribute("searchResultList");
    int resultCount = (searchResultList != null) ? searchResultList.size() : 0;
%>
<!doctype html>
<html lang="ko">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>검색 - TicketHUB</title>
    <%@ include file="../inc/head_link.jsp" %>
    <link rel="stylesheet" href="/static/assets/css/home.css" />
    <link rel="stylesheet" href="/static/assets/css/search.css" />
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
                            <span class="search-count">티켓 (<%=resultCount%>)</span>
                            <% if (!keyword.isEmpty()) { %>
                                · "<%=keyword%>" 검색
                            <% } %>
                        </p>
                    </div>
                </div>

                <div class="search-tabs" role="tablist" aria-label="검색 타입">
                    <button class="search-tab is-active" type="button" role="tab" aria-selected="true">티켓</button>
                    <button class="search-tab" type="button" role="tab" aria-selected="false" disabled>출연진(준비중)</button>
                </div>

                <section class="search-grid" aria-label="티켓 검색 결과 목록">
                    <% 
                    if (searchResultList != null && !searchResultList.isEmpty()) { 
                        for (SearchResult result : searchResultList) { 
                            if (result.getWork() != null) { 
                    %>
                                <article class="search-card">
                                    <a class="poster search-card__poster" 
                                       href="/detail?work_id=<%=result.getWork_id()%>" 
                                       aria-label="작품 상세">
                                        <img class="poster__img" 
                                             src="/photo/work/p<%=result.getWork_id()%>/<%=result.getWork().getWork_poster_url()%>" 
                                             alt="포스터" />
                                    </a>
                                    <div class="search-card__body">
                                        <div class="search-card__title">
                                            <%=result.getWork().getWork_title()%>
                                        </div>
                                        <div class="search-card__line">
                                            <% if (result.getWork().getPublisher() != null) { %>
                                                <%=result.getWork().getPublisher().getPublisher_name()%>
                                            <% } %>
                                        </div>
                                        <div class="search-card__sub">
                                            <%=result.getWork().getWork_start_date()%> ~ <%=result.getWork().getWork_end_date()%>
                                        </div>
                                        <div class="work-card__badges">
                                            <% if (result.getWork().getGenre() != null) { %>
                                                <span class="pill">
                                                    <%=result.getWork().getGenre().getGenre_name()%>
                                                </span>
                                            <% } %>
                                        </div>
                                    </div>
                                </article>
                    <% 
                            } 
                        } 
                    } else { 
                    %>
                        <div class="no-results" style="grid-column: 1 / -1; text-align: center; padding: 60px 20px; color: #666;">
                            <p style="font-size: 18px; margin-bottom: 10px;">검색 결과가 없습니다.</p>
                            <p style="font-size: 14px;">다른 검색어로 다시 시도해보세요.</p>
                        </div>
                    <% } %>
                </section>
            </div>
        </main>

        <%@ include file="../inc/footer.jsp" %>
    </div>
    <%@ include file="../inc/footer_link.jsp" %>
</body>

</html>