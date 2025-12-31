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
			let placeList = [];
			
		    /* https://www.w3schools.com/jquery/traversing_each.asp JQuery transvering*/
		    $(".form-group").each(function (index){
		        const placeName = $(this).find("input[name='place_name']").val();
		        const address = $(this).find("input[name='address']").val();
		        const latitude = parseFloat($(this).find("input[name='latitude']").val());
		        const longitude = parseFloat($(this).find("input[name='longitude']").val());
				
		        // 빈 문자열은 falsy 취급
		        if(!placeName || !address || isNaN(latitude) || isNaN(longitude)){
		        	return;
		        }
				
		        placeList.push({
		        	place_name: placeName,
		        	address: address,
		        	latitude: latitude,
		        	longitude: longitude
		        })
		        
		    });
			if(placeList.length == 0) {
				alert("누락된 입력!");
				return;
			}
			console.log(placeList);

 			$.ajax({
				url: "/admin/performance/place/regist",
				method: "POST",
				contentType: "application/json",
				data: JSON.stringify(placeList),

				success:function(result, status, xhr){
					alert(result.message); 
				},
				error:function(xhr, status, err){
					let obj = JSON.parse(xhr.responseText);
					alert(obj.message);
				}
			})	    
		}
		
		function add(){
			let row = `
				<div class="form-group row align-items-center">
					<div class="col-md-2">
						<input type="text" class="form-control" name="place_name" placeholder="공연 장소 이름">
					</div>
					<div class="col-md-5">
						<input type="text" class="form-control" name="address" placeholder="주소">
					</div>
					<div class="col-md-2">
						<input type="number" class="form-control" name="latitude" placeholder="위도">
					</div>
					<div class="col-md-2">
						<input type="number" class="form-control" name="longitude" placeholder="경도">
					</div>
					<div class="col-md-1">
						<button type="button" class = "btn btn-outline-danger remove">X</button>
					</div>
				</div>
			`;
			$(".card-body").append(row);
		}
	
		$(()=>{
			$("#append").click(()=>{
				add();
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
			<div class="col-md-11">
	            <div class="card card-info">
	              <div class="card-header">
	                <h3 class="card-title">장소 다중 등록</h3>
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