<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zxx">
<head>
<meta charset="UTF-8">
<title>추가 회원정보 입력</title>

<%@ include file="../../ticket/inc/head_link.jsp"%>

<style>
/* ===== Join/Profile Page Layout ===== */
.auth-section {
  min-height: calc(100vh - 220px);
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding: 72px 16px 24px;
  background: #f7f8fa;
}

.auth-container {
  width: 100%;
  max-width: 420px;
}

/* ===== Card ===== */
.auth-card {
  background: #fff;
  border: 1px solid #e9ecef;
  border-radius: 14px;
  padding: 26px 22px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
}

.auth-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 10px;
}

.auth-title {
  font-size: 22px;
  font-weight: 800;
  margin: 0;
  letter-spacing: -0.2px;
}

.auth-link-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 8px 12px;
  border: 1px solid #e9ecef;
  border-radius: 10px;
  font-size: 13px;
  color: #111;
  text-decoration: none;
  background: #fff;
  white-space: nowrap;
}

.auth-link-btn:hover {
  background: #f8f9fa;
  color: #111;
  text-decoration: none;
}

/* ===== Description ===== */
.auth-desc {
  margin: 0 0 16px;
  color: #666;
  font-size: 13px;
  line-height: 1.5;
}

/* ===== Fields ===== */
.auth-field {
  margin-bottom: 10px;
}

.auth-input {
  width: 100%;
  height: 48px;
  border: 1px solid #e9ecef;
  border-radius: 10px;
  padding: 0 14px;
  font-size: 14px;
  outline: none;
  background: #fff;
}

.auth-input:focus {
  border-color: #cfe0ff;
  box-shadow: 0 0 0 4px rgba(43, 111, 247, 0.10);
}

/* ===== Hint ===== */
.auth-hint {
  margin-top: 6px;
  font-size: 12px;
  color: #888;
  line-height: 1.4;
}

/* ===== Button ===== */
.btn-submit {
  width: 100%;
  height: 52px;
  border: none;
  border-radius: 12px;
  background: #2b6ff7;
  color: #fff;
  font-weight: 800;
  font-size: 16px;
  letter-spacing: -0.2px;
  margin-top: 6px;
  cursor: pointer;
}

.btn-submit:hover {
  filter: brightness(0.97);
}

/* ===== Helper / Error ===== */
.auth-helper {
  margin-top: 10px;
  font-size: 12px;
  color: #666;
  line-height: 1.4;
}

.auth-error {
  margin: 0 0 12px;
  padding: 10px 12px;
  border-radius: 10px;
  background: #fff5f5;
  border: 1px solid #ffd6d6;
  color: #c53030;
  font-size: 13px;
  font-weight: 700;
}
</style>
</head>

<body>
  <%@ include file="../../ticket/inc/header.jsp"%>

  <section class="auth-section">
    <div class="auth-container">
      <div class="auth-card">

        <div class="auth-title-row">
          <h3 class="auth-title">상세 회원정보 입력</h3>

          <%-- joinDraft(가입중) 단계에서는 로그인 링크가 오히려 혼란일 수 있어서 분기 --%>
          <c:choose>
            <c:when test="${not empty joinDraft}">
              <a class="auth-link-btn" href="${pageContext.request.contextPath}/auth/join">이전</a>
            </c:when>
            <c:otherwise>
              <a class="auth-link-btn" href="${pageContext.request.contextPath}/auth/login">로그인</a>
            </c:otherwise>
          </c:choose>
        </div>

        <%-- 안내 문구(이유 + joinDraft 여부) --%>
        <c:choose>
          <c:when test="${not empty joinDraft}">
            <p class="auth-desc">
              가입을 마무리하려면 추가 정보를 입력해주세요. (입력 완료 후 회원가입이 완료됩니다)
            </p>
          </c:when>
          <c:when test="${reason == 'OAUTH_FIRST_LOGIN'}">
            <p class="auth-desc">
              SNS 첫 로그인입니다. 서비스 이용을 위해 추가 정보를 입력해주세요.
            </p>
          </c:when>
          <c:when test="${reason == 'JOIN_FIRST'}">
            <p class="auth-desc">
              서비스 이용을 위해 추가 정보를 입력해주세요.
            </p>
          </c:when>
          <c:otherwise>
            <p class="auth-desc">
              서비스 이용을 위해 추가 정보를 입력해주세요.
            </p>
          </c:otherwise>
        </c:choose>

        <%-- 에러 메시지 --%>
        <c:if test="${not empty errorMsg}">
          <div class="auth-error">${errorMsg}</div>
        </c:if>

        <%-- =========================
             폼: joinDraft / member 공용
             ========================= --%>
        <form method="post" action="${pageContext.request.contextPath}/auth/profile" autocomplete="off">

          <%-- ✅ joinDraft 모드면: memberId가 없으니 mode로 구분 --%>
          <c:if test="${not empty joinDraft}">
            <input type="hidden" name="mode" value="joinDraft"/>
          </c:if>

          <%-- ✅ member 모드면: 기존처럼 memberId --%>
          <c:if test="${empty joinDraft}">
            <input type="hidden" name="mode" value="member"/>
            <input type="hidden" name="memberId" value="${member.memberId}" />
          </c:if>

          <%-- 값 바인딩: joinDraft면 빈값, member면 기존값 --%>
          <div class="auth-field">
            <input type="text" name="phone" class="auth-input"
                   placeholder="휴대폰 번호 (01012345678 / 010-1234-5678)"
                   value="<c:out value='${member.phone}'/>"
                   maxlength="20" required />
            <div class="auth-hint">숫자만 입력해도 됩니다. 예) 01012345678</div>
          </div>

          <div class="auth-field">
            <input type="text" name="zipCode" class="auth-input"
                   placeholder="우편번호 (5자리)"
                   value="<c:out value='${member.zipCode}'/>"
                   maxlength="10" required />
            <div class="auth-hint">예) 06236</div>
          </div>

          <div class="auth-field">
            <input type="text" name="address" class="auth-input"
                   placeholder="주소 (예: 서울특별시 강남구 ...)"
                   value="<c:out value='${member.address}'/>"
                   maxlength="100" required />
          </div>

          <%-- 버튼 텍스트도 모드별로 --%>
          <c:choose>
            <c:when test="${not empty joinDraft}">
              <button type="submit" class="btn-submit">가입 완료하기</button>
            </c:when>
            <c:otherwise>
              <button type="submit" class="btn-submit">저장하고 계속하기</button>
            </c:otherwise>
          </c:choose>

          <div class="auth-helper">
            * 자세한 사항은 마이페이지 > 회원정보 수정에서 수정할 수 있습니다.
          </div>
        </form>

      </div>
    </div>
  </section>

  <%@ include file="../../ticket/inc/footer.jsp"%>
  <%@ include file="../../ticket/inc/footer_link.jsp"%>
</body>
</html>