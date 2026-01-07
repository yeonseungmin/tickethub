<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="zxx">

<head>
<meta charset="UTF-8">
<%@ include file="../inc/head_link.jsp"%>

<style>
.auth-card{
	background:#fff;
	border:1px solid #e9ecef;
	border-radius:14px;
	padding:26px 22px;
	box-shadow:0 10px 30px rgba(0,0,0,0.06);
}

.auth-title-row{
	display:flex;
	align-items:center;
	justify-content:space-between;
	margin-bottom:16px;
}

.auth-title{
	font-size:22px;
	font-weight:800;
	margin:0;
	letter-spacing:-0.2px;
}

.auth-link-btn{
	display:inline-flex;
	align-items:center;
	justify-content:center;
	padding:8px 12px;
	border:1px solid #e9ecef;
	border-radius:10px;
	font-size:13px;
	color:#111;
	text-decoration:none;
	background:#fff;
}

.auth-link-btn:hover{
	background:#f8f9fa;
	color:#111;
	text-decoration:none;
}

.auth-field{
	margin-bottom:10px;
}

.auth-input{
	width:100%;
	height:48px;
	border:1px solid #e9ecef;
	border-radius:10px;
	padding:0 14px;
	font-size:14px;
	outline:none;
	background:#fff;
}

.auth-input:focus{
	border-color:#cfe0ff;
	box-shadow:0 0 0 4px rgba(43,111,247,0.10);
}

.btn-submit{
	width:100%;
	height:52px;
	border:none;
	border-radius:12px;
	background:#2b6ff7;
	color:#fff;
	font-weight:800;
	font-size:16px;
	letter-spacing:-0.2px;
	margin-top:6px;
	cursor:pointer;
}

.btn-submit:hover{
	filter:brightness(0.97);
}

.auth-helper{
	margin-top:10px;
	font-size:12px;
	color:#666;
	line-height:1.4;
}

.auth-error{
	margin:12px 0 0;
	padding:10px 12px;
	border-radius:10px;
	background:#fff5f5;
	border:1px solid #ffd6d6;
	color:#c53030;
	font-size:13px;
	font-weight:700;
}

.auth-page{
	margin-top:120px;
}
</style>
</head>

<body>
	<%@ include file="../inc/preloader.jsp"%>

	<section class="discount">
		<div class="container">
			<div class="row justify-content-center">
				<div class="col-lg-6 col-md-8 mb-5 auth-page">

					<div class="auth-card">

						<div class="auth-title-row">
							<h3 class="auth-title">회원가입</h3>
							<a class="auth-link-btn" href="/auth/login">로그인</a>
						</div>

						<%-- 에러 메시지: AuthController에서 model.addAttribute("error", "...")로 넘기면 표시됨 --%>
						<%
							String error = (String)request.getAttribute("error");
							if(error != null && !error.trim().isEmpty()){
						%>
							<div class="auth-error"><%= error %></div>
						<%
							}
						%>

						<form method="post" action="/auth/join" id="joinForm">
							<div class="auth-field">
								<input type="text" name="loginId" class="auth-input" placeholder="아이디" required>
							</div>

							<div class="auth-field">
								<input type="password" name="password" class="auth-input" placeholder="비밀번호" required>
							</div>

							<div class="auth-field">
								<input type="password" name="passwordConfirm" class="auth-input" placeholder="비밀번호 확인" required>
							</div>

							<div class="auth-field">
								<input type="text" name="name" class="auth-input" placeholder="이름" required>
							</div>

							<div class="auth-field">
								<input type="email" name="email" class="auth-input" placeholder="이메일" required>
							</div>

							<button type="submit" class="btn-submit">회원가입</button>

							<div class="auth-helper">
								* 가입 후 안내 메일이 발송될 수 있습니다.<br/>
								* SNS 계정으로도 로그인할 수 있어요.
							</div>
						</form>

					</div>

				</div>
			</div>
		</div>
	</section>

	<%@ include file="../inc/footer.jsp"%>
	<%@ include file="../inc/footer_link.jsp"%>

	<script>
	// 프론트 최소 검증(서버 검증은 이미 AuthController에서 하고 있으니 "보조"용)
	$(function(){
		$("#joinForm").on("submit", function(e){
			var pw = $("input[name='password']").val();
			var pw2 = $("input[name='passwordConfirm']").val();
			if(pw !== pw2){
				alert("비밀번호가 일치하지 않습니다");
				e.preventDefault();
			}
		});
	});
	</script>

</body>
</html>