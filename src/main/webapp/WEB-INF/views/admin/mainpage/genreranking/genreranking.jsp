<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>장르별 화제작 관리</title>
        <style>
            .drag-handle {
                cursor: move;
            }

            .drag-handle:hover {
                color: #007bff;
            }

            #genreranking-list-body tr.ui-sortable-helper {
                background: #f8f9fa;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
            }
        </style>
    </head>

    <body>

        <div class="content-header">
            <div class="container-fluid">
                <h4 class="m-0">장르별 화제작 관리</h4>
            </div>
        </div>

        <section class="content">
            <div class="container-fluid">

                <!-- 장르별 화제작 목록 -->
                <div class="card card-info">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h3 class="card-title">현재 등록된 장르별 화제작 목록</h3>
                        <button type="button" class="btn btn-sm btn-warning ml-auto" id="btn-save-order">
                            <i class="fas fa-save"></i> 순서 저장
                        </button>
                    </div>
                    <div class="card-body table-responsive p-0">
                        <table class="table table-hover text-nowrap">
                            <thead>
                                <tr>
                                    <th style="width: 40px;"></th>
                                    <th style="width: 60px;">순서</th>
                                    <th>포스터</th>
                                    <th>공연 제목</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody id="genreranking-list-body">
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 장르별 화제작 등록 폼 -->
                <div class="card card-primary mt-4">
                    <div class="card-header">
                        <h3 class="card-title">새 장르별 화제작 등록</h3>
                    </div>
                    <form id="regis-form">
                        <div class="card-body">
                            <div class="form-group">
                                <label>장르별 화제작에 등록할 공연을 선택하세요</label>
                                <select class="form-control select2" name="work_id" id="work_list">
                                    <option value="">선택된 공연 없음</option>
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
                const loadWorkList = () => {
                    $.ajax({
                        url: "/admin/performance/work/list",
                        method: "GET",
                        success: (workList) => {
                            let optionTags = "";
                            workList.forEach((work) => {
                                optionTags += `<option value="\${work.work_id}">\${work.work_title}</option>`;
                            });
                            $("#work_list").html(optionTags);
                        }
                    });
                };

                const loadGenreRankingList = () => {
                    $.ajax({
                        url: "/admin/mainpage/genreranking/list",
                        method: "GET",
                        success: (genreRankingList) => {
                            let tableRowsHtml = "";
                            if (genreRankingList.length === 0) {
                                tableRowsHtml = "<tr><td colspan='5' class='text-center'>등록된 장르별 화제작이 없습니다.</td></tr>";
                            } else {
                                genreRankingList.forEach((genreRanking, index) => {
                                    tableRowsHtml += `
                                    <tr data-id="\${genreRanking.genreranking_id}">
                                        <td class="drag-handle"><i class="fas fa-grip-vertical"></i></td>
                                        <td class="display-order">\${index + 1}</td>
                                        <td><img src="/photo/work/p\${genreRanking.work_id}/\${genreRanking.work.work_poster_url}" style="max-width:80px; max-height:100px; object-fit:cover; border-radius:4px;"></td>
                                        <td>\${genreRanking.work.work_title}</td>
                                        <td>
                                            <button class="btn btn-sm btn-danger" onclick="deleteGenreRanking(\${genreRanking.genreranking_id})">삭제</button>
                                        </td>
                                    </tr>`;
                                });
                            }
                            $("#genreranking-list-body").html(tableRowsHtml);

                            // sortable 초기화
                            $("#genreranking-list-body").sortable({
                                handle: ".drag-handle",
                                axis: "y",
                                update: function (event, ui) {
                                    updateDisplayOrder();
                                }
                            });
                        }
                    });
                };

                // 순서 번호 업데이트 (화면 표시)
                const updateDisplayOrder = () => {
                    $("#genreranking-list-body tr").each((index, tr) => {
                        $(tr).find(".display-order").text(index + 1);
                    });
                };

                // 순서 저장 함수
                const saveOrder = () => {
                    const orderList = [];
                    $("#genreranking-list-body tr").each((index, tr) => {
                        const id = $(tr).data("id");
                        if (id) {
                            orderList.push({
                                genreranking_id: id,
                                display_order: index + 1
                            });
                        }
                    });

                    if (orderList.length === 0) {
                        alert("저장할 항목이 없습니다.");
                        return;
                    }

                    $.ajax({
                        url: "/admin/mainpage/genreranking/updateOrder",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(orderList),
                        success: (response) => {
                            alert(response.message);
                        },
                        error: () => {
                            alert("순서 저장 중 오류가 발생했습니다.");
                        }
                    });
                };

                const saveGenreRanking = () => {
                    const workId = $("#work_list").val();
                    if (!workId) {
                        alert("공연을 선택해주세요.");
                        return;
                    }
                    $.ajax({
                        url: "/admin/mainpage/genreranking/regist",
                        type: "POST",
                        data: { work_id: workId },
                        success: (response) => {
                            alert(response.message);
                            $("#regis-form")[0].reset();
                            loadGenreRankingList();
                        },
                        error: (errorResponse) => {
                            let errorMessage = "장르별 화제작 등록 중 오류가 발생했습니다.";
                            if (errorResponse.responseJSON && errorResponse.responseJSON.message) {
                                errorMessage = errorResponse.responseJSON.message;
                            }
                            alert(errorMessage);
                        }
                    });
                };

                window.deleteGenreRanking = (genrerankingId) => {
                    if (!confirm("정말 삭제하시겠습니까?")) return;
                    $.ajax({
                        url: "/admin/mainpage/genreranking/delete",
                        type: "POST",
                        data: { genreranking_id: genrerankingId },
                        success: (response) => {
                            loadGenreRankingList();
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
                    loadGenreRankingList();
                    $("#btn-save").click(() => {
                        saveGenreRanking();
                    });
                    $("#btn-save-order").click(() => {
                        saveOrder();
                    });
                });
            })();
        </script>
    </body>

    </html>