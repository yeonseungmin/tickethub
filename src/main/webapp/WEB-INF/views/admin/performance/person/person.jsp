<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
<%@ include file="../inc/header.css" %>

</style>
</head>
<body>

<div class="topnav">
  <a class="nav-link registform" href="#home">인물 등록</a>
  <a class="nav-link list" href="#news">인물 목록</a>
  <a class="nav-link delete" href="#home">인물 삭제</a>
  <a class="nav-link update" href="#home">인물 수정</a>
</div>

<div style="padding-left:16px"></div>

<%@ include file="../inc/content.jsp" %>


<script>
	function loadRegist(){
		$.ajax({
			url:"/admin/performance/person/registform",
			method:"GET",
			
			success:function(result, status, xhr){
				$(".content").html(result);
				console.log("loadRegist");
			},
			error:function(xhr, status, err){
				
			}
		});
	}
	function loadList(){
		$.ajax({
			url:"/admin/performance/person/listpage",
			method:"GET",
			
			success:function(result, status, xhr){
				$(".content").html(result);
				console.log("loadList");
			},
			error:function(xhr, status, err){
				
			}
		});
	}
	function loadDelete(){
		console.log("loadDelete");
	}
	function loadUpdate(){
		console.log("loadUpdate");
	}
	
	
	$(()=>{
		// 화살표 함수의 this는 외부의 this 내부 this를 사용하려면 일반함수를 사용해야 한다.
		$(".nav-link").click(function(e){
			e.preventDefault();
			
			$(".nav-link").removeClass("active");
		    $(this).addClass("active");
			
		    
		    if($(this).hasClass("registform")){
		    	loadRegist();
		    } else if($(this).hasClass("list")){
		    	loadList();
		    } else if($(this).hasClass("delete")){
		    	loadDelete();
		    } else if($(this).hasClass("update")){
		    	loadUpdate();
		    }
		})
	});
</script>

</body>
</html>
