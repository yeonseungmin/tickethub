<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>베스트 리뷰 관리</title>
    </head>

    <body>

        <div class="content-header">
            <div class="container-fluid">
                <h4 class="m-0">베스트 리뷰 관리</h4>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">

                <!-- 베스트 리뷰 목록 -->
                <div class="card card-info">
                    <div class="card-header">
                        <h3 class="card-title">현재 등록된 베스트 리뷰 목록</h3>
                    </div>
                    <div class="card-body table-responsive p-0">
                        <table class="table table-hover text-nowrap">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>리뷰 제목</th>
                                    <th>평점</th>
                                    <th>작성자</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody id="bestreview-list-body">
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 베스트 리뷰 등록 폼 -->
                <div class="card card-primary mt-4">
                    <div class="card-header">
                        <h3 class="card-title">새 베스트 리뷰 등록</h3>
                    </div>
                    <form id="regis-form">
                        <div class="card-body">
                            <div class="form-group">
                                <label>1. 공연을 먼저 선택하세요</label>
                                <select class="form-control select2" id="work_list">
                                    <option value="">공연을 선택하세요</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>2. 리뷰를 선택하세요</label>
                                <select class="form-control select2" name="review_id" id="review_list">
                                    <option value="">먼저 공연을 선택해주세요</option>
                                </select>
                            </div>
                        </div>
                        <div class="card-footer text-center">
                            <button type="button" class="btn btn-success" id="btn-save">등록하기</button>
                        </div>
                    </form>
                </div>

            </div>
        </section>
        <script>
            (function () {
                // 공연 목록 로드
                const loadWorkList = () => {
                    $.ajax({
                        url: "/admin/performance/work/list",
                        method: "GET",
                        success: (workList) => {
                            let optionTags = '<option value="">공연을 선택하세요</option>';
                            workList.forEach((work) => {
                                optionTags += `<option value="\${work.work_id}">\${work.work_title}</option>`;
                            });
                            $("#work_list").html(optionTags);
                        }
                    });
                };

                // 선택한 공연의 리뷰 목록 로드
                const loadReviewsByWork = () => {
                    const workId = $("#work_list").val();
                    if (!workId) {
                        $("#review_list").html('<option value="">먼저 공연을 선택해주세요</option>');
                        return;
                    }
                    $.ajax({
                        url: "/admin/mainpage/bestreview/reviews",
                        method: "GET",
                        data: { work_id: workId },
                        success: (reviewList) => {
                            let optionTags = '<option value="">리뷰를 선택하세요</option>';
                            if (reviewList.length === 0) {
                                optionTags = '<option value="">등록된 리뷰가 없습니다</option>';
                            } else {
                                reviewList.forEach((review) => {
                                    optionTags += `<option value="\${review.review_id}">\${review.review_title} (평점: \${review.rating})</option>`;
                                });
                            }
                            $("#review_list").html(optionTags);
                        }
                    });
                };

                // 베스트 리뷰 목록 로드
                const loadBestReviewList = () => {
                    $.ajax({
                        url: "/admin/mainpage/bestreview/list",
                        method: "GET",
                        success: (bestReviewList) => {
                            let tableRowsHtml = "";
                            if (bestReviewList.length === 0) {
                                tableRowsHtml = "<tr><td colspan='5' class='text-center'>등록된 베스트 리뷰가 없습니다.</td></tr>";
                            } else {
                                bestReviewList.forEach((bestReview) => {
                                    // 별점 표시용
                                    const rating = bestReview.review ? bestReview.review.rating : '-';
                                    const title = bestReview.review ? bestReview.review.review_title : '-';
                                    const author = bestReview.review && bestReview.review.member ? bestReview.review.member.member_email : '-';
                                    
                                    tableRowsHtml += `
                                    <tr>
                                        <td>\${bestReview.bestreview_id}</td>
                                        <td>\${title}</td>
                                        <td>\${rating}</td>
                                        <td>\${author}</td>
                                        <td>
                                            <button class="btn btn-sm btn-danger" onclick="deleteBestReview(\${bestReview.bestreview_id})">삭제</button>
                                        </td>
                                    </tr>`;
                                });
                            }
                            $("#bestreview-list-body").html(tableRowsHtml);
                        }
                    });
                };

                // 베스트 리뷰 저장
                const saveBestReview = () => {
                    const reviewId = $("#review_list").val();
                    if (!reviewId) {
                        alert("리뷰를 선택해주세요.");
                        return;
                    }
                    $.ajax({
                        url: "/admin/mainpage/bestreview/regist",
                        type: "POST",
                        data: { review_id: reviewId },
                        success: (response) => {
                            alert(response.message);
                            $("#regis-form")[0].reset();
                            $("#review_list").html('<option value="">먼저 공연을 선택해주세요</option>');
                            loadBestReviewList();
                        },
                        error: (errorResponse) => {
                            let errorMessage = "베스트 리뷰 등록 중 오류가 발생했습니다.";
                            if (errorResponse.responseJSON && errorResponse.responseJSON.message) {
                                errorMessage = errorResponse.responseJSON.message;
                            }
                            alert(errorMessage);
                        }
                    });
                };

                // 베스트 리뷰 삭제
                window.deleteBestReview = (bestreviewId) => {
                    if (!confirm("정말 삭제하시겠습니까?")) return;
                    $.ajax({
                        url: "/admin/mainpage/bestreview/delete",
                        type: "POST",
                        data: { bestreview_id: bestreviewId },
                        success: (response) => {
                            loadBestReviewList();
                        },
                        error: (errorResponse) => {
                            let errorMessage = "삭제 처리 중 오류가 발생했습니다.";
                            if (errorResponse.responseJSON && errorResponse.responseJSON.message) {
                                errorMessage = errorResponse.responseJSON.message;
                            }
                            alert(errorMessage);
                        }
                    });
                };

                $(() => {
                    loadWorkList();
                    loadBestReviewList();
                    
                    // 공연 선택시 리뷰 목록 로드
                    $("#work_list").change(() => {
                        loadReviewsByWork();
                    });
                    
                    $("#btn-save").click(() => {
                        saveBestReview();
                    });
                });
            })();
        </script>
    </body>

    </html>