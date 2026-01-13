<%@ page contentType="text/html; charset=UTF-8"%>
<%
String ctx = request.getContextPath();

// next 파라미터(예: edit, password-change)
String next = request.getParameter("next");
if (next == null) next = "edit"; // 기본은 edit
%>

<%@ include file="../../ticket/inc/head_link.jsp"%>
<%@ include file="../../ticket/inc/header.jsp"%>

<style>
.page { min-height: calc(100vh - 0px); display:flex; flex-direction:column; }
.page-main { flex:1; }
.pw-wrap { max-width:520px; margin:48px auto; padding:0 16px; }
.pw-card { background:#fff; border:1px solid #eef0f3; border-radius:16px; padding:18px; }
.pw-input { width:100%; height:44px; border:1px solid #e5e7eb; border-radius:12px; padding:0 12px; outline:none; }
.pw-input:focus { border-color:#7c3aed; box-shadow:0 0 0 3px rgba(124,58,237,.12); }
.pw-btn { margin-top:14px; width:100%; height:44px; border-radius:999px; border:0; background:#7c3aed; color:#fff; font-weight:800; cursor:pointer; }
.pw-btn:disabled { opacity:.6; cursor:not-allowed; }
.pw-msg { margin-top:10px; color:#ef4444; font-size:13px; display:none; font-weight:700; }
.pw-debug { margin-top:10px; font-size:12px; color:#6b7280; white-space:pre-wrap; display:none; }
</style>

<div class="page">
  <main class="page-main">
    <div class="pw-wrap">
      <h2 style="font-size:22px;font-weight:800;margin-bottom:10px;">비밀번호 확인</h2>
      <p style="color:#6b7280;margin-bottom:18px;">보안을 위해 비밀번호를 한 번 확인할게요.</p>

      <div class="pw-card">
        <label style="display:block;font-size:13px;color:#6b7280;margin-bottom:6px;">비밀번호</label>
        <input id="pw" class="pw-input" type="password" autocomplete="current-password" />

        <div id="msg" class="pw-msg"></div>
        <div id="debug" class="pw-debug"></div>

        <!-- onclick 제거하고 addEventListener로만 연결(중복/충돌 방지) -->
        <button id="btn" type="button" class="pw-btn">확인</button>

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
// next뒤에 있는 거 백슬래시보호로 넣어야함!
(function(){
  var NEXT = "<%= next.replace("\\", "\\\\").replace("\"","\\\"") %>"; 
  var ctx  = "<%=ctx%>";

  var pwInput = document.getElementById('pw');
  var btn     = document.getElementById('btn');
  var msg     = document.getElementById('msg');

  function showMsg(t){
    msg.textContent = t || '';
    msg.style.display = 'block';
  }
  function hideMsg(){
    msg.textContent = '';
    msg.style.display = 'none';
  }

  function verifyPw(){
    var pw = (pwInput.value || '').trim(); // 공백 없애주기 (바꿀것의 밸류 || 공백).trim();
    hideMsg();

    if(!pw){
      showMsg('비밀번호를 입력해주세요');
      return;
    }

    btn.disabled = true;

    fetch(ctx + '/tickethub/mypage/verify', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8'}, //password=1234&next=edit로 보내는데, 한글 안 깨지게
      body: 'password=' + encodeURIComponent(pw) + '&next=' + encodeURIComponent(NEXT || 'edit')
    })
    .then(function(r){
      // 서버가 JSON이 아닐 수도 있으니 안전하게 처리
      return r.text(); //일단 글자로 받기
    })
    .then(function(text){
      var data;
      try { data = JSON.parse(text); } //될때 json으로 변환
      catch(e){
        // JSON이 아니면(로그인 만료로 HTML 반환 등) -> 메시지
        showMsg('서버 응답이 JSON이 아닙니다. (로그인 만료/에러 가능)');
        return;
      }

      if(data.ok){
        var url = data.redirectUrl ? (ctx + data.redirectUrl) : (ctx + '/tickethub/mypage/edit');
        location.replace(url);
        return;
      }

      showMsg(data.message || data.msg || '비밀번호 확인 실패');
    })
    .catch(function(){
      showMsg('서버 통신 오류');
    })
    .finally(function(){
      btn.disabled = false;
    });
  }

  // 이벤트 1번만 연결(헷갈리면 안됨!! 주의하기!)
  btn.addEventListener('click', verifyPw);
  pwInput.addEventListener('keydown', function(e){
    if(e.key === 'Enter'){
      e.preventDefault();
      verifyPw();
    }
  });
})();
</script>