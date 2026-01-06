<%@page import="com.ch.tickethub.dto.Member"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<header class="header">
  <div class="container-fluid">
    <div class="row align-items-center">

      <!-- 로고 -->
      <div class="col-lg-3">
        <div class="header__logo">
          <a href="/"><img src="/static/template/img/logo.png" alt="Tickethub"></a>
        </div>
      </div>

      <!-- 중앙 메뉴 (지금은 비워둠) -->
      <div class="col-lg-6">
        <nav class="header__menu">
          <ul>
            <li><a href="/">HOME</a></li>
          </ul>
        </nav>
      </div>

      <!-- 우측 로그인 영역 -->
      <div class="col-lg-3">
        <div class="header__right">

          <div class="header__right__auth">
            <%
              Member member = (Member) session.getAttribute("loginMember");
              boolean isLogin = (member != null);
            %>

            <% if (!isLogin) { %>
              <a href="/auth/login">로그인</a>
              <a href="/auth/join">회원가입</a>
            <% } else { %>
              <span style="margin-right:10px;"><%=member.getName()%>님</span>
              <a href="/auth/logout">로그아웃</a>
            <% } %>
          </div>

          <!-- 아이콘 (검색만 유지) -->
          <ul class="header__right__widget">
            <li><span class="icon_search search-switch"></span></li>
          </ul>

        </div>
      </div>

    </div>

    <!-- 모바일 메뉴 버튼 -->
    <div class="canvas__open">
      <i class="fa fa-bars"></i>
    </div>
  </div>
</header>