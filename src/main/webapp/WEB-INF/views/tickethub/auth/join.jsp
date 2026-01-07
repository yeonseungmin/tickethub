<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="zxx">
<head>
<meta charset="UTF-8">

<%@ include file="../inc/head_link.jsp"%>

<style>
.login-wrapper {
	display: flex;
	justify-content: center;
	padding-top: 120px;
}

.auth-card {
	background: #fff;
	border: 1px solid #e9ecef;
	border-radius: 14px;
	padding: 28px 24px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
	width: 100%;
	max-width: 420px;
}

.auth-title-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 18px;
}

.auth-title {
	font-size: 22px;
	font-weight: 800;
	margin: 0;
}

.auth-back-btn {
	font-size: 13px;
	color: #555;
	text-decoration: none;
}

.auth-back-btn:hover {
	text-decoration: underline;
}

.auth-field {
	margin-bottom: 12px;
}

.auth-input {
	width: 100%;
	height: 48px;
	border: 1px solid #e9ecef;
	border-radius: 10px;
	padding: 0 14px;
	font-size: 14px;
}

.auth-input:focus {
	border-color: #cfe0ff;
	box-shadow: 0 0 0 4px rgba(43, 111, 247, 0.1);
	outline: none;
}

.auth-submit {
	width: 100%;
	height: 52px;
	border: none;
	border-radius: 12px;
	background: #2b6ff7;
	color: #fff;
	font-weight: 800;
	font-size: 16px;
	margin-top: 10px;
}

.auth-submit:hover {
	filter: brightness(0.97);
}
</style>
</head>

<body>

	<%@ include file="../inc/preloader.jsp"%>

	<section>
		<div class="container">
			<div class="row justify-content-center">
				<div class="login-wrapper">

					<div class="auth-card">
						<div class="auth-title-row">
							<h3 class="auth-title">회원가입</h3>
							<a href="/auth/login" class="auth-back-btn">로그인</a>
						</div>

						<form method="post" action="/member/join">

							<div class="auth-field">
								<input type="text" name="memberId" class="auth-input"
									placeholder="아이디" required>
							</div>

							<div class="auth-field">
								<input type="password" name="password" class="auth-input"
									placeholder="비밀번호" required>
							</div>

							<div class="auth-field">
								<input type="password" name="passwordConfirm" class="auth-input"
									placeholder="비밀번호 확인" required>
							</div>

							<div class="auth-field">
								<input type="text" name="name" class="auth-input"
									placeholder="이름" required>
							</div>

							<div class="auth-field">
								<input type="email" name="email" class="auth-input"
									placeholder="이메일" required>
							</div>

							<button type="submit" class="auth-submit">회원가입</button>

						</form>
					</div>

				</div>
			</div>
		</div>
	</section>

	<%@ include file="../inc/footer.jsp"%>
	<%@ include file="../inc/footer_link.jsp"%>

</body>
</html>