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
	
		// 이 함수는 상위, 하위를 모두 처리해야 하므로, 호출 시 상위를 원하는지, 하위를 원하는지 구분해줘야 한다.
		function printCategory(title, category, list){
			let tag = "<option value=''>"+title+"</option>";
			for(let i = 0; i < list.length; i++){
				if(category=="genre.genre_id"){
					tag += "<option value='"+list[i].genre_id+"'>"+list[i].genre_name+"</option>"	// 기존 <option> 태그에 누적
				}else if(category=="publisher.publisher_id"){
					tag += "<option value='"+list[i].publisher_id+"'>"+list[i].publisher_name+"</option>"	// 기존 <option> 태그에 누적
				}
			}
			$("select[name='"+category+"']").html(tag);
		}
		
		function registForm(){
		    let formData = new FormData(document.getElementById("form"));
		    
		    // 입력 걸러 내기
			for(let[key, value] of formData.entries()){
				// "" 도 falsy 러닝타임 0분도 선 넘었지
				if(!value || (value instanceof File && value.size === 0) || (key=="running_time" && value=='0')) {
					alert(key + " 누락된 입력!");
					return false;
				} /* else{
					console.log(key + " value = " + value);
				} */
			}
			// 강사님처럼 select name을 genre publisher로 지으면 헷갈려 한다. 애초에 name = publisher.publisher_id로 짓는 게 맞다.
		    // formData.append("genre.genre_id", ...); 
		    // formData.append("publisher.publisher_id", ...);
		    
			$.ajax({
				url: "/admin/performance/work/regist",
				method: "POST",
				data: formData,
				processData: false,
				contentType: false,
				success:function(result, status, xhr){
					alert(result.message); 
				},
				error:function(xhr, status, err){
					let obj = JSON.parse(xhr.responseText);
					alert(obj.message);
				}
			})
		}
		function previewImage(file, row) {
		    const reader = new FileReader();
		    
			// 기존 이미지 있으면 제거 자손 중에서 찾는 method인 find()
	        row.find("img").remove();
			
	        const previewContainer = row.find(".preview-box");
	        if(!file) return;
	        
		    reader.onload = function (e) {
	
		        const img = $("<img>")
		            .attr("src", e.target.result)
		            .css({
		                width: "60px",
		                height: "60px",
		            });
	
		        previewContainer.append(img);
		    };
	
		    reader.readAsDataURL(file);
		}
		
		function getGenre(){
			$.ajax({
				url:"/admin/performance/genre/list",
				method:"GET",
				
				success:function(result, status, xhr){
					printCategory("장르 선택", "genre.genre_id", result);
					console.log(result);
				},
				error:function(xhr, status, err){
					
				}
			});
		}
		
		function getPublisher(){
			$.ajax({
				url:"/admin/performance/publisher/list",
				method:"GET",
				
				success:function(result, status, xhr){
					// select2는 placeholder를 쓴다. title은 ""
					printCategory("", "publisher.publisher_id", result);
					
				    // Select2 초기화
				    $('.select2').select2({
				        theme: 'bootstrap4',
				        placeholder: "주최/기획 검색",
				        allowClear: true,
				        width: '100%'	// 이걸 넣지 않으면 크기가 유동적이지 않음
				    });
				    
					console.log(result);
				},
				error:function(xhr, status, err){
					
				}
			});
		}		

		$(()=>{
			/* https://www.w3schools.com/jquery/event_on.asp */
			$(".card-body").on("change", "input[type=file]", function(e){
				//console.log("this ", this);
				//console.log("this.files", this.files);
				//console.log("e.target.files", e.target.files);
				
				let file = this.files[0];
				
				// 가장 가까운 위치의 dom 선택
				previewImage(file, $(this).closest(".form-group"));
			});
		
			$(function () {

			});
			
			getGenre();
			getPublisher();
			
			
			$("#regist").click(()=>{
				registForm();
			});
			
			// 한국어 로케일 설정 (moment.js가 로드되어 있어야 함)
		    moment.locale('ko');

		    $("#ticket_start_date").datetimepicker({
		        icons: { time: 'far fa-clock' },
		        format: 'YYYY-MM-DD HH:mm',
		        locale: 'ko',
		        dayViewHeaderFormat: 'YYYY년 MMMM',	// 년 월 순서로
		        ignoreReadonly: true
		    });
			
		 	// 시작일 초기화
		    $("#work_start_date").datetimepicker({
		        format: 'YYYY-MM-DD',
		        locale: 'ko',
		        dayViewHeaderFormat: 'YYYY년 MMMM'
		    });

		    // 종료일 초기화
		    $("#work_end_date").datetimepicker({
		        format: 'YYYY-MM-DD',
		        locale: 'ko',
		        dayViewHeaderFormat: 'YYYY년 MMMM',
		        useCurrent: false // 시작일 선택 전까지 자동 선택 방지
		    });

		    $("#ticket_start_date").on("change.datetimepicker", function (e) {
		        $("#work_start_date").datetimepicker('minDate', e.date);
		    });

		    // 시작일이 바뀌면 종료일의 선택 가능 범위를 제한
		    $("#work_start_date").on("change.datetimepicker", function (e) {
		        $("#work_end_date").datetimepicker('minDate', e.date);
		        $("#ticket_start_date").datetimepicker('maxDate', e.date);
		    });

		    // 종료일이 바뀌면 시작일의 선택 가능 범위를 제한
		    $("#work_end_date").on("change.datetimepicker", function (e) {
		        $("#work_start_date").datetimepicker('maxDate', e.date);
		    });
		})
	</script>
	<div class="container-fluid mt-5">
		<div class="row justify-content-center">
			<div class="col-md-8">
	            <div class="card card-info">
	              <div class="card-header">
	                <h3 class="card-title">작품 등록</h3>
	              </div>
					<form id="form">
						<div class="card-body">
							<div class="form-group row">
								<div class="col-md-4">
									<input type="text" class="form-control" name="work_title"  placeholder="제목 입력">
								</div>
								<div class="col-md-2">
									<input type="text" class="form-control" name="director"  placeholder="감독">
								</div>
								<div class="col-md-2">
									<input type="number" class="form-control" name="age_limit"  placeholder="연령제한">
								</div>
								<div class="col-md-2">
									<input type="number" class="form-control" name="work_price"  placeholder="가격">
								</div>
								<div class="col-md-2">
									<input type="number" class="form-control" name="running_time"  placeholder="러닝타임(단위:분)">
								</div>
							</div>
						
							<div class="form-group row">
								<div class="col-md-4">
									<select class="form-control" name="genre.genre_id"></select>
							    </div>	
								<div class="col-md-6">
									<select class="form-control select2 select2-info" name="publisher.publisher_id"></select>
							    </div>
								<div class="col-md-2">
									<select class="form-control" name="work_type">
										<option value="round">회차</option>
										<option value="period">상시</option>
									</select>
							    </div>
							</div>
							<div class="form-group row align-items-center">
								<div class="col-md-10">
									<div class="custom-file">
										<input type="file" class="custom-file-input" name="work_poster_img">
										<label class="custom-file-label">작품 포스터 선택</label>
									</div>
								</div>
								<div class="col-md-2 text-center preview-box">
				                </div>
							</div>
							<div class="form-group row align-items-center">
								<div class="col-md-10">
									<div class="custom-file">
										<input type="file" class="custom-file-input" name="work_content_img">
										<label class="custom-file-label">작품 내용 선택</label>
									</div>
								</div>
								<div class="col-md-2 text-center preview-box">
				                </div>
							</div>
							<div class="form-group row">
								<div class="col-md-4">
									<label>티켓 예매 시간:</label>
									<div class="input-group date" id="ticket_start_date" data-target-input="nearest">
										<input type="text" class="form-control datetimepicker-input" data-target="#ticket_start_date" name=ticket_start_date>
										<div class="input-group-append" data-target="#ticket_start_date" data-toggle="datetimepicker">
											<div class="input-group-text"><i class="far fa-clock"></i></div>
										</div>
									</div>
                  				</div>
								<div class="col-md-4">
							        <label>공연 시작일:</label>
							        <div class="input-group date" id="work_start_date" data-target-input="nearest">
							            <input type="text" class="form-control datetimepicker-input" data-target="#work_start_date" name="work_start_date" />
							            <div class="input-group-append" data-target="#work_start_date" data-toggle="datetimepicker">
							                <div class="input-group-text"><i class="fa fa-calendar"></i></div>
							            </div>
							        </div>
							    </div>
							    <div class="col-md-4">
							        <label>공연 종료일:</label>
							        <div class="input-group date" id="work_end_date" data-target-input="nearest">
							            <input type="text" class="form-control datetimepicker-input" data-target="#work_end_date" name="work_end_date" />
							            <div class="input-group-append" data-target="#work_end_date" data-toggle="datetimepicker">
							                <div class="input-group-text"><i class="fa fa-calendar"></i></div>
							            </div>
							        </div>
							    </div>
							</div>
						</div>
						<div class="card-footer text-center">
							<button type="button" id="regist" class="btn btn-success">등록</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>