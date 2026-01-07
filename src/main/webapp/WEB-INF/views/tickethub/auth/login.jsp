<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List"%>
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

.btn-login{
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

.btn-login:hover{
	filter:brightness(0.97);
}

.auth-divider{
	display:flex;
	align-items:center;
	gap:12px;
	margin:18px 0 14px;
	color:#aaa;
	font-size:12px;
	font-weight:700;
}

.auth-divider:before,
.auth-divider:after{
	content:"";
	flex:1;
	height:1px;
	background:#eee;
}

.auth-sns{
	display:flex;
	flex-direction:column;
	gap:10px;
}

.sns-btn{
	width:100%;
	height:48px;
	border-radius:12px;
	border:1px solid #e9ecef;
	font-weight:800;
	font-size:14px;
	display:flex;
	align-items:center;
	justify-content:center;
	background:#fff;
	cursor:pointer;
}

.btn-google{
	background:#DB4437;
	color:#fff;
	border:none;
}

.btn-google:hover{
	filter:brightness(0.97);
	color:#fff;
}

.btn-naver{
	background:#03C75A;
	color:#fff;
	border:none;
}

.btn-naver:hover{
	filter:brightness(0.97);
	color:#fff;
}

.btn-kakao{
	background:#FEE500;
	color:#191919;
	border:none;
}

.btn-kakao:hover{
	filter:brightness(0.97);
	color:#191919;
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
							<h3 class="auth-title">로그인</h3>
							<a class="auth-link-btn" href="/auth/join">회원가입</a>
						</div>

						<form method="post" action="/auth/login" id="loginForm">
							<div class="auth-field">
								<input type="text" name="memberId"
									class="auth-input"
									placeholder="아이디"
									required>
							</div>

							<div class="auth-field">
								<input type="password" name="password"
									class="auth-input"
									placeholder="비밀번호"
									required>
							</div>

							<button type="submit" class="btn-login">로그인</button>
						</form>

						<div class="auth-divider">
							<span>또는</span>
						</div>

						<div class="auth-sns">
							<button type="button" class="sns-btn btn-google" data-provider="google">
								Google로 로그인
							</button>
							<button type="button" class="sns-btn btn-naver" data-provider="naver">
								Naver로 로그인
							</button>
							<button type="button" class="sns-btn btn-kakao" data-provider="kakao">
								Kakao로 로그인
							</button>
						</div>

					</div>

				</div>
			</div>
		</div>
	</section>

	<%@ include file="../inc/footer.jsp"%>
	<%@ include file="../inc/footer_link.jsp"%>

	<script>
	function requestProviderUrl(provider){
		$.ajax({
			url:"/oauth2/authorize/"+provider, //
			method:"GET",
			success:function(result, status, xhr){
				console.log("서버로부터 받은 인증 요청 url은 ", result);
				alert(result);
				location.href=result;
			}
		});
	}
	
		$(()=>{
			$(".sns-btn.btn-google").click(()=>{
				requestProviderUrl("google");
			})
			
			$(".sns-btn.btn-naver").click(()=>{
				requestProviderUrl("naver");
			})
			
			$(".sns-btn.btn-kakao").click(()=>{
				requestProviderUrl("kakao");
			})
			
			$(".btn-login").click(()=>{
				
			})
			$(".btn-join").click(()=>{
				
			})
		})
	
		
	</script>
</body>

</html>