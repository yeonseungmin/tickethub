<%@page import="com.ch.tickethub.dto.RoundCasting"%>
<%@page import="java.util.List"%>
<%@page import="com.ch.tickethub.dto.Work"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Work work = (Work)request.getAttribute("work");
	List<RoundCasting> uniqueCastingList = (List)request.getAttribute("uniqueCastingList");
	String jsonWork = (String)request.getAttribute("jsonWork");
	String naverMapClientId = (String)request.getAttribute("naverMapClientId");
	
	// 장르 이름 가져오기
    String genreName = work.getGenre().getGenre_name();
    // 캐스팅을 보여줄 장르 여부 확인
    boolean showCasting = "뮤지컬".equals(genreName) || "연극".equals(genreName);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공연 상세 정보</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	<link rel="stylesheet" href="/static/assets/css/detail.css">
</head>
<body class="layout-top-nav" style="background-color: #ffffff;">
<% System.out.println(uniqueCastingList); %>
<% System.out.println(jsonWork); %>
<script src="/static/assets/js/Util.js"></script>
<script src="/static/assets/js/Paging.js"></script>
<script>
	let currentDate;
	// 오늘 날짜 최소가 되는 달
	let minDate;
	// work_end_date가 달력의 마지막 달
	let maxDate;
	let work = <%=jsonWork%>;
	let reviewList;
	let paging;
	
	// 예비용. 접속자의 멤버 아이디가 1이라면? 나중에 session으로 교체
	let memberId = 1;
</script>
<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=<%=naverMapClientId%>"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>

<script>
    // 좋아요 버튼 토글
    function toggleLike(btn) {
        $(btn).toggleClass("active");
        let $icon = $(btn).find('i');
        let $count = $("#likeCount");
        let currentVal = parseInt($count.text().replace(/,/g, ''));

        if($(btn).hasClass("active")) {
            $icon.removeClass('far').addClass('fas');
            $count.text((currentVal + 1).toLocaleString());
        } else {
            $icon.removeClass('fas').addClass('far');
            $count.text((currentVal - 1).toLocaleString());
        }
    } 
    
    // new Date("2025-11-09")	work_start_date work_end_date 쓸 때 참조
    // new Date("2025-11-09 18:10")

    function getDayOfWeek(yy, mm, dd){
    	// 0 일요일
        let d = new Date(yy, mm, dd);
        /*
            생성자가 아닌 아래의 메서드로도 동일한 효과 남
            d.setFullYear(yy);
            d.setMonth(mm);
            d.setDate(1);
        */
        return d.getDay();  // 조작한 객체로부터 요일을 구한다..
    }

    /*
        해당 월의 총 일수 (예 - 12월은 31일까지임)
            1) 해당 월보다 1 큰(다음날) 달로 이동 (조작)
            2) 조작된 월을 대상으로 0일로 또 조작 (결국 0일은 이전 달의 마지막 날을 의미하게 되므로, 원하는 결과 구할 수 있음)
    */
   function getTotalDate(yy, mm) {
        let d = new Date(yy, mm + 1, 0);
        return d.getDate();     // 조작된 날짜 객체에게 며칠인지 물어본다.
   }
	
	function formatYMD(yyyy, mm, dd) {
		let m = mm + 1;
		m = getZeroNum(m);
		dd = getZeroNum(dd);
		
		return yyyy + "-" + m + "-" + dd;
	}
	
	function validateRoundStartTime(round_date_time){
		
		return new Date(round_date_time) > new Date();
	}
            
	/*
		달력 셀에 실제 날짜 뿌리기
	*/
        
	function displayCalendar(yy, mm){
		let n = 0;		// 현재 박스의 순번을 알기 위한 변수
		let num = 1;	// 실제 날짜에 사용할 변수
		let isFirstDate = true;
		let tag = "";
		//<td><div class="calendar-day sun active">4</div></td> <td><div class="calendar-day">5</div></td>
		//<td><div class="calendar-day">6</div></td><td><div class="calendar-day">7</div></td>
		//<td><div class="calendar-day">8</div></td><td><div class="calendar-day">9</div></td>
		//<td><div class="calendar-day">10</div></td>
		for(let i = 0; i < 6; i++){
			tag += "<tr>";
    		for(let j = 0; j < 7; j++){
    			tag += "<td>";
    			tag +="<div class='calendar-day";
    			if(getDayOfWeek(yy, mm, num) == 0){
    				tag += " sun";
    			}
       			// 이미 존재하는 박스의 셀에 출력
				if(n >=getDayOfWeek(yy, mm, 1) && num <= getTotalDate(yy, mm)){   // 순번용 변수인 n이 각월의 시작 요일에 도달할 때부터~~
					let checkDate = formatYMD(yy, mm, num);
					let isSame = false;
				
					for(let round of work.roundList){
						if(!round.is_cancelled && checkDate == round.round_date && validateRoundStartTime(round.round_date +" " + round.round_start_time)){
							// 해당 달의 예매 가능한 날 중 첫 날
							if(isFirstDate){
								tag += " active";
								// 0밀리세컨드 즉발 html 등 전부 계산하고 실행된다.
								setTimeout(() => displayRoundList(checkDate), 0);
								isFirstDate = false;
							}
							isSame = true;
							break;
						}
					}
					if(isSame){
						// data-name=value custom data 속성 $(div).data("date"); 이렇게 접근 가능
						tag += "' data-date='" + checkDate + "'>" + num;
					}else {
						tag += " disabled'>" + num;
					}
					
					num++;
				}else{
					//<td><div class="calendar-day disabled sun">28</div></td>
					tag += " disabled'>";
				}
    			tag += "</div></td>";
				n++;
			}
    		tag += "</tr>";
		}
		
		$(".calendar-table tbody").html(tag);
	}
    
    function setTitle(){
    	$(".calendar-title").html(currentDate.getFullYear() + "." + getZeroNum(currentDate.getMonth() + 1));
    }
    
    function updateDisabledButton() {
        // .prop("disabled", true/false)를 사용합니다.
        $(".btn-left").prop("disabled", !validateBtnLeft());
        $(".btn-right").prop("disabled", !validateBtnRight());
    }
    
    function validateBtnLeft(){
    	
    	let currentTotalMonth = currentDate.getFullYear() * 12 + currentDate.getMonth();
    	let minTotalMonth = minDate.getFullYear() * 12 + minDate.getMonth();
    	
    	return  currentTotalMonth > minTotalMonth;
    }
    
    function validateBtnRight(){
    	
    	let currentTotalMonth = currentDate.getFullYear() * 12 + currentDate.getMonth();
    	let maxTotalMonth = maxDate.getFullYear() * 12 + maxDate.getMonth();
    	
    	return  currentTotalMonth < maxTotalMonth;
    }
    
    function prev(){
    	
    	if(validateBtnLeft()){
    		currentDate.setMonth(currentDate.getMonth() - 1);
    		
    		setTitle();
    		displayCalendar(currentDate.getFullYear(), currentDate.getMonth());
    		updateDisabledButton();
    	}
    }
    
    function next(){
    	
		if(validateBtnRight()){
    		currentDate.setMonth(currentDate.getMonth() + 1);
    		
    		setTitle();
    		displayCalendar(currentDate.getFullYear(), currentDate.getMonth());
    		updateDisabledButton();
    	}
    }
    
    function selectRound(element, roundId) {
    	
        $(".btn-round-select").removeClass("active");
        $(element).addClass("active");
        
        updateInfo(roundId);
    }
	
    // 회차 시작 시간을 눌렀을 때
    function updateInfo(roundId) {
    	
    	// find true인 첫 번째 element 반환
    	const round = work.roundList.find((round)=>{return round.round_id == roundId});

     	$(".place span").text(round.place.place_name);
     	
     	// data-id 에 값 round_id 값 넣어주기 .attr로 바꾸지 마라. 갱신 제대로 안 해준다.
    	$(".place button").data("id", round.round_id);
     	//console.log("round_id는 ", $(".place button").data("id"));

		$("#seat-info-area .sidebar-compact-text").html(`
			<span class="font-weight-bold">VIP</span> <span class="text-soldout">매진</span> <span class="divider-slash">/</span> 
			<span class="font-weight-bold">R</span> 5석 <span class="divider-slash">/</span> 
			<span class="font-weight-bold">S</span> 20석 <span class="divider-slash">/</span> 
			<span class="font-weight-bold">A</span> 50석
		`);
		
		if(work.genre.genre_name == "뮤지컬" || work.genre.genre_name == "연극") {
	    	// JS에서 문자열 비교는 localeCompare Java는 compareTo
	    	const roundCastingList = round.roundCastingList.sort((a, b)=> a.role.localeCompare(b.role));
	    	//console.log("roundCastingList", roundCastingList);
	    	
	    	let castingText = "";
	    	roundCastingList.forEach((casting, index) => {
	    		castingText += (index == 0) ? "" : ", ";
	    		castingText += casting.person.person_name;
	    	});
	    	
			$("#daily-casting-area").text(castingText || "캐스팅 정보가 없습니다.");			
		}
		
		// 예매하기 할 때 value의 값을 좌석 선택 페이지로 전달해야 한다.
		$(".btn-reservation").val(roundId);
		//console.log("예매하기 버튼의 값은 ", $(".btn-reservation").val());
		
    }
    
    // 날짜를 눌렀을 때
    function displayRoundList(selectedDate){
    	// <div class="card-body p-3">
    	let roundArea = $(".round-select-list"); // 회차 버튼이 들어갈 컨테이너
        roundArea.empty(); // 기존 버튼 제거
    	
    	let selectedRoundList = work.roundList.filter((round)=>{
    		let isSameDate = (round.round_date == selectedDate);
    		let isNotCancelled = !round.is_cancelled;
    		let isValidTime = validateRoundStartTime(round.round_date + " " + round.round_start_time);
    		
    		return isSameDate && isNotCancelled && isValidTime;
    	});
        
        //console.log(selectedRoundList);
    	
        if(selectedRoundList.length == 0){
        	roundArea.html("<p class='text-muted text-sm'>선택 가능한 회차가 없습니다.</p>");
        	return;
        }
        
        // array.forEach(function(currentValue, index, arr)) index: 자동으로 증가함
        selectedRoundList.forEach((round, index) => {
        	// 첫 번째 회차는 자동으로 active 설정
            const activeClass = (index === 0) ? "active" : "";
        	
            const btnTag = `<button type="button" class="btn btn-round-select ` + activeClass + `"`
            				+ ` onclick="selectRound(this, ` + round.round_id + `)">`
                            + round.round_start_time + `</button>`;
                         
            roundArea.append(btnTag);
        });
        
        updateInfo(selectedRoundList[0].round_id);
    }
    
    // 달력 끝
    
    // 장소 팝업
    function openPlacePopup(btn){
    	let roundId = $(btn).data("id");
    	const round = work.roundList.find((round)=>{return round.round_id == roundId});
    	//console.log(round);
    	
    	if(round == null) return;
    	
    	const place = round.place;
    	
        // .one 첫 한 번만 실행 Bootstrap이 제공하는 모달이름 shown.bs.modal
        $("#placeModal").off("shown.bs.modal").one("shown.bs.modal", function () {
			$(".place_name").text(place.place_name);
			$(".address").text("주소 : " + place.address);
        	
            let position = new naver.maps.LatLng(place.latitude, place.longitude);
			
            let map = new naver.maps.Map('map', {
                center: position,
                zoom: 17
            });

            let marker = new naver.maps.Marker({
                position: position,
                map: map
            });
        });
    }
    // 관람후기 함수 시작
    function registReview(btn) {
    	console.log("review 등록하기 !");
    }
    
    function registReReview(btn) {
    	let review_id = $(btn).closest("li").val();
    	console.log("답글을 달 review_id는 ", review_id);
    }
    
	// [관람후기] 답글 작성 폼 토글 기능
    function toggleReplyForm(reviewId) {
        let formId = "#reply-form-" + reviewId;
        $(formId).slideToggle("fast");
    }

    // [관람후기] 후기 좋아요 토글 UI (프론트 처리만)
    function toggleLikeReview(btn) {
        let $icon = $(btn).find('i');
        let $span = $(btn).find('span');
        let count = parseInt($span.text());
        let review_id = $(btn).closest("li").val();
        console.log("좋아요를 늘릴 review_id는 ", review_id);
        
        if ($icon.hasClass('far')) { // 좋아요 안 누른 상태
            $icon.removeClass('far').addClass('fas text-primary'); // 채워진 엄지
            $span.text(count + 1);
            $span.addClass('text-primary font-weight-bold');
        } else { // 이미 누른 상태
            $icon.removeClass('fas text-primary').addClass('far'); // 빈 엄지
            $span.text(count - 1);
            $span.removeClass('text-primary font-weight-bold');
        }
    }
    
	// [관람후기] 더보기/접기 버튼 동작
    function toggleReviewText(btn) {
        let $textContainer = $(btn).prev('.review-text-clamp');
        
        if ($textContainer.hasClass('expanded')) {
            // 접기 동작
            $textContainer.removeClass('expanded');
            $(btn).html('더보기 <i class="fas fa-chevron-down"></i>');
        } else {
            // 펼치기 동작
            let review_id = $(btn).closest("li").val();
            console.log("조회수를 늘릴 review_id는 ", review_id);
            
            $textContainer.addClass('expanded');
            $(btn).html('접기 <i class="fas fa-chevron-up"></i>');
        }
    }
	
	// [관람후기] 신고 동작
	function report(btn) {
		let review_id = $(btn).closest("li").val();
		console.log("신고 당한 review_id는 ", review_id);
	}
	
	function deleteComment(btn, type) {
		
		if (type == "review") {
			let id = $(btn).closest("li").val();
			console.log("삭제할 review_id는 ", id);
		} else if(type == "re_review"){
			console.log("삭제할 re_review_id는 ", id);
		}
		
	}
	
	function displayReviewList(currentPage){
		
		paging = new Paging();
		paging.init(reviewList, currentPage);
		let num = paging.num;
		let curPos = paging.curPos;
		console.log(curPos);
		let reviewTag = "";
		
		for(let i = 0; i < paging.pageSize; i++){
			if(num < 1) break;
			num--;
			let review = reviewList[curPos++];
			// review-item이 review_id를 가지는 것이 낫다. 쓰는 곳이 많음.
			reviewTag += `									        
			<li class="review-item border-bottom py-3" value="`;
			reviewTag += review.review_id + `">
				<div class="d-flex justify-content-between align-items-end mb-2">
		            <div>
		                <span class="text-warning mr-1">`;
			for(let j = 0; j < review.rating; j++){
				reviewTag += `<i class="fas fa-star"></i>`;
			}
			
			reviewTag += `</span>`;
			
			reviewTag += `
		                <strong class="text-dark mr-2">`;
			reviewTag += review.member.loginId + `</strong>`;
			reviewTag += `
		                <span class="text-muted text-sm">`;
			reviewTag += review.review_regdate + `</span>`;
			// 조회수 review-hit
			reviewTag += `
		                <span class="text-muted text-sm ml-2 review-hit">`;
			reviewTag += `조회 ` + review.hit + `</span>
		            </div>`;
				// 만일 세션 멤버와 같다면? self 신고는 선 넘었지.

				if(memberId == review.member.memberId) {
					reviewTag += `
					<div>
	                    <button class="btn btn-xs btn-link text-muted p-0" onclick="deleteComment(this, 'review')">삭제</button>
	                </div>
				</div>
	                `;
				} else {
					reviewTag += `
				            <div>
				                <button class="btn btn-xs btn-link text-danger p-0 ml-2" onclick="report(this)" value="
				                `;
					reviewTag += review.member.memberId + `">
				                    <i class="fas fa-exclamation-circle"></i> 신고
				                </button>
				            </div>
				        </div>
				        `;					
				}
			reviewTag += `
		        <div class="font-weight-bold text-dark mb-1" style="font-size: 1.1rem;">`;
			reviewTag += review.review_title + `
		        </div>`;
			reviewTag += `
		        <div class="review-text-clamp text-dark mb-1" style="white-space: pre-wrap;">`;
			reviewTag += review.review_content + `
				</div>`;
			reviewTag += `
		        <button class="btn-more" onclick="toggleReviewText(this)">더보기 <i class="fas fa-chevron-down"></i></button>`;
			reviewTag += `
		        <div class="review-actions mt-1">
		            <button class="btn btn-xs btn-light border mr-1" onclick="toggleLikeReview(this)">
		                <i class="far fa-thumbs-up"></i> <span>`;
			reviewTag += review.review_like_count + `</span>
		            </button>`;
			reviewTag += `
		            <button class="btn btn-xs btn-light border" onclick="toggleReplyForm(`;
			reviewTag += review.review_id + `)">
		                답글 달기
		            </button>
		        </div>`;
			reviewTag += `
		        <div id="reply-form-`;
			reviewTag += review.review_id + `" class="reply-form-container mt-3" style="display: none;">
		            <div class="card bg-light border-0">
		                <div class="card-body p-2 d-flex">
		                    <textarea class="form-control form-control-sm mr-2" rows="2" placeholder="답글을 입력하세요... (최대 150자)"></textarea>
		                    <button class="btn btn-sm btn-secondary" style="width: 60px;" onclick="registReReview(this)">등록</button>
		                </div>
		            </div>
		        </div>
		        `;
			// 여기서부터 일단 나중에
			reviewTag += `
		        <div class="reply-list mt-3 pl-4 bg-light rounded p-3">
		            <div class="reply-item d-flex">
		                <div class="mr-2 text-muted"><i class="fas fa-level-up-alt fa-rotate-90"></i></div>
		                <div class="w-100">
		                    <div class="d-flex justify-content-between mb-1">
		                        <div>
		                            <span class="font-weight-bold text-sm">chicago00</span>
		                            <span class="text-muted text-xs ml-2">2025.01.29</span>
		                        </div>
				                <div>
				                    <button class="btn btn-xs btn-link text-muted p-0">삭제</button>
				                </div>
		                    </div>
		                    <p class="text-sm mb-1">저도 주차 때문에 고생했는데 공감합니다 ㅠㅠ 대중교통이 답이에요.</p>
		                </div>
		            </div>
		        </div>
		    </li>
		    `;
		}
		
		let reviewArea = $(".review-list");
		reviewArea.empty();
		reviewArea.append(reviewTag);
    
	}
	
	
	// 관람후기 함수 끝
    
	function loadTab(info) {
		
		if(info == "review"){
			$.ajax({
				url:"/detail/review?work_id=" + work.work_id,
				method:"GET",
				success:function(result){
					console.log("관람후기 클릭됨!");
					reviewList = result;
					console.log(reviewList);
					displayReviewList(1);
				}
			});
		}
	}
	
    $(()=>{
    	currentDate = new Date();
    	minDate = new Date();
    	maxDate = new Date(work.work_end_date);
    	
    	if(minDate > maxDate){
    		alert("종료된 공연입니다.\n메인 페이지로 이동합니다.");
    		location.href="/";
    	}
    	
    	setTitle();
    	displayCalendar(currentDate.getFullYear(), currentDate.getMonth());
    	updateDisabledButton();
    	
    	$(".btn-left").click(()=>{
    		prev();
    	});
    	
    	$(".btn-right").click(()=>{
    		next();
    	});
    	
        // 캐스팅 더보기
        $("#btnMoreCasting").click(function() {
            $("#castingList").toggleClass("expanded");
            let isExpanded = $("#castingList").hasClass("expanded");
            $(this).html(isExpanded ? '캐스팅 접기 <i class="fas fa-chevron-up"></i>' : '캐스팅 더보기 <i class="fas fa-chevron-down"></i>');
        });
        
        // 클래스 disabled를 갖지 않은 calendar-day
    	$(document).on("click", ".calendar-day:not(.disabled)", function() {
    		
    		$(".calendar-day").removeClass("active");
    		$(this).addClass("active");
    		
    		let selectedDate = $(this).data("date");
    		displayRoundList(selectedDate);
    	});
        

        // [관람후기] 별점 작성 UI
        $(document).on('click', '.star-rating-input i', function() {
            let rating = $(this).data('value');
            
            // 별 아이콘 초기화 (빈 별)
            $(this).parent().children('i').removeClass('fas').addClass('far');
            
            // 클릭한 별까지 채우기 (꽉 찬 별)
            $(this).parent().children('i').each(function(index) {
                if (index < rating) {
                    $(this).removeClass('far').addClass('fas');
                }
            });
            
            // 점수 텍스트 업데이트 (별 하나당 2점으로 계산 예시)
            $("#selected-rating").text(rating * 2);
        });
    })
	
	
    
    // 예매 팝업창 열기
    function openReservation() {
        // 현재 보고 있는 공연의 ID (서버에서 넘겨준 work 객체 활용)
        let workId = <%=work.getWork_id()%>;
        let url = "reservation?work_id=" + workId;
        let specs = "width=900,height=700,top=100,left=200,scrollbars=yes";
        open(url, "reservationPopup", specs);
    }
    
</script>
<div class="wrapper">
    <div class="content-wrapper">
        <div class="container pt-5">
            <div class="row">
                <div class="col-lg-8">
                    
                    <div class="mb-4 pb-3 border-bottom">
                        <h1 class="font-weight-bold mb-2" style="font-size: 32px;"><%=work.getWork_title() %></h1>
                        <div class="d-flex align-items-center">
                            <span class="badge badge-warning text-white mr-2 px-2 py-1" style="font-size: 14px;"><%=work.getGenre().getGenre_name() %> 1위</span>
                            <span class="text-warning mr-1"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></span>
                            <span class="font-weight-bold text-dark" style="font-size: 18px;">9.8</span>
                            <span class="text-muted ml-2 text-sm">(리뷰 1,240개)</span>
                        </div>
                    </div>

                    <div class="row mb-5">
                        
                        <div class="col-md-4">
                            <img src="/photo/work/p<%=work.getWork_id() %>/<%=work.getWork_poster_url() %>" class="img-fluid rounded shadow" style="width: 100%;">
                            
                            <div class="btn-like-wrapper">
                                <button class="btn btn-like" onclick="toggleLike(this)">
                                    <i class="far fa-heart mr-1"></i> <span id="likeCount"><%=work.getWork_like_count() %></span>
                                </button>
                            </div>
                        </div>

                        <div class="col-md-8 pl-md-5">
                            <ul class="list-unstyled info-list mt-1"> 
                                <li>
                                    <span class="info-label">장소</span>
                                    <span class="info-content d-inline-flex align-items-center place">
                                        <span>블루스퀘어 </span>
                                        <button class="btn btn-xs btn-outline-secondary ml-2 rounded-circle" data-id="" onclick="openPlacePopup(this)" title="지도 보기" data-toggle="modal" data-target="#placeModal"><i class="fas fa-map-marker-alt"></i></button>
                                    </span>
                                </li>
                                <li>
                                    <span class="info-label">공연기간</span>
                                    <span class="info-content"><%=work.getWork_start_date() %> ~ <%=work.getWork_end_date() %></span>
                                </li>
                                <li>
                                    <span class="info-label">공연시간</span>
                                    <span class="info-content"><%=work.getRunning_time() %>분 (인터미션 20분)</span>
                                </li>
                                <li>
                                    <span class="info-label">관람연령</span>
                                    <span class="info-content"><%=work.getAge_limit() %>세 이상 관람가</span>
                                </li>
                                <li>
                                    <span class="info-label">가격</span>
                                    <span class="info-content">
                                        VIP석 <span class="price-emphasis">170,000</span>원 <br>
                                        R석 <span class="price-emphasis">140,000</span>원 <br>
                                        S석 <span class="price-emphasis">110,000</span>원 <br>
                                        A석 <span class="price-emphasis">80,000</span>원
                                    </span>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="card card-primary card-outline card-outline-tabs border-0 mt-5">
                        <div class="card-header p-0 border-bottom-0">
                            <ul class="nav nav-tabs custom-tabs" id="custom-tabs-four-tab" role="tablist">
                                <li class="nav-item">
                                    <a class="nav-link active" id="tab-info" data-toggle="pill" href="#content-info" role="tab" onclick="loadTab('work')">공연정보</a>
                                </li>
						<!--<li class="nav-item">
                                    <a class="nav-link" id="tab-casting" data-toggle="pill" href="#content-casting" role="tab" onclick="loadTab('casting')">캐스팅정보</a>
                                </li> -->
                                <li class="nav-item">
                                    <a class="nav-link" id="tab-sales" data-toggle="pill" href="#content-sales" role="tab" onclick="loadTab('sales')">판매정보</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="tab-review" data-toggle="pill" href="#content-review" role="tab" onclick="loadTab('review')">관람후기</a>
                                </li>
                            </ul>
                        </div>
                        <div class="card-body p-0">
                            <div class="tab-content">
                            
                            	<!-- 공연정보 -->
                                <div class="tab-pane fade show active" id="content-info">
								<%if(showCasting) { %>
                                    <div class="p-4 bg-light mb-4">
                                        <h5 class="font-weight-bold mb-3">캐스팅</h5>
                                        <div class="casting-container" id="castingList">
                                        <%for(RoundCasting roundCasting : uniqueCastingList) { %>
                                            <div class="cast-member"><img src="/photo/person/p<%=roundCasting.getPerson().getPerson_id() %>/<%=roundCasting.getPerson().getProfile_url() %>" class="cast-img"><div class="font-weight-bold text-sm"><%=roundCasting.getRole() %></div><div class="text-muted text-xs"><%=roundCasting.getPerson().getPerson_name() %></div></div>
										<%} %>
                                        </div>
                                        <div class="text-center mt-2">
                                            <button type="button" class="btn btn-sm btn-outline-secondary" id="btnMoreCasting" style="width: 200px; border-radius: 20px;">
                                                캐스팅 더보기 <i class="fas fa-chevron-down"></i>
                                            </button>
                                        </div>
                                    </div>
								<%} %>

                                    <div class="text-center py-4">
                                        <h5 class="font-weight-bold mb-3 text-left pl-3">공연 상세 내용</h5>
                                        <img src="/photo/work/p<%=work.getWork_id() %>/<%=work.getWork_content_url() %>" class="img-fluid border">
                                    </div>
                                </div>
                                <!-- 공연정보 끝-->
                                
                                <!-- <div class="tab-pane fade" id="content-casting"><div id="ajax-casting-area" class="py-5 text-center"><i class="fas fa-spinner fa-spin fa-2x"></i></div></div> -->
                                <div class="tab-pane fade" id="content-sales"><div id="ajax-sales-area" class="py-5 text-center"><i class="fas fa-spinner fa-spin fa-2x"></i></div></div>
                                
                                <!-- review-->
                                <div class="tab-pane fade" id="content-review">
									<div class="review-container bg-white p-4">
									    
									    <!-- review regist -->
									    <div class="card mb-4 border-0 bg-light">
									        <div class="card-body p-3">
									            <div class="d-flex align-items-center mb-3">
									                <strong class="mr-3">별점 선택</strong>
									                <div class="star-rating-input text-warning" style="cursor: pointer;">
									                    <i class="fas fa-star" data-value="1"></i>
									                    <i class="fas fa-star" data-value="2"></i>
									                    <i class="fas fa-star" data-value="3"></i>
									                    <i class="fas fa-star" data-value="4"></i>
									                    <i class="far fa-star" data-value="5"></i>
									                </div>
									                <span class="ml-2 font-weight-bold" id="selected-rating">8</span>점
									            </div>
									            
									            <input type="text" class="form-control mb-2" placeholder="제목을 입력해주세요">
									            
									            <textarea class="form-control mb-2" rows="8" placeholder="관람 후기를 남겨주세요 (최대 500자)"></textarea>
									            <div class="text-right">
									                <button class="btn btn-primary px-4" onclick="registReview(this)">등록</button>
									            </div>
									        </div>
									    </div>
										
										<!-- review sequence -->
									    <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
									        <h5 class="font-weight-bold m-0">총 <span class="text-primary">1,240</span>개의 후기</h5>
									        <div class="btn-group btn-group-sm">
									            <button class="btn btn-outline-secondary active">최신순</button>
									            <button class="btn btn-outline-secondary">평점순</button>
									            <button class="btn btn-outline-secondary">공감순</button>
									        </div>
									    </div>
									
									    <ul class="list-unstyled review-list">
				
									        <li class="review-item border-bottom py-3">
									            <div class="d-flex justify-content-between align-items-end mb-2">
									                <div>
									                    <span class="text-warning mr-1">
									                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
									                    </span>
									                    <strong class="text-dark mr-2">musical_fan_99</strong>
									                    <span class="text-muted text-sm">2025.01.28</span>
									                    <span class="text-muted text-sm ml-2">조회 1,204</span>
									                </div>
									                <div>
									                    <button class="btn btn-xs btn-link text-danger p-0 ml-2">
									                        <i class="fas fa-exclamation-circle"></i> 신고
									                    </button>
									                </div>
									            </div>
									            
									            <div class="font-weight-bold text-dark mb-1" style="font-size: 1.1rem;">
									                기대 이상의 감동, 완벽한 무대였습니다!
									            </div>
									            
									            <div class="review-text-clamp text-dark mb-1" style="white-space: pre-wrap;">정말 오랜만에 보는 뮤지컬이었는데 기대 이상이었습니다. 
배우들의 연기력은 말할 것도 없고, 무대 장치 하나하나가 예술이더군요.
특히 1막 마지막 곡이 끝날 때의 전율은 아직도 잊혀지지가 않습니다.
음향도 블루스퀘어 다른 공연 때보다 훨씬 잡음 없이 깔끔하게 들렸습니다. 
VIP석이 아깝지 않은 공연이었어요.
다음 주에 부모님 모시고 한 번 더 보러 갈 예정입니다. 
주차는 조금 복잡하니 대중교통 이용하시는 걸 추천드립니다.
												</div>
									            
									            <button class="btn-more" onclick="toggleReviewText(this)">더보기 <i class="fas fa-chevron-down"></i></button>
									            
									            <div class="review-actions mt-1">
									                <button class="btn btn-xs btn-light border mr-1" onclick="toggleLikeReview(this)">
									                    <i class="far fa-thumbs-up"></i> <span>24</span>
									                </button>
									                <button class="btn btn-xs btn-light border" onclick="toggleReplyForm(1)">
									                    답글 달기
									                </button>
									            </div>
									
									            <div id="reply-form-1" class="reply-form-container mt-3" style="display: none;">
									                <div class="card bg-light border-0">
									                    <div class="card-body p-2 d-flex">
									                        <textarea class="form-control form-control-sm mr-2" rows="2" placeholder="답글을 입력하세요... (최대 150자)"></textarea>
									                        <button class="btn btn-sm btn-secondary" style="width: 60px;">등록</button>
									                    </div>
									                </div>
									            </div>
									
									            <div class="reply-list mt-3 pl-4 bg-light rounded p-3">
									                <div class="reply-item d-flex">
									                    <div class="mr-2 text-muted"><i class="fas fa-level-up-alt fa-rotate-90"></i></div>
									                    <div class="w-100">
									                        <div class="d-flex justify-content-between mb-1">
									                            <div>
									                                <span class="font-weight-bold text-sm">chicago00</span>
									                                <span class="text-muted text-xs ml-2">2025.01.29</span>
									                            </div>
												                <div>
												                    <button class="btn btn-xs btn-link text-muted p-0">삭제</button>
												                </div>
									                        </div>
									                        <p class="text-sm mb-1">저도 주차 때문에 고생했는데 공감합니다 ㅠㅠ 대중교통이 답이에요.</p>
									                    </div>
									                </div>
									            </div>
									        </li>
									
									        <li class="review-item border-bottom py-3">
									            <div class="d-flex justify-content-between align-items-end mb-2">
									                <div>
									                    <span class="text-warning mr-1">
									                        <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i>
									                    </span>
									                    <strong class="text-dark mr-2">ticket_master</strong>
									                    <span class="text-muted text-sm">2025.01.27</span>
									                    <span class="text-muted text-sm ml-2">조회 85</span>
									                </div>
									                <div>
									                    <!-- <button class="btn btn-xs btn-link text-muted p-0 mr-2">수정</button> -->
									                    <button class="btn btn-xs btn-link text-muted p-0">삭제</button>
									                </div>
									            </div>
									            
									            <div class="font-weight-bold text-dark mb-1" style="font-size: 1.1rem;">
									                음향이 조금 아쉬웠습니다.
									            </div>
									            
									            <div class="review-text-clamp text-dark mb-1">스토리는 좋았는데 2층 사이드 좌석이라 그런지 음향이 조금 뭉개지는 느낌을 받았습니다.</div>
									            
									            <button class="btn-more" onclick="toggleReviewText(this)">더보기 <i class="fas fa-chevron-down"></i></button>
									            
									            <div class="review-actions mt-1">
									                <button class="btn btn-xs btn-light border mr-1" onclick="toggleLikeReview(this)">
									                    <i class="far fa-thumbs-up"></i> <span>5</span>
									                </button>
									                <button class="btn btn-xs btn-light border" onclick="toggleReplyForm(2)">
									                    답글 달기
									                </button>
									            </div>
									             <div id="reply-form-2" class="reply-form-container mt-3" style="display: none;">
									                <div class="card bg-light border-0">
									                    <div class="card-body p-2 d-flex">
									                        <textarea class="form-control form-control-sm mr-2" rows="2" placeholder="답글을 입력하세요... (최대 150자)"></textarea>
									                        <button class="btn btn-sm btn-secondary" style="width: 60px;">등록</button>
									                    </div>
									                </div>
									            </div>
									        </li>
									
									    </ul>
									    
									    <ul class="pagination justify-content-center mt-4">
									        <li class="page-item disabled"><a class="page-link" href="#">이전</a></li>
									        <li class="page-item active"><a class="page-link" href="#">1</a></li>
									        <li class="page-item"><a class="page-link" href="#">2</a></li>
									        <li class="page-item"><a class="page-link" href="#">3</a></li>
									        <li class="page-item"><a class="page-link" href="#">다음</a></li>
									    </ul>
									</div>
                                </div>
                                
								<!-- review End -->
                            </div>
                        </div>
                    </div>
                </div>

				<!-- calendar -->
                <div class="col-lg-4">
                    <div class="sticky-sidebar">
                        <div class="card shadow-sm border-0" style="border-top: 4px solid #007bff;">
                            
                            <div class="card-body p-3">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <button class="btn btn-sm btn-light rounded-circle btn-left"><i class="fas fa-chevron-left"></i></button>
                                    <h5 class="m-0 font-weight-bold calendar-title"></h5>
                                    <button class="btn btn-sm btn-light rounded-circle btn-right"><i class="fas fa-chevron-right"></i></button>
                                </div>
                                <table class="calendar-table">
                                    <thead>
                                        <tr><th class="sun">일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th></tr>
                                    </thead>
                                    <tbody>
<!--                                   <tr>
                                            <td><div class="calendar-day disabled sun">28</div></td><td><div class="calendar-day disabled">29</div></td><td><div class="calendar-day disabled">30</div></td><td><div class="calendar-day disabled">31</div></td><td><div class="calendar-day">1</div></td><td><div class="calendar-day">2</div></td><td><div class="calendar-day">3</div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="calendar-day sun active">4</div></td> <td><div class="calendar-day">5</div></td><td><div class="calendar-day">6</div></td><td><div class="calendar-day">7</div></td><td><div class="calendar-day">8</div></td><td><div class="calendar-day">9</div></td><td><div class="calendar-day">10</div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="calendar-day sun">11</div></td><td><div class="calendar-day">12</div></td><td><div class="calendar-day">13</div></td><td><div class="calendar-day">14</div></td><td><div class="calendar-day">15</div></td><td><div class="calendar-day">16</div></td><td><div class="calendar-day">17</div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="calendar-day sun">18</div></td><td><div class="calendar-day">19</div></td><td><div class="calendar-day">20</div></td><td><div class="calendar-day">21</div></td><td><div class="calendar-day">22</div></td><td><div class="calendar-day">23</div></td><td><div class="calendar-day">24</div></td>
                                        </tr>
                                        <tr>
                                            <td><div class="calendar-day sun">25</div></td><td><div class="calendar-day">26</div></td><td><div class="calendar-day">27</div></td><td><div class="calendar-day">28</div></td><td><div class="calendar-day">29</div></td><td><div class="calendar-day">30</div></td><td><div class="calendar-day">31</div></td>
                                        </tr> -->
                                        
                                    </tbody>
                                </table>
                            </div>

                            <div class="dropdown-divider"></div>

                            <div class="card-body p-3">
                                <h6 class="font-weight-bold mb-2">회차 선택</h6>
                                <div class="round-select-list">
                                    <button type="button" class="btn btn-round-select active" onclick="selectRound(this, 1)">14:00</button>
                                    <button type="button" class="btn btn-round-select" onclick="selectRound(this, 2)">19:00</button>
                                </div>
                            </div>

                            <div class="card-body p-3 bg-light" id="seat-info-area">
                                <h6 class="font-weight-bold mb-2" style="font-size: 14px;">잔여석 현황</h6>
                                <div class="sidebar-compact-text">
                                    <span class="font-weight-bold">VIP</span> 12석 <span class="divider-slash">/</span> 
                                    <span class="font-weight-bold">R</span> 45석 <span class="divider-slash">/</span> 
                                    <span class="font-weight-bold">S</span> 80석 <span class="divider-slash">/</span> 
                                    <span class="font-weight-bold">A</span> 150석
                                </div>
                            </div>
						<%if(showCasting) {%>
                            <div class="card-body p-3">
                                <h6 class="font-weight-bold mb-2">캐스팅</h6>
                                <div id="daily-casting-area" class="sidebar-compact-text">
                                    홍길동, 김철수, 이영희, 박민수
                                </div>
                            </div>
						<%} %>
                            <div class="card-footer p-3">
                                <button class="btn btn-primary btn-block btn-lg font-weight-bold shadow" onclick="openReservation()">예매하기</button>
                            </div>

                        </div>
                    </div>
                </div>
                <!-- calendar End-->
                
				<!-- The PlaceModal -->
			    <div class="modal" id="placeModal">
			        <div class="modal-dialog modal-lg">
			            <div class="modal-content">
			                <!-- Modal Header -->
			                <div class="modal-header">
			                    <h5 class="modal-title">공연장 정보</h5>
			                    <button type="button" class="close" data-dismiss="modal">&times;</button>
			                </div>
			                
			                <!-- Modal body -->
			                <div class="modal-body">
			                    <div class="font-weight-bold mb-1 place_name">예술의전당</div>
			                    <div class="text-muted mb-3 address">
			                        주소: 서울특별시 서초구 서초동 700번지
			                    </div>
			                    <div id="map" style="width:100%; height:500px;"></div>
			                </div>
			        
			            </div>
			        </div>
			    </div>
			    <!-- The PlaceModal End -->
            </div>
        </div>
    </div>
</div>

</body>
</html>