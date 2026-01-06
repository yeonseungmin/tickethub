<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="static/assets/css/waiting.css">
	<meta charset="UTF-8">
	<title>대기열 - TicketHub</title>
</head>
<body>
	<div class="container">
		<h2>나의 대기순서</h2>
		<div id="rankDisplay" class="rank">...</div>
		<div class="progress-container">
			<div id="progressBar" class="progress-bar"></div>
		</div>
		<p>
			현재 접속 인원이 많아 대기 중입니다.<br>잠시만 기다려주시면 예매 페이지로 연결됩니다.
		</p>
		<strong>&#8251; 새로고침 하거나 재접속 하시면 대기순서가 초기화되어 대기시간이 더 길어집니다.</strong>
	</div>

	<script>
		let initialRank = 0; // 처음 내 순번을 기억할 변수
		
		document.addEventListener("DOMContentLoaded", function() {
		    // 진입. 페이지 열리자마자 대기열 등록
		    fetch("queue/enter", { method: "POST" })
		        .then(res => res.json())
		        .then(data => {
		            initialRank = data.rank; // 처음 순번 저장 (예: 100)
		            updateUI(data);
		            startPolling();
		        });
		
		    function startPolling() {
		        const timer = setInterval(() => {
		            // 조회. 0.7초마다 내 상태 물어보기
		            fetch("queue/status")
		                .then(res => res.json())
		                .then(data => {
		                    updateUI(data);
		                    if (data.allowed) {
		                        clearInterval(timer);
		                        alert("입장합니다!");
		                        location.href = "./"; // 홈으로 이동
		                    }
		                });
		        }, 700);
		    }
		
		    function updateUI(data) {
		        document.getElementById("rankDisplay").innerText = data.rank;
		        
		        // 게이지 계산. (초기값 - 현재값) / 초기값 * 100
		        if (initialRank > 0) {
		            let progress = ((initialRank - data.rank) / initialRank) * 100;
		            progress = Math.max(0, Math.min(100, progress)); // 0~100 사이로 고정
		            document.getElementById("progressBar").style.width = progress + "%";
		        }
		    }
		});
	</script>


</body>

</html>