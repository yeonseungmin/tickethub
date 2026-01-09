<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<script>
	// ( function() { ... } ) ( ) ; 함수 실행 트리거 마지막 (); 비동기이므로 workMap, currentWork, roundIdx가 계속 살아있다. 
	(function() {
		//let workList;
		let workMap = {};
		let currentWork;
		let roundIdx = 0;
		let personMap ={};
		let personList;
		
		/*https://select2.org/selections 선택한 옵션 이미지 넣기*/
		// 이 함수는 상위, 하위를 모두 처리해야 하므로, 호출 시 상위를 원하는지, 하위를 원하는지 구분해줘야 한다.
		function printCategory(title, category, list){
			let tag = "<option value=''>"+title+"</option>";
			for(let i = 0; i < list.length; i++){
				if(category=="work.work_id"){
					tag += "<option value='"+list[i].work_id+"'>"+list[i].work_title+"[ 러닝타임: "+list[i].running_time+"분 ]"+"</option>";
				}else if(category=="place.place_id"){
					tag += "<option value='"+list[i].place_id+"'>"+list[i].place_name+"</option>";
				}
			}
			
			$("select[name='"+category+"']").html(tag);
		}
		
		function validateRoundTimes(){
			let roundTimes = [];
			let roundTimeForms = $("input[name='round_start_time']");
			let runningTime = parseInt(currentWork.running_time);
			let roundDate = $("input[name='round_date']").val();
			let isValid = true;
			
			for (let roundTimeForm of roundTimeForms){
				let roundTime = $(roundTimeForm).val();
				
				if(roundTime == ""){
					alert("회차 시작 시간 누락됨!");
					isValid = false;
					return false;
				}
				roundTimes.push(roundTime);
			}

			
			for(let round of currentWork.roundList){
				if(round.round_date == roundDate){
					roundTimes.push(round.round_start_time);
				}
			}
			
			
			roundTimes.sort();
			
			function toMinutes(time){
				const [h, m] = time.split(":");
				
				return parseInt(h) * 60 + parseInt(m);
			}
			
			for(let i = 0; i < roundTimes.length - 1; i++){
				if(toMinutes(roundTimes[i]) + runningTime >= toMinutes(roundTimes[i+1])){
					alert(roundTimes[i] + "이 " + roundTimes[i+1] + "과 충돌합니다." );
					return false;
				} 
			}
			
			return true;
		}
		
		function registForm(){
			
			let work_id = $("select[name='work.work_id']").val();
		    let place_id = $("select[name='place.place_id']").val();
		    let round_date = $("input[name='round_date']").val();
		    
		    if (!work_id || !place_id || !round_date) {
		        alert("기본 정보를 모두 입력해주세요.");
		        return;
		    }
		    
			if($(".round_container").html() == ""){
		    	alert("시작 시간을 추가해주세요.");
		    	return;
		    }
		    
		    if(!validateRoundTimes()){
		    	return false;	
		    }
		    
		    let roundList = [];
		    let isCastingDataValid = true;
		    
		 	// jQuery에서 .each()는 return false가 break고 retrun true가 다음 회차다. 되도록 for를 쓰자.
		    $(".round-group").each(function(index) {
		    	
				let roundData = {
					round_start_time: $(this).find("input[name='round_start_time']").val(),
					castingList: []
				};
				
				let isRoleValid = true;
				$(this).find(".person_container .form-group.row").each(function() {
					let role = $(this).find("input[name='role']").val();
					
					if(role == ""){
						alert((index + 1) + "번째 회차에 역할 누락");
						isRoleValid = false;
						return false;
					}
					
					roundData.castingList.push({
						person_id: $(this).find("input[name='person_id']").val(),
						role: role
					});
				});
				
				if(!isRoleValid) {
					isCastingDataValid = false;
					return false;
				}
				
				const genre = currentWork.genre.genre_name;
				const isCastingRequired = (genre == "뮤지컬" || genre == "연극");
				
				if(isCastingRequired && roundData.castingList.length == 0){
					alert((index + 1) + "번째 회차에 배우를 선택해주세요.");
					isCastingDataValid = false;
					return false;
				}
		    	
				roundList.push(roundData);
		    })
		    
		    if(!isCastingDataValid || roundList.length == 0) {
		    	return;
		    }
		    
		    let Data = {
		    		work_id: work_id,
		    		place_id: place_id,
		    		round_date: round_date,
		    		roundList: roundList
		    };
		    
		    console.log(Data);
		    
		    
		    
		    // send로 보내는 건 동기 방식이므로 formData든 json이든 둘 중 하나를 써야 한다.
 			$.ajax({
				url: "/admin/performance/round/regist",
				method: "POST",
				processData: "POST",
				contentType: "application/json",
				data: JSON.stringify(Data),
				success:function(result, status, xhr){
					alert(result.message);
					getWork();
				},
				error:function(xhr, status, err){
					let obj = JSON.parse(xhr.responseText);
					alert(obj.message);
				}
			})
		}
		
		function getWork(){
			$.ajax({
				url:"/admin/performance/work/list",
				method:"GET",
				
				success:function(result, status, xhr){
					// select2는 placeholder를 쓴다. title은 ""
					printCategory("", "work.work_id", result);
					
					result.forEach(work=>{
						workMap[work.work_id] = work;
					});
					
				    // Select2 초기화
				    $("select[name='work.work_id']").select2({
				        theme: 'bootstrap4',
				        placeholder: "작품 검색",
				        allowClear: true,
				        width: '100%'	// 이걸 넣지 않으면 크기가 유동적이지 않음
				    });
				    
					//console.log(result);
				},
				error:function(xhr, status, err){
					
				}
			});
		}
		
		function getPlace(){
			$.ajax({
				url:"/admin/performance/place/list",
				method:"GET",
				
				success:function(result, status, xhr){
					// select2는 placeholder를 쓴다. title은 ""
					printCategory("", "place.place_id", result);
					
				    // Select2 초기화
				    $("select[name='place.place_id']").select2({
				        theme: 'bootstrap4',
				        placeholder: "장소 검색",
				        allowClear: true,
				        width: '100%'	// 이걸 넣지 않으면 크기가 유동적이지 않음
				    });
				    
					//console.log(result);
				},
				error:function(xhr, status, err){
					
				}
			});
		}
		
		function getPerson(){
			$.ajax({
				url:"/admin/performance/person/list",
				method:"GET",
				
				success:function(result, status, xhr){
					personList = result;
					
					result.forEach(person =>{
						personMap[person.person_id] = person;
					});
				    
					//console.log(personList);
				},
				error:function(xhr, status, err){
					
				}
			});
		}
		
		function add() {
		    roundIdx++; // 새로운 회차를 위한 번호 증가

		    const genre = currentWork.genre.genre_name;
		    const isCastingRequired = (genre == "뮤지컬" || genre == "연극");
		    let personTag = "<option value=''></option>";
		    
		    if (isCastingRequired && personList) {
		        for(person of personList){
		        	personTag += "<option value='" + person.person_id + "'>"+ person.person_name + "</option>";
		        }
		    }
		    
		    // round_start_time 추가
		    let row = `
		    	<div class="round-group">
		    	<hr>
		        <div class="form-group row" id="round_` + roundIdx + `">
		            <div class="col-md-5">
		                <label>회차 시작 시간:</label>
		                <div class="input-group date" id="round_start_time_` + roundIdx + `" data-target-input="nearest">
		                    <input type="text" class="form-control datetimepicker-input" 
		                           data-target="#round_start_time_` + roundIdx + `" name="round_start_time" />
		                    <div class="input-group-append" data-target="#round_start_time_` + roundIdx + `" data-toggle="datetimepicker">
		                        <div class="input-group-text"><i class="far fa-clock"></i></div>
		                    </div>
		                </div>
		            </div>`;
			
			// 연극, 뮤지컬일 경우만 배우 선택기 추가
            if(isCastingRequired){
            	row += `
				<div class="col-md-6">
                    <label>출연 배우 선택 (다중):</label>
                    <select class="form-control select2 select2-info casting_select" multiple="multiple">
					`+personTag+`
                    </select>
                </div>
                `;
            }else{
            	row += `<div class="col-md-6"></div>`;
            }
		            
            row += `
            	<div class="col-md-1">
                	<button type="button" class="btn btn-outline-danger remove" style="margin-top: 32px;">X</button>
            	</div>
        	</div>`;
        	
        	if(isCastingRequired){
        		row += `
        			<div class="person_container" id="person_container_`+ roundIdx +`"></div>
        		`;
        	}
        	
        	// round-group 닫기
        	row +=`</div>`;

		    $(".round_container").append(row);
		    
		    $("#round_start_time_" + roundIdx).datetimepicker({
		        icons: { time: 'far fa-clock' },
		        format: 'HH:mm',
		        locale: 'ko',
		        ignoreReadonly: true
		    });
		    
		    if(isCastingRequired) {
		    	let castingSelect = $("#round_" + roundIdx + " .casting_select");
		    	let personContainer = $("#person_container_" + roundIdx);
		    	
		    	castingSelect.select2({
			        theme: 'bootstrap4',
			        placeholder: "배우 검색",
			        allowClear: true,
			        width: '100%'	// 이걸 넣지 않으면 크기가 유동적이지 않음
			    });
		    	
		    	castingSelect.on("select2:select select2:unselect", function() {
		    		//select2('data') 에서 id가 option의 value이며 text가 option의 text가 된다. 
		    		let selectedData = $(this).select2('data');
		    		
		    		//console.log(selectedData);
		    		personContainer.empty();		// 일단 비우기
		    		
		    		selectedData.forEach(function(person) {
		    			// id가 없으면 출력할 필요가 없다.
		    			if(!person.id || !personMap[person.id]){
		    				return;
		    			}
		    			
		    			let src = "/photo/person/p"+ person.id + "/" + personMap[person.id].profile_url
						
						// person.id는 role과 세트로 보내져야 한다.
		    			let castingRow = `
		    				<div class="form-group row align-items-center">
		    					<div class="col-sm-2 text-center">
			                    	<img src="` + src + `" class="img-circle" style="width: 45px; height: 45px; object-fit: cover;">
			                    </div>
								<div class="col-sm-3">
									<span class="font-weight-bold">` + person.text + `</span>
									<input type="hidden" name="person_id" value="` + person.id + `">
								</div>
			                    <div class="col-sm-7">
									<input type="text" name="role" class="form-control" placeholder="배역 입력">
								</div>
		                	</div>
		    			`;
		    			
		    			personContainer.append(castingRow);
		    		})
		    	});
		    }
		}

		$(()=>{

			getWork();
			getPlace();
			getPerson();
			
			$("#append").click(()=>{
				add();
			})

			$(".card-body").on("click", ".remove", function(){
				$(this).closest(".round-group").remove();
			})
			
			
			$("#regist").click(()=>{
				registForm();
			});
			
			// 화살표 함수는 자신의 this를 갖지 않고 상위 스코프의 this를 그대로 물러 받는다.
			// 반면에 일반 함수에서의 this는 함수를 호출한 주체다.
			$("select[name='work.work_id']").change(function(e) {
				/*
				for(let work of workList){
			    	if(work.work_id == $(this).val()){
			    		currentWork = work;
			    		break;
			    	}
			    }
			    */
			    currentWork = workMap[$(this).val()];
			    //console.log(currentWork);
			    
			    $("#round_date").datetimepicker('minDate', currentWork.work_start_date);
			    $("#round_date").datetimepicker('maxDate', currentWork.work_end_date);
			    
			   	// 다른 작품 선택 시 회차는 제거.
			    $(".round_container").empty();
			    roundIdx = 0;
			});
			
			
			// 한국어 로케일 설정 (moment.js가 로드되어 있어야 함)
		    moment.locale('ko');
			
			$("#round_date").datetimepicker({
				format: 'YYYY-MM-DD',
				locale: 'ko',
				dayViewHeaderFormat: 'YYYY년 MMMM'
			})
			

		})
	})();
	</script>
	<div class="container-fluid mt-5">
		<div class="row justify-content-center">
			<div class="col-md-8">
	            <div class="card card-info">
	              <div class="card-header">
	                <h3 class="card-title">동일 날짜 회차 다중 등록</h3>
	              </div>
					<form id="form">
						<div class="card-body">
							<div class="form-group row">
								<div class="col-md-6">
									<select class="form-control select2 select2-info" name="work.work_id"></select>
							    </div>
								<div class="col-md-6">
									<select class="form-control select2 select2-info" name="place.place_id"></select>
							    </div>	
							</div>
							<div class="form-group">
								<label>공연 날짜:</label>
								<div class="input-group date" id="round_date" data-target-input="nearest">
									<input type="text" class="form-control datetimepicker-input" data-target="#round_date" name=round_date>
									<div class="input-group-append" data-target="#round_date" data-toggle="datetimepicker">
										<div class="input-group-text"><i class="fa fa-calendar"></i></div>
									</div>
								</div>
							</div>
							<div class="round_container"></div> 
						</div>
						<div class="card-footer text-center">
							<button type="button" id="append" class="btn btn-outline-info">시작시간 추가하기</button>
							<button type="button" id="regist" class="btn btn-success">등록</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>