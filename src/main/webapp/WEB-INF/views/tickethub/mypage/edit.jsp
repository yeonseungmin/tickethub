<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.ch.tickethub.dto.Member"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
String ctx = request.getContextPath();

// 컨트롤러에서 내려준 회원정보
Member member = (Member) request.getAttribute("member");

// 세션 안전장치(직접 접근 방지)
if (member == null) {
    Member loginMember = (Member) session.getAttribute("loginMember");
    if (loginMember == null) {
        response.sendRedirect(ctx + "/auth/login");
        return;
    }
    member = loginMember;
}

boolean isSocial = (member.getOauthProvider() != null && !member.getOauthProvider().trim().isEmpty());

SimpleDateFormat sdfBirth = new SimpleDateFormat("yyyy-MM-dd");
String birthValue = "";
try {
    if (member.getBirthDate() != null)
        birthValue = sdfBirth.format(member.getBirthDate());
} catch (Exception e) {
    birthValue = "";
}

// 에러 메시지
String error = (String) request.getAttribute("error");
if (error == null) error = "";
%>
<form method="post" action="<%=ctx%>/tickethub/mypage/edit">

<%@ include file="../../ticket/inc/head_link.jsp"%>
<%@ include file="../../ticket/inc/header.jsp"%>

<style>
.mypage-wrap { max-width:1100px; margin:0 auto; padding:48px 16px 80px; }
.mypage-title { display:flex; justify-content:space-between; align-items:flex-end; gap:12px; margin-bottom:18px; }
.mypage-title h2 { font-size:28px; font-weight:800; margin:0; }
.mypage-sub { color:#6b7280; margin-top:6px; font-size:14px; }
.card { background:#fff; border:1px solid #eef0f3; border-radius:18px; }
.card-hd { padding:18px 18px 0; }
.card-hd h3 { margin:0; font-size:18px; font-weight:800; }
.card-bd { padding:18px; }
.form-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
.form-row { display:flex; flex-direction:column; gap:8px; }
.form-row.full { grid-column:1/-1; }
.label { font-size:13px; color:#6b7280; font-weight:700; }
.input { height:44px; border:1px solid #e5e7eb; border-radius:12px; padding:0 12px; outline:none; }
.input:focus { border-color:#7c3aed; box-shadow:0 0 0 3px rgba(124,58,237,.12); }
.hint { font-size:12px; color:#6b7280; }
.error { margin:0 0 14px; padding:12px 14px; border-radius:12px; background:rgba(239,68,68,.08); color:#b91c1c; border:1px solid rgba(239,68,68,.18); font-weight:700; }
.notice { margin:0 0 14px; padding:12px 14px; border-radius:12px; background:rgba(124,58,237,.08); color:#4c1d95; border:1px solid rgba(124,58,237,.18); font-weight:700; font-size:13px; }
.actions { display:flex; gap:10px; margin-top:16px; }
.btn { display:inline-flex; align-items:center; justify-content:center; height:44px; padding:0 16px; border-radius:999px; font-weight:800; text-decoration:none; cursor:pointer; }
.btn-primary { background:#7c3aed; color:#fff; border:none; }
.btn-ghost { border:1px solid #e5e7eb; color:#111827; background:#fff; }
@media (max-width:980px){ .form-grid { grid-template-columns:1fr; } }
</style>

<div class="mypage-wrap">
  <div class="mypage-title">
    <div>
      <h2>회원정보 수정</h2>
      <div class="mypage-sub">이메일 / 휴대폰 / 생일 / 주소 등을 변경할 수 있어요.</div>
    </div>
  </div>

  <div class="card">
    <div class="card-hd">
      <h3>기본 정보</h3>
    </div>

    <div class="card-bd">

      <% if (isSocial) { %>
        <div class="notice">SNS 회원은 비밀번호가 없어서 비밀번호 변경은 불가해요. (기본 정보는 수정 가능)</div>
      <% } %>

      <% if (!error.isEmpty()) { %>
        <div class="error"><%=error%></div>
      <% } %>

      <form method="post" action="<%=ctx%>/tickethub/mypage/update">
        <input type="hidden" name="memberId" value="<%=member.getMemberId()%>" />

        <div class="form-grid">
          <div class="form-row">
            <div class="label">아이디 (수정 불가)</div>
            <input class="input" type="text" value="<%=member.getLoginId()%>" readonly />
          </div>

          <div class="form-row">
            <div class="label">이름 (수정 불가)</div>
            <input class="input" type="text" value="<%=member.getName()%>" readonly />
          </div>

          <div class="form-row">
            <div class="label">이메일 (필수)</div>
            <input class="input" type="email" name="email"
                   value="<%=member.getEmail() == null ? "" : member.getEmail()%>"
                   placeholder="example@email.com" required />
          </div>

          <div class="form-row">
            <div class="label">휴대폰 번호 (필수)</div>
            <input class="input" type="text" name="phone"
                   value="<%=member.getPhone() == null ? "" : member.getPhone()%>"
                   placeholder="01012345678 (하이픈 없이)" required />
            <div class="hint">하이픈은 자동 제거됩니다.</div>
          </div>

          <div class="form-row">
            <div class="label">생일</div>
            <input class="input" type="date" name="birthDate" value="<%=birthValue%>" />
          </div>

          <div class="form-row">
            <div class="label">우편번호</div>
            <input class="input" type="text" name="zipCode"
                   value="<%=member.getZipCode() == null ? "" : member.getZipCode()%>"
                   placeholder="우편번호" />
          </div>

          <div class="form-row full">
            <div class="label">주소</div>
            <input class="input" type="text" name="address"
                   value="<%=member.getAddress() == null ? "" : member.getAddress()%>"
                   placeholder="주소" />
          </div>
        </div>

        <div class="actions">
          <button class="btn btn-primary" type="submit">저장</button>
          <a class="btn btn-ghost" href="<%=ctx%>/tickethub/mypage">취소</a>
        </div>
      </form>

      <%-- 비밀번호 변경 섹션: 일반회원만 보이게 --%>
      <% if (!isSocial) { %>
        <hr style="margin:22px 0; border:none; border-top:1px solid #f3f4f6;" />

        <div style="display:flex; align-items:center; justify-content:space-between; gap:12px;">
          <div>
            <div style="font-weight:800; margin-bottom:6px;">비밀번호 변경</div>
            <div class="hint">보안을 위해 비밀번호 확인 후 변경 화면으로 이동합니다.</div>
          </div>

          
          <a class="btn btn-ghost" href="<%=ctx%>/tickethub/mypage/password?next=password-change">비밀번호 확인</a>
        </div>
      <% } %>

    </div>
  </div>
</div>

<%@ include file="../../ticket/inc/footer.jsp"%>
<%@ include file="../../ticket/inc/footer_link.jsp"%>