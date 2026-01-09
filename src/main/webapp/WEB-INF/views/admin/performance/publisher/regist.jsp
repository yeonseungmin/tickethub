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
			let publisherList = [];
			
		    /* https://www.w3schools.com/jquery/traversing_each.asp JQuery transvering*/
		    $(".form-group").each(function (index){
		        const publisherName = $(this).find("input[name='publisher_name']").val();
		        const publisherPhone = $(this).find("input[name='publisher_phone']").val();
				
		        if(!publisherName || !publisherPhone){
		        	return;
		        }
				
		        publisherList.push({
		        	publisher_name: publisherName,
		        	publisher_phone: publisherPhone,
		        })
		        
		    });
			if(publisherList.length == 0) {
				alert("누락된 입력!");
				return;
			}
			console.log(publisherList);

 			$.ajax({
				url: "/admin/performance/publisher/regist",
				method: "POST",
				contentType: "application/json",
				data: JSON.stringify(publisherList),

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
					<div class="col-md-5">
						<input type="text" class="form-control" name="publisher_name" placeholder="주최/기획">
					</div>
					<div class="col-md-6">
						<div class="input-group">
					    	<div class="input-group-prepend">
					      		<span class="input-group-text"><i class="fas fa-phone"></i></span>
					    	</div>
					    	<input type="text" class="form-control" name="publisher_phone" placeholder="전화번호">
						</div>
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
			<div class="col-md-8">
	            <div class="card card-info">
	              <div class="card-header">
	                <h3 class="card-title">주최/기획 다중 등록</h3>
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