<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  // 페이지별로 활성화할 네비 탭을 지정할 수 있음 (예: request.setAttribute("activeNav", "concert");)
  String activeNav = (String) request.getAttribute("activeNav");
  if (activeNav == null) activeNav = "";
%>
<header class="site-header" data-header>
  <div class="site-header__top">
    <div class="container site-header__top-inner">
      <a class="site-header__logo" href="../" aria-label="홈으로">
        <span class="site-header__logo-gradient">TICKET HUB</span>
      </a>

      <form class="search" action="${pageContext.request.contextPath}/search" method="get" role="search">
        <label class="sr-only" for="q">검색</label>
        <input id="q" name="q" class="search__input" type="text" placeholder="공연, 전시를 검색해보세요" value="${param.q}" />
        <button class="search__btn" type="submit" aria-label="검색">
          <svg width="20" height="20" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
            <path d="M10.5 3a7.5 7.5 0 1 0 4.67 13.37l4.23 4.23a1 1 0 0 0 1.42-1.42l-4.23-4.23A7.5 7.5 0 0 0 10.5 3Zm0 2a5.5 5.5 0 1 1 0 11 5.5 5.5 0 0 1 0-11Z" fill="currentColor"/>
          </svg>
        </button>
      </form>

      <div class="user-actions">
        <a class="user-actions__link" href="${pageContext.request.contextPath}/auth/login">
          <span class="user-actions__icon" aria-hidden="true">
            <svg width="20" height="20" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
              <path d="M12 12a4.5 4.5 0 1 0-4.5-4.5A4.5 4.5 0 0 0 12 12Zm0 2c-4.42 0-8 2.24-8 5v1h16v-1c0-2.76-3.58-5-8-5Z" fill="currentColor"/>
            </svg>
          </span>
          로그인
        </a>
        <a class="btn btn--primary" href="${pageContext.request.contextPath}/mypage/main">마이페이지</a>
      </div>
    </div>
  </div>

  <nav class="nav" aria-label="카테고리">
    <div class="container">
      <ul class="nav__list" data-nav-tabs>
        <li class="nav__item <%= "concert".equals(activeNav) ? "is-active" : "" %>">
          <a class="nav__link" data-nav-tab href="../genre/concert">콘서트</a>
        </li>
        <li class="nav__item <%= "musical".equals(activeNav) ? "is-active" : "" %>">
          <a class="nav__link" data-nav-tab href="../genre/musical">뮤지컬</a>
        </li>
        <li class="nav__item <%= "play".equals(activeNav) ? "is-active" : "" %>">
          <a class="nav__link" data-nav-tab href="../genre/play">연극</a>
        </li>
        <li class="nav__item <%= "classic".equals(activeNav) ? "is-active" : "" %>">
          <a class="nav__link" data-nav-tab href="../genre/classic">클래식/무용</a>
        </li>
        <li class="nav__item <%= "kids".equals(activeNav) ? "is-active" : "" %>">
          <a class="nav__link" data-nav-tab href="../genre/kids">어린이/가족</a>
        </li>
      </ul>
    </div>
  </nav>
</header>

