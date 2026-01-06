<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="zxx">

<head>
    <meta charset="UTF-8">
    

    <%@ include file="../inc/head_link.jsp" %>
    
    <style>
  .auth-card{
    background: #fff;
    border: 1px solid #e9ecef;
    border-radius: 14px;
    padding: 26px 22px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.06);
  }

  .auth-title-row{
    display:flex;
    align-items:center;
    justify-content:space-between;
    margin-bottom: 16px;
  }
  .auth-title{
    font-size: 22px;
    font-weight: 800;
    margin: 0;
    letter-spacing: -0.2px;
  }
  .auth-join-btn{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    padding: 8px 12px;
    border: 1px solid #e9ecef;
    border-radius: 10px;
    font-size: 13px;
    color: #111;
    text-decoration: none;
    background: #fff;
  }
  .auth-join-btn:hover{
    background:#f8f9fa;
    text-decoration:none;
    color:#111;
  }

  .auth-field{ margin-bottom: 10px; }
  .auth-input{
    width: 100%;
    height: 48px;
    border: 1px solid #e9ecef;
    border-radius: 10px;
    padding: 0 14px;
    font-size: 14px;
    outline: none;
    background: #fff;
  }
  .auth-input:focus{
    border-color:#cfe0ff;
    box-shadow: 0 0 0 4px rgba(43,111,247,0.10);
  }

  .auth-submit{
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
  }
  .auth-submit:hover{ filter: brightness(0.97); }

  .auth-divider{
    display:flex;
    align-items:center;
    gap: 12px;
    margin: 18px 0 14px;
    color:#aaa;
    font-size: 12px;
    font-weight: 700;
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
    flex-direction: column;
    gap: 10px;
  }

  .sns-btn{
    width: 100%;
    height: 48px;
    border-radius: 12px;
    border: 1px solid #e9ecef;
    font-weight: 800;
    font-size: 14px;
    display:flex;
    align-items:center;
    justify-content:center;
    background:#fff;
  }

  .btn-google{ background:#DB4437; color:#fff; border:none; }
  .btn-google:hover{ filter: brightness(0.97); color:#fff; }

  .btn-naver{ background:#03C75A; color:#fff; border:none; }
  .btn-naver:hover{ filter: brightness(0.97); color:#fff; }

  .btn-kakao{ background:#FEE500; color:#191919; border:none; }
  .btn-kakao:hover{ filter: brightness(0.97); color:#191919; }
</style>
</head>

<body>
    <!-- Page Preloder -->
    <%@ include file="../inc/preloader.jsp" %>
<section class="discount">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-lg-6 col-md-8 mt-5 mb-5">

        <div class="auth-card">
          <div class="auth-title-row">
            <h3 class="auth-title">로그인</h3>
            <a class="auth-join-btn" href="/member/join">회원가입</a>
          </div>

          <!-- 아이디 / 비밀번호 로그인 -->
          <form method="post" action="/member/login">
            <div class="auth-field">
              <input type="text" name="memberId" class="auth-input" placeholder="아이디" required>
            </div>

            <div class="auth-field">
              <input type="password" name="password" class="auth-input" placeholder="비밀번호" required>
            </div>

            <button type="submit" class="auth-submit">로그인</button>
          </form>

          <!-- 구분선 -->
          <div class="auth-divider">
            <span>또는</span>
          </div>

          <!-- SNS 로그인 -->
          <div class="auth-sns">
            <button type="button" class="sns-btn btn-google">Google로 로그인</button>
            <button type="button" class="sns-btn btn-naver">Naver로 로그인</button>
            <button type="button" class="sns-btn btn-kakao">Kakao로 로그인</button>
          </div>

        </div><!-- /auth-card -->

      </div>
    </div>
  </div>
</section>
	<!-- Footer Section Begin -->
	<%@ include file="../inc/footer.jsp" %>
	<!-- Footer Section End -->

	<!-- Js Plugins -->
	<%@ include file="../inc/footer_link.jsp" %>
	
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
			$(".btn-google").click(()=>{
				requestProviderUrl("google");
			})
			
			$(".btn-naver").click(()=>{
				requestProviderUrl("naver");
			})
			
			$(".btn-kakao").click(()=>{
				requestProviderUrl("kakao");
			})
		})
	
		
	</script>
</body>

</html>