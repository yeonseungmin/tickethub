<%@ page contentType="text/html; charset=UTF-8"%>
<%
String ctx = request.getContextPath();

// next 파라미터(예: edit, password-change)
String next = request.getParameter("next");
if (next == null) next = "";
%>

<%@ include file="../../ticket/inc/head_link.jsp"%>
<%@ include file="../../ticket/inc/header.jsp"%>

<style>
.page {
	min-height: calc(100vh - 0px);
	display: flex;
	flex-direction: column;
}
.page-main { flex: 1; }

.pw-wrap {
	max-width: 520px;
	margin: 48px auto;
	padding: 0 16px;
}

.pw-card {
	background: #fff;
	border: 1px solid #eef0f3;
	border-radius: 16px;
	padding: 18px;
}

.pw-input {
	width: 100%;
	height: 44px;
	border: 1px solid #e5e7eb;
	border-radius: 12px;
	padding: 0 12px;
	outline: none;
}

.pw-input:focus {
	border-color: #7c3aed;
	box-shadow: 0 0 0 3px rgba(124, 58, 237, .12);
}

.pw-btn {
	margin-top: 14px;
	width: 100%;
	height: 44px;
	border-radius: 999px;
	border: 0;
	background: #7c3aed;
	color: #fff;
	font-weight: 800;
	cursor: pointer;
}

.pw-btn:disabled {
	opacity: .6;
	cursor: not-allowed;
}

.pw-msg {
	margin-top: 10px;
	color: #ef4444;
	font-size: 13px;
	display: none;
	font-weight: 700;
}
</style>

<div class="page">
	<main class="page-main">

		<div class="pw-wrap">
			<h2 style="font-size: 22px; font-weight: 800; margin-bottom: 10px;">비밀번호 확인</h2>
			<p style="color: #6b7280; margin-bottom: 18px;">
				보안을 위해 비밀번호를 한 번 확인할게요.
			</p>

			<div class="pw-card">
				<label style="display:block;font-size:13px;color:#6b7280;margin-bottom:6px;">비밀번호</label>

				<input id="pw" class="pw-input" type="password" autocomplete="current-password" />

				<div id="msg" class="pw-msg"></div>

				<button id="btn" type="button" class="pw-btn" onclick="verifyPw()">확인</button>

				<a href="<%=ctx%>/tickethub/mypage"
				   style="display:block;margin-top:10px;text-align:center;color:#111827;text-decoration:none;font-weight:700;">
					취소
				</a>
			</div>
		</div>

	</main>

	<%@ include file="../../ticket/inc/footer.jsp"%>
</div>

<%@ include file="../../ticket/inc/footer_link.jsp"%>

<script>
(function(){
  // next 파라미터 (JSP에서 안전하게 넘겨줌)
  var NEXT = "<%= next.replace("\"","\\\"") %>"; // 간단 이스케이프

  // 엔터로 제출
  var pwInput = document.getElementById('pw');
  pwInput.addEventListener('keydown', function(e){
    if(e.key === 'Enter'){
      e.preventDefault();
      verifyPw();
    }
  });

  // 혹시 next가 URL에 없는데도 history에 남아있으면 대비(선택)
})();

function verifyPw(){
  var pw = document.getElementById('pw').value || '';
  var message = document.getElementById('msg');
  var btn = document.getElementById('btn');

  message.style.display='none';
  message.textContent = '';

  if(!pw.trim()){
    message.textContent = '비밀번호를 입력해주세요';
    message.style.display='block';
    return;
  }

  btn.disabled = true;

  // 컨트롤러가 Map(JSON)으로 내려주니까 r.json()으로 받는게 정석
  // 혹시 예전 코드가 문자열로 내려줘도 안전하게 처리하려고 text->parse로 방어
  fetch('<%=ctx%>/tickethub/mypage/verify', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8'},
    body: 'password=' + encodeURIComponent(pw) + '&next=' + encodeURIComponent(NEXT || '')
  })
  .then(function(r){ return r.text(); })
  .then(function(text){
    var data = {};
    try { data = JSON.parse(text); }
    catch(e){ data = { ok:false, message:'서버 응답(JSON) 파싱 실패' }; }

    if(data.ok){
      // 컨트롤러가 redirectUrl을 내려주면 그걸 우선 사용
      // 없으면 next 기준으로 기본 이동
      if(data.redirectUrl){
        location.href = '<%=ctx%>' + data.redirectUrl;
        return;
      }

      // fallback
      if((NEXT || '') === 'password-change'){
        location.href = '<%=ctx%>/tickethub/mypage/password-change';
      }else{
        location.href = '<%=ctx%>/tickethub/mypage/edit';
      }
      return;
    }

    message.textContent = (data.message || data.msg || '비밀번호 확인 실패');
    message.style.display='block';
  })
  .catch(function(){
    message.textContent = '서버 통신 오류';
    message.style.display='block';
  })
  .finally(function(){
    btn.disabled = false;
  });
}
</script>