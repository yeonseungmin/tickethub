<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<div class="content-header">
	    <div class="container-fluid">
	        <!-- <h4 class="m-0">메인페이지 관리</h4> -->
	    </div>
	</div>
	<section class="content">
	    <div class="container-fluid">
	        <div class="card card-primary">
	            <div class="card-header"><h3 class="card-title">배너 등록</h3></div>
	            <form id="regis-form">
	                <div class="card-body">
	                    <div class="form-group">
	                        <label>메인 배너에 등록할 공연을 선택하세요</label>
	                        <select class="form-control select2" name="work_id" id="work_list">
	                            <option value="">데이터를 불러오는 중...</option>
	                        </select>
	                    </div>
	                    <div class="form-group">
	                        <label>배너 이미지 선택(1920x600 권장)</label>
	                        <input type="file" class="form-control" name="main_img">
	                    </div>
	                </div>
	                <div class="card-footer text-center">
	                    <button type="button" class="btn btn-success" id="btn-save">등록</button>
	                </div>
	            </form>
	        </div>
	    </div>
	</section>
	
	<script>
		$(function() {
		    // index.jsp가 켜져있는 상태에서 내용만 바뀌는 것이므로, 필요한 AJAX 호출(공연 목록 불러오기 등)을 바로 작성
		    $.ajax({
		        url: "/admin/performance/work/list", // WorkController.java 83번 줄에 이미 구현되어 있음
		        method: "GET",
		        success: function(res) {
		            let options = "";
		            res.forEach(w => options += "<option value='"+w.work_id+"'>"+w.work_title+"</option>");
		            $("#work_list").html(options);
		        }
		    });
		    $("#btn-save").click(function() {
		        alert("DB 컬럼에 맞게 AJAX 전송 로직 작성");
		    });
		});
	</script>

</body>
</html>