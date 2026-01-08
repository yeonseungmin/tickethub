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
<script>
	let currentDate;
	// 오늘 날짜 최소가 되는 달
	let minDate;
	// work_end_date가 달력의 마지막 달
	let maxDate;
	let work = <%=jsonWork%>;
</script>
<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=<%=naverMapClientId%>"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>

<script>
    // 1. 좋아요 버튼 토글
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
     	
     	// data-id 에 값 round_id 값 넣어주기
    	$(".place button").attr("data-id", round.round_id);

		$("#seat-info-area .sidebar-compact-text").html(`
			<span class="font-weight-bold">VIP</span> <span class="text-soldout">매진</span> <span class="divider-slash">/</span> 
			<span class="font-weight-bold">R</span> 5석 <span class="divider-slash">/</span> 
			<span class="font-weight-bold">S</span> 20석 <span class="divider-slash">/</span> 
			<span class="font-weight-bold">A</span> 50석
		`);
		
    	// JS에서 문자열 비교는 localeCompare Java는 compareTo
    	const roundCastingList = round.roundCastingList.sort((a, b)=> a.role.localeCompare(b.role));
    	//console.log("roundCastingList", roundCastingList);
    	
    	let castingText = "";
    	roundCastingList.forEach((casting, index) => {
    		castingText += (index == 0) ? "" : ", ";
    		castingText += casting.person.person_name;
    	});
    	
		$("#daily-casting-area").text(castingText || "캐스팅 정보가 없습니다.");
		
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
    
    // 장소 팝업
    function openPlacePopup(btn){
    	let roundId = $(btn).data("id");
    	const round = work.roundList.find((round)=>{return round.round_id == roundId});
    	
    	if(round == null) return;
    	
    	const place = round.place;
    	
        // .one 첫 한 번만 실행 Bootstrap이 제공하는 모달이름 shown.bs.modal
        $("#placeModal").one("shown.bs.modal", function () {
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
    
    $(()=>{
    	currentDate = new Date();
    	minDate = new Date();
    	maxDate = new Date(work.work_end_date);
    	
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
                                    <a class="nav-link active" id="tab-info" data-toggle="pill" href="#content-info" role="tab" onclick="loadTab('info')">공연정보</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="tab-casting" data-toggle="pill" href="#content-casting" role="tab" onclick="loadTab('casting')">캐스팅정보</a>
                                </li>
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
                                <div class="tab-pane fade show active" id="content-info">
                                    
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

                                    <div class="text-center py-4">
                                        <h5 class="font-weight-bold mb-3 text-left pl-3">공연 상세 내용</h5>
                                        <img src="/photo/work/p<%=work.getWork_id() %>/<%=work.getWork_content_url() %>" class="img-fluid border">
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="content-casting"><div id="ajax-casting-area" class="py-5 text-center"><i class="fas fa-spinner fa-spin fa-2x"></i></div></div>
                                <div class="tab-pane fade" id="content-sales"><div id="ajax-sales-area" class="py-5 text-center"><i class="fas fa-spinner fa-spin fa-2x"></i></div></div>
                                <div class="tab-pane fade" id="content-review"><div id="ajax-review-area" class="py-5 text-center"><i class="fas fa-spinner fa-spin fa-2x"></i></div></div>
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

                            <div class="card-body p-3">
                                <h6 class="font-weight-bold mb-2">캐스팅</h6>
                                <div id="daily-casting-area" class="sidebar-compact-text">
                                    홍길동, 김철수, 이영희, 박민수
                                </div>
                            </div>

                            <div class="card-footer p-3">
                                <button class="btn btn-primary btn-block btn-lg font-weight-bold shadow" onclick="openReservation()">예매하기</button>
                            </div>

                        </div>
                    </div>
                </div>
                
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
			    
            </div>
        </div>
    </div>
</div>

</body>
</html>