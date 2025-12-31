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
		function registForm(){
		    let formData = new FormData();
			
		    /* https://www.w3schools.com/jquery/traversing_each.asp JQuery transvering*/
		    $(".form-group").each(function (){
		        const name = $(this).find("input[name='person_name']").val();
		        const fileInput = $(this).find("input[type='file']")[0];
		        /*https://www.w3schools.com/jsref/dom_obj_fileupload.asp*/
		        const file = fileInput.files[0];
	
		        if(!name || !file){
		        	return;
		        }
				
		        formData.append("person_name", name);
	
		        formData.append("profile_img", file);
		        
		        /*
		        	{
					    "person_name": ["강동훈1", "강동훈2"],
					    "profile_img": [File객체1, File객체2]
					}
		        */
		    });
			
			console.log(formData);
			$.ajax({
				url: "/admin/performance/person/regist",
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
		function add(){
			let row = `
				<div class="form-group row align-items-center">
					<div class="col-md-2">
						<input type="text" name="person_name" class="form-control" placeholder="이름 입력">
					</div>
					<div class="custom-file col-md-7">
						<input type="file" class="custom-file-input" name="profile_img" placeholder="프로필 입력">
						<label class="custom-file-label">프로필 이미지 선택</label>
					</div>
					<div class="col-md-2 text-center preview-box">
	                </div>
					<div class="col-md-1">
						<button type="button" class = "btn btn-danger remove">X</button>
					</div>
				</div>
			`;
			$(".card-body").append(row);
		}
	
		$(()=>{
			$("#append").click(()=>{
				add();
			})
			/* https://www.w3schools.com/jquery/event_on.asp */
			$(".card-body").on("change", "input[type=file]", function(e){
				//console.log("this ", this);
				//console.log("this.files", this.files);
				//console.log("e.target.files", e.target.files);
				
				let file = this.files[0];
				

				// 가장 가까운 위치의 dom 선택
				previewImage(file, $(this).closest(".form-group"));
			})
			
			$(".card-body").on("click", ".remove", function(){
				$(this).closest(".form-group").remove();
			})
			
			$("#regist").click(()=>{
				registForm();
			});
		})
	</script>
	<div class="container-fluid mt-5">
		<div class="row justify-content-center">
			<div class="col-md-8">
	            <div class="card card-info">
	              <div class="card-header">
	                <h3 class="card-title">인물 다중 등록</h3>
	              </div>
					<form id="form">
						<div class="card-body">
							
						</div>
						<div class="card-footer text-center">
							<button type="button" id="append" class="btn btn-outline-info">추가하기</button>
							<button type="button" id="regist" class="btn btn-success">등록</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>