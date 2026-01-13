<%@ page contentType="text/html; charset=UTF-8"%>
<%
String ctx = request.getContextPath();
String error = (String) request.getAttribute("error");
if (error == null) error = "";
%>

<%@ include file="../../ticket/inc/head_link.jsp"%>
<%@ include file="../../ticket/inc/header.jsp"%>

<div style="max-width:520px;margin:48px auto;padding:0 16px;">
  <h2 style="font-size:22px;font-weight:800;margin-bottom:10px;">비밀번호 변경</h2>
  <p style="color:#6b7280;margin-bottom:18px;">새 비밀번호를 입력해주세요. (8~20자, 소문자+숫자 포함)</p>

  <% if(!error.isEmpty()){ %>
    <div style="margin-bottom:14px;padding:12px 14px;border-radius:12px;
      background:rgba(239,68,68,.08);color:#b91c1c;border:1px solid rgba(239,68,68,.18);font-weight:700;">
      <%=error%>
    </div>
  <% } %>

  <form method="post" action="<%=ctx%>/tickethub/mypage/password-change"
        style="background:#fff;border:1px solid #eef0f3;border-radius:16px;padding:18px;">

    <label style="display:block;font-size:13px;color:#6b7280;margin-bottom:6px;">새 비밀번호</label>
    <input name="newPassword" type="password"
      style="width:100%;height:44px;border:1px solid #e5e7eb;border-radius:12px;padding:0 12px;" />

    <label style="display:block;font-size:13px;color:#6b7280;margin:12px 0 6px;">새 비밀번호 확인</label>
    <input name="newPasswordConfirm" type="password"
      style="width:100%;height:44px;border:1px solid #e5e7eb;border-radius:12px;padding:0 12px;" />

    <button type="submit"
      style="margin-top:14px;width:100%;height:44px;border-radius:999px;border:0;background:#7c3aed;color:#fff;font-weight:800;">
      변경하기
    </button>

    <a href="<%=ctx%>/tickethub/mypage"
      style="display:block;margin-top:10px;text-align:center;color:#111827;text-decoration:none;font-weight:700;">
      취소
    </a>
  </form>
</div>

<%@ include file="../../ticket/inc/footer.jsp"%>
<%@ include file="../../ticket/inc/footer_link.jsp"%>