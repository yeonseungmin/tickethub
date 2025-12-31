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
		//let workList;
		let workMap = {};
		let currentWork;
		let roundIdx = 0;
		
	
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
			
			roundTimeForms.each(function(){
				roundTimes.push($(this).val());
			});
			
			if(roundTimes.length == 0){
				alert("round_start_time 0개");
				return false;
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
/* 			let roundList = [];
			let roundTimes = [];
			
		    const workId = $("select[name='work.work_id']").val();
		    const placeId = $("select[name='place.place_id']").val();
		    const roundDate = $("#round_date input").val();
		    
		    roundList.push({
		    	"work.work_id": workId,
		    	"place.place_id": placeId,
		    	round_date: roundDate
		    });
		    
		    console.log(roundList);
		    
		    console.log(JSON.stringify(roundList));
		     */
		    
		    
		    let formData = new FormData(document.getElementById("form"));
		    
		    // 입력 걸러 내기
			for(let[key, value] of formData.entries()){
				if(!value) {
					alert(key + " 누락된 입력!");
					return false;
				} else{
					console.log(key + " value = " + value);
				}
			}
		    
		    if(!validateRoundTimes()){
		    	return false;	
		    }
		    
		    // send로 보내는 건 동기 방식이므로 formData든 json이든 둘 중 하나를 써야 한다.
			$.ajax({
				url: "/admin/performance/round/regist",
				method: "POST",
				processData: false,
				contentType: false,
				data: formData,
				success:function(result, status, xhr){
					alert(result.message); 
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
				    
					console.log(result);
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
					
					// workList = result
					
				    // Select2 초기화
				    $("select[name='place.place_id']").select2({
				        theme: 'bootstrap4',
				        placeholder: "장소 검색",
				        allowClear: true,
				        width: '100%'	// 이걸 넣지 않으면 크기가 유동적이지 않음
				    });
				    
					console.log(result);
				},
				error:function(xhr, status, err){
					
				}
			});
		}

		function add() {
		    roundIdx++; // 새로운 회차를 위한 번호 증가
		    
		    let row = `
		        <div class="form-group row">
		            <div class="col-md-11">
		                <label>회차 시작 시간</label>
		                <div class="input-group date" id="round_start_time_` + roundIdx + `" data-target-input="nearest">
		                    <input type="text" class="form-control datetimepicker-input" 
		                           data-target="#round_start_time_` + roundIdx + `" name="round_start_time" />
		                    <div class="input-group-append" data-target="#round_start_time_` + roundIdx + `" data-toggle="datetimepicker">
		                        <div class="input-group-text"><i class="far fa-clock"></i></div>
		                    </div>
		                </div>
		            </div>
		            <div class="col-md-1">
		                <button type="button" class="btn btn-outline-danger remove" style="margin-top: 32px;">X</button>
		            </div>
		        </div>
		    `;

		    $(".card-body").append(row);
		    
		    $("#round_start_time_" + roundIdx).datetimepicker({
		        icons: { time: 'far fa-clock' },
		        format: 'HH:mm',
		        locale: 'ko',
		        ignoreReadonly: true
		    });
		}

		$(()=>{

			getWork();
			getPlace();
			
			$("#append").click(()=>{
				add();
				

			})

			$(".card-body").on("click", ".remove", function(){
				$(this).closest(".form-group").remove();
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
			    console.log(currentWork);
			    
			    $("#round_date").datetimepicker('minDate', currentWork.work_start_date);
			    $("#round_date").datetimepicker('maxDate', currentWork.work_end_date);
			});
			
			
			// 한국어 로케일 설정 (moment.js가 로드되어 있어야 함)
		    moment.locale('ko');
			
			$("#round_date").datetimepicker({
				format: 'YYYY-MM-DD',
				locale: 'ko',
				dayViewHeaderFormat: 'YYYY년 MMMM'
			})
			

		})
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