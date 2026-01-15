<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.ch.tickethub.dto.Member" %>
<%
    // 1. 활성 네비게이션 처리
    String activeNav = (String) request.getAttribute("activeNav");
    if (activeNav == null) activeNav = "";

    // 2. 로그인 세션 가져오기
    Member loginMember = (Member) session.getAttribute("loginMember");

    // 3. Context Path 설정 (include 중복 방지: ctx를 pageContext에 1회 저장)
    if (pageContext.getAttribute("ctx") == null) {
        pageContext.setAttribute("ctx", request.getContextPath());
    }
%>

<header class="site-header" data-header>
    <div class="site-header__top">
        <div class="container site-header__top-inner">

            <a class="site-header__logo" href="${ctx}/" aria-label="홈으로">
                <span class="site-header__logo-gradient">TICKET HUB</span>
            </a>

            <form class="search" action="${ctx}/search" method="get" role="search" style="position: relative;">
                <label class="sr-only" for="q">검색</label>
                <input id="q" name="q" class="search__input" type="text" 
                       placeholder="공연, 전시를 검색해보세요" 
                       value="${param.q}" autocomplete="off" />
                
                <button class="search__btn" type="submit" aria-label="검색">
                    <svg width="20" height="20" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                        <path d="M10.5 3a7.5 7.5 0 1 0 4.67 13.37l4.23 4.23a1 1 0 0 0 1.42-1.42l-4.23-4.23A7.5 7.5 0 0 0 10.5 3Zm0 2a5.5 5.5 0 1 1 0 11 5.5 5.5 0 0 1 0-11Z" fill="currentColor" />
                    </svg>
                </button>
                
                <ul id="autocomplete-list" class="autocomplete-dropdown"></ul>
            </form>

            <div class="user-actions">
            <% if (loginMember == null) { %>
                <a class="user-actions__link" href="${ctx}/auth/login">로그인</a>
                <a class="btn btn--primary" href="${ctx}/auth/join">회원가입</a>
            <% } else if ("ADMIN".equals(loginMember.getRole())) { %>
                <a class="user-actions__link" href="${ctx}/auth/logout">로그아웃</a>
                <a class="btn btn--primary" href="${ctx}/admin/main">관리자페이지</a>
            <% } else { %>
                <a class="user-actions__link" href="${ctx}/auth/logout">로그아웃</a>
                <a class="btn btn--primary" href="${ctx}/tickethub/mypage">마이페이지</a>
            <% } %>
            </div>

        </div>
    </div>

    <nav class="nav__site" aria-label="카테고리">
        <div class="container">
            <ul class="nav__list" data-nav-tabs>
                <li class='nav__item <%= "concert".equals(activeNav) ? "is-active" : "" %>'>
                    <a class="nav__link" data-nav-tab href="${ctx}/genre?type=concert">콘서트</a>
                </li>
                <li class='nav__item <%= "musical".equals(activeNav) ? "is-active" : "" %>'>
                    <a class="nav__link" data-nav-tab href="${ctx}/genre?type=musical">뮤지컬</a>
                </li>
                <li class='nav__item <%= "play".equals(activeNav) ? "is-active" : "" %>'>
                    <a class="nav__link" data-nav-tab href="${ctx}/genre?type=play">연극</a>
                </li>
                <li class='nav__item <%= "classic".equals(activeNav) ? "is-active" : "" %>'>
                    <a class="nav__link" data-nav-tab href="${ctx}/genre?type=classic">클래식/무용</a>
                </li>
                <li class='nav__item <%= "kids".equals(activeNav) ? "is-active" : "" %>'>
                    <a class="nav__link" data-nav-tab href="${ctx}/genre?type=kids">어린이/가족</a>
                </li>
            </ul>
        </div>
    </nav>
</header>

<script>
$(function() {
    var debounceTimer;
    var $input = $('#q');
    var $list = $('#autocomplete-list');

    // 1. 입력 이벤트 핸들러
    $input.on('input', function() {
        var keyword = $(this).val().trim();

        clearTimeout(debounceTimer);

        if (keyword.length < 1) {
            $list.hide().empty();
            return;
        }

        // Debounce: 300ms 대기 후 API 호출
        debounceTimer = setTimeout(function() {
            $.ajax({
                url: '${ctx}/search/autocomplete',
                method: 'GET',
                data: { q: keyword },
                dataType: 'json',
                success: function(data) {
                    if (data.length === 0) {
                        $list.hide().empty();
                        return;
                    }

                    // 리스트 아이템 생성
                    var html = data.map(function(item) {
                        return '<li data-id="' + item.work_id + '">' +
                               '<img src="/photo/work/p' + item.work_id + '/' + item.work.work_poster_url + '" ' +
                               'alt="" onerror="this.src=\'/static/assets/img/poster-placeholder.svg\'" />' +
                               '<span class="ac-title">' + item.work.work_title + '</span>' +
                               '</li>';
                    }).join('');

                    $list.html(html).show();
                },
                error: function() {
                    $list.hide().empty();
                }
            });
        }, 300);
    });

    // 2. 자동완성 항목 클릭 시 이동
    $list.on('click', 'li', function() {
        var workId = $(this).data('id');
        window.location.href = '${ctx}/detail?work_id=' + workId;
    });

    // 3. 검색창 외부 클릭 시 닫기
    $(document).on('click', function(e) {
        if (!$(e.target).closest('.search').length) {
            $list.hide();
        }
    });

    // 4. 검색창 포커스 시 다시 표시
    $input.on('focus', function() {
        if ($list.children().length > 0) {
            $list.show();
        }
    });
});
</script>