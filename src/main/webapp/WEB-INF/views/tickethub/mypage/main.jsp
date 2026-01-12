<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ch.tickethub.dto.Member"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
  Member member = (Member) request.getAttribute("member");

  SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
  SimpleDateFormat sdfDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<%@ include file="../../ticket/inc/head_link.jsp"%>
<%@ include file="../../ticket/inc/header.jsp"%>

<style>
.mypage-wrap {
	max-width: 1100px;
	margin: 0 auto;
	padding: 48px 16px 80px;
}

.mypage-title {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 18px;
}

.mypage-title h2 {
	font-size: 28px;
	font-weight: 800;
	margin: 0;
}

.mypage-sub {
	color: #6b7280;
	margin-top: 6px;
	font-size: 14px;
}

.mypage-grid {
	display: grid;
	grid-template-columns: 1fr 360px;
	gap: 18px;
}

.card {
	background: #fff;
	border: 1px solid #eef0f3;
	border-radius: 18px;
}

.card-hd {
	padding: 18px 18px 0;
}

.card-hd h3 {
	margin: 0;
	font-size: 18px;
	font-weight: 800;
}

.card-bd {
	padding: 18px;
}

.row {
	display: flex;
	justify-content: space-between;
	padding: 12px 0;
	border-bottom: 1px solid #f3f4f6;
}

.row:last-child {
	border-bottom: none;
}

.label {
	color: #6b7280;
	font-size: 13px;
}

.value {
	font-weight: 700;
	color: #111827;
}

.pill {
	padding: 8px 12px;
	border-radius: 999px;
	font-size: 12px;
	font-weight: 800;
}

.pill-normal {
	background: rgba(124, 58, 237, 0.1);
	color: #7c3aed;
}

.pill-blocked {
	background: rgba(239, 68, 68, 0.1);
	color: #ef4444;
}

.btn {
	display: inline-flex;
	align-items: center;
	height: 44px;
	padding: 0 16px;
	border-radius: 999px;
	font-weight: 800;
	text-decoration: none;
}

.btn-primary {
	background: #7c3aed;
	color: #fff;
}

.btn-ghost {
	border: 1px solid #e5e7eb;
	color: #111827;
}

@media ( max-width : 980px) {
	.mypage-grid {
		grid-template-columns: 1fr;
	}
}
</style>

<div class="mypage-wrap">

<% if (member == null) { %>

  <div class="card">
    <div class="card-bd">회원 정보를 불러올 수 없습니다. 다시 로그인해주세요.</div>
  </div>

<% } else { %>

  <div class="mypage-title">
    <div>
      <h2>마이페이지</h2>
      <div class="mypage-sub">내 계정 정보를 확인할 수 있어요.</div>
    </div>
    <div>
      <% if ("BLOCKED".equals(member.getStatus())) { %>
        <span class="pill pill-blocked">차단됨</span>
      <% } else { %>
        <span class="pill pill-normal"><%= member.getStatus() %></span>
      <% } %>
    </div>
  </div>

  <div class="mypage-grid">

    <div class="card">
      <div class="card-hd"><h3>내 정보</h3></div>
      <div class="card-bd">

        <div class="row">
          <div class="label">아이디</div>
          <div class="value"><%= member.getLoginId() %></div>
        </div>

        <div class="row">
          <div class="label">이름</div>
          <div class="value"><%= member.getName() %></div>
        </div>

        <div class="row">
          <div class="label">이메일</div>
          <div class="value"><%= member.getEmail() %></div>
        </div>

        <div class="row">
          <div class="label">전화번호</div>
          <div class="value"><%= member.getPhone() == null ? "-" : member.getPhone() %></div>
        </div>

        <div class="row">
          <div class="label">가입일</div>
          <div class="value">
            <%= member.getCreatedAt() == null ? "-" : sdfDate.format(member.getCreatedAt()) %>
          </div>
        </div>

        <div class="row">
          <div class="label">최근 로그인</div>
          <div class="value">
            <%= member.getLastLoginAt() == null ? "-" : sdfDateTime.format(member.getLastLoginAt()) %>
          </div>
        </div>

      </div>
    </div>

    <div class="card">
      <div class="card-hd"><h3>계정</h3></div>
      <div class="card-bd">

        <div class="row">
          <div class="label">권한</div>
          <div class="value"><%= member.getRole() %></div>
        </div>

        <div class="row">
          <div class="label">가입 유형</div>
          <div class="value">
            <%= member.getOauthProvider() == null ? "일반 회원" : "SNS (" + member.getOauthProvider() + ")" %>
          </div>
        </div>


      </div>
    </div>

  </div>

<% } %>

</div>

<%@ include file="../../ticket/inc/footer.jsp"%>
<%@ include file="../../ticket/inc/footer_link.jsp"%>