<%@page import="com.ch.tickethub.util.PagingUtil"%>
<%@page import="com.ch.tickethub.dto.ReportCategory"%>
<%@page import="com.ch.tickethub.dto.Report"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 1. 데이터 가져오기
	List<Report> reportList = (List)request.getAttribute("reportList");
	List<ReportCategory> reportCategoryList = (List)request.getAttribute("reportCategoryList");

	// 2. 페이징 처리
	PagingUtil paging = new PagingUtil();
	paging.setPageSize(10); 
	paging.init(reportList, request);
	
	int curPos = paging.getCurPos();
	int num = paging.getNum();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
	.topnav{ background-color: #333; height: 60px; }
	
	/* 테이블 스타일 */
	.table th, .table td {
		vertical-align: middle;
	}
	
	/* 모달 내 텍스트 박스 스타일 */
	.info-box {
		background-color: #f8f9fa;
		border: 1px solid #e9ecef;
		padding: 15px;
		border-radius: 5px;
		min-height: 100px;
		line-height: 1.6;
	}
	
	/* 리뷰 타이틀 박스 */
	.review-title-box {
		font-size: 1.2em;
		font-weight: bold;
		margin-bottom: 15px;
		display: flex;
		justify-content: space-between;
		align-items: center;
	}
</style>
</head>
<body>
<div class="topnav"></div>
<div style="padding-left:16px; padding-top:50px;"></div>

<div class="container" style="max-width: 1000px;">
	<h3 class="my-4 font-weight-bold">신고 내역 관리</h3>

	<table class="table table-hover border bg-white">
		<thead class="thead-light">
			<tr class="text-center">
				<th style="width: 80px;">번호</th>
				<th style="width: 150px;">신고대상(ID)</th>
				<th>신고 사유</th>
				<th style="width: 110px;">리뷰</th>
				<th style="width: 110px;">처리</th>
			</tr>
		</thead>
		<tbody>
			<% if(reportList == null || reportList.size() == 0) { %>
				<tr><td colspan="5" class="text-center py-5">접수된 신고 내역이 없습니다.</td></tr>
			<% } else { 
				for(int i=0; i < paging.getPageSize() && (curPos + i) < reportList.size(); i++) {
					Report report = reportList.get(curPos + i);
					
					// 데이터 정제
					String rvTitle = report.getReview().getReview_title().replace("\"", "&quot;");
					String rvContent = report.getReview().getReview_content().replace("\"", "&quot;").replace("\r\n", "<br>").replace("\n", "<br>");
					String rContent = report.getReport_content().replace("\"", "&quot;").replace("\r\n", " ");
			%>
				<tr class="text-center">
					<td><%=num-- %></td>
					
					<td><%=report.getReview().getMember().getLoginId() %></td>
					
					<td><span class="badge badge-warning p-2"><%=report.getReportCategory().getReport_reason() %></span></td>
					
					<td>
						<button class="btn btn-sm btn-info text-white btn-view-review" 
								data-title="<%=rvTitle%>"
								data-rating="<%=report.getReview().getRating()%>"
								data-content="<%=rvContent%>">
							<i class="fas fa-search"></i> 조회
						</button>
					</td>
					
					<td>
						<button class="btn btn-sm btn-danger btn-process-report" 
								data-report-id="<%=report.getReport_id()%>"
								data-review-id="<%=report.getReview().getReview_id()%>"
								data-category-id="<%=report.getReportCategory().getReport_category_id()%>"
								data-content="<%=rContent%>">
							<i class="fas fa-gavel"></i> 관리
						</button>
					</td>
				</tr>
			<% 	} 
			   } %>
		</tbody>
	</table>

	<nav aria-label="Page navigation">
	  <ul class="pagination justify-content-center">
	    <% if(paging.getFirstPage() > 1) { %>
	    	<li class="page-item"><a class="page-link" href="#" onclick="loadReportPage(<%=paging.getFirstPage()-1%>)">이전</a></li>
	    <% } %>
	    <% for(int i=paging.getFirstPage(); i<=paging.getLastPage() && i<=paging.getTotalPage(); i++) { %>
	    	<li class="page-item <%= (i == paging.getCurrentPage()) ? "active" : "" %>">
	    		<a class="page-link" href="#" onclick="loadReportPage(<%=i%>)"><%=i %></a>
	    	</li>
	    <% } %>
	    <% if(paging.getLastPage() < paging.getTotalPage()) { %>
	    	<li class="page-item"><a class="page-link" href="#" onclick="loadReportPage(<%=paging.getLastPage()+1%>)">다음</a></li>
	    <% } %>
	  </ul>
	</nav>
</div>

<div class="modal fade" id="reviewDetailModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title font-weight-bold">리뷰 원문 확인</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
            	<div class="review-title-box">
                	<span id="modal_review_title"></span>
                	<span class="text-warning" id="modal_review_rating"></span>
                </div>
                <div class="info-box bg-white" id="modal_review_content"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="reportProcessModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title font-weight-bold">신고 처리 관리</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="proc_report_id">
                <input type="hidden" id="proc_review_id">
                
                <h6 class="font-weight-bold small">신고 카테고리</h6>
                <div class="mb-3">
	                <% for(ReportCategory rc : reportCategoryList) { %>
	                    <div class="custom-control custom-control-inline custom-radio">
	                        <input type="radio" id="proc_opt<%=rc.getReport_category_id() %>" name="proc_report_category_id" 
	                        	   class="custom-control-input" value="<%=rc.getReport_category_id()%>" disabled>
	                        <label class="custom-control-label" for="proc_opt<%=rc.getReport_category_id()%>"><%=rc.getReport_reason() %></label>
	                    </div>
	                <% } %>
                </div>
                
                <h6 class="font-weight-bold small">신고 상세 내용</h6>
                <div class="info-box" id="proc_report_content"></div>
                
                <div class="alert alert-warning mt-3 mb-0 p-2 small">
                	<i class="fas fa-exclamation-triangle"></i> <strong>주의:</strong> 수락 시 리뷰는 즉시 블라인드 처리됩니다.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="handleReport('REJECTED')">반려 (유지)</button>
                <button type="button" class="btn btn-danger" onclick="handleReport('PROCESSED')">수락 (삭제)</button>
            </div>
        </div>
    </div>
</div>

<script>
// [버튼 클릭 이벤트 바인딩]
$(document).ready(function() {
	
	// 1. 리뷰 보기 버튼
	$(".btn-view-review").click(function() {
		var title = $(this).data("title");
		var rating = $(this).data("rating");
		var content = $(this).data("content");
		
		$("#modal_review_title").text(title);
		$("#modal_review_rating").html('<i class="fas fa-star"></i> ' + rating);
		$("#modal_review_content").html(content);
		
		$("#reviewDetailModal").modal("show");
	});

	// 2. 신고 관리 버튼
	$(".btn-process-report").click(function() {
		var reportId = $(this).data("report-id");
		var reviewId = $(this).data("review-id");
		var categoryId = $(this).data("category-id");
		var content = $(this).data("content");
		
		$("#proc_report_id").val(reportId);
		$("#proc_review_id").val(reviewId);
		
		$("input:radio[name='proc_report_category_id'][value='"+categoryId+"']").prop("checked", true);
		$("#proc_report_content").text(content);
		
		$("#reportProcessModal").modal("show");
	});
});

// [AJAX 처리]
function handleReport(newState) {
	const reportId = $("#proc_report_id").val();
	const reviewId = $("#proc_review_id").val();
	
	const msg = (newState == "PROCESSED") ? "신고를 수락하고 리뷰를 삭제하시겠습니까?" : "신고를 반려하시겠습니까?";
	
	if(!confirm(msg)) return;

	$.ajax({
		url: "/admin/performance/report/update",
		method: "POST",
		data: { 
			report_id: reportId,
			"review.review_id": reviewId,
			report_state: newState 
		},
		success: function(res) {
			alert("처리가 완료되었습니다.");
			$("#reportProcessModal").modal("hide");
			$($(".performance .nav-item")[5]).click();
		},
		error: function() {
			alert("처리 중 오류가 발생했습니다.");
		}
	});
}

// [페이징]
function loadReportPage(page) {
	$.ajax({
		url: "/admin/performance/report",
		method: "GET",
		data: { currentPage: page },
		success: function(result) {
			$(".content-wrapper").html(result);
		}
	});
}
</script>
</body>
</html>