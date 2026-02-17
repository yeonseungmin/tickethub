<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    .work-poster-thumb { width: 60px; height: 80px; object-fit: cover; border-radius: 4px; border: 1px solid #eee; }
    .table th, .table td { vertical-align: middle !important; }
    
    /* 모달 내부 이미지 미리보기 스타일 */
    .edit-preview-poster { width: 100%; height: 200px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd; }
    .edit-preview-content { width: 100%; max-height: 250px; object-fit: contain; border: 1px solid #ddd; overflow-y: auto; background: #f8f8f8; }
    
    .pagination .page-item.active .page-link {
        background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%) !important;
        border-color: transparent !important;
    }
</style>
</head>
<body>

<div class="container-fluid" style="max-width: 1000px; padding-top: 20px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="font-weight-bold m-0">공연 작품 관리</h3>
        <span class="text-muted small">총 <strong id="work-total-count" class="text-primary">0</strong>개 작품 등록됨</span>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="bg-light text-center">
                    <tr>
                        <th style="width: 80px;">번호</th>
                        <th style="width: 120px;">포스터</th>
                        <th>공연 제목</th>
                        <th style="width: 180px;">관리</th>
                    </tr>
                </thead>
                <tbody id="work-table-body"></tbody>
            </table>
        </div>
    </div>
    <nav class="mt-4"><ul class="pagination justify-content-center" id="work-pagination"></ul></nav>
</div>

<div class="modal fade" id="workEditModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title font-weight-bold">작품 상세정보 수정</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <form id="editWorkForm" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="work_id" id="edit_work_id">
                    
                    <div class="row mb-4">
                        <div class="col-md-4 text-center border-right">
                            <label class="font-weight-bold">포스터 변경</label>
                            <img id="edit_poster_preview" src="" class="edit-preview-poster mb-2">
                            <div class="custom-file text-left">
                                <input type="file" class="custom-file-input" name="work_poster_img" id="edit_work_poster" accept="image/*">
                                <label class="custom-file-label text-truncate">포스터 선택</label>
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div class="form-group">
                                <label class="font-weight-bold">공연 제목</label>
                                <input type="text" class="form-control" name="work_title" id="edit_work_title" required>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6"><label class="small font-weight-bold">감독</label><input type="text" class="form-control" name="director" id="edit_director"></div>
                                <div class="form-group col-md-6"><label class="small font-weight-bold">연령제한</label><input type="number" class="form-control" name="age_limit" id="edit_age_limit"></div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6"><label class="small font-weight-bold">가격</label><input type="number" class="form-control" name="work_price" id="edit_work_price"></div>
                                <div class="form-group col-md-6"><label class="small font-weight-bold">러닝타임(분)</label><input type="number" class="form-control" name="running_time" id="edit_running_time"></div>
                            </div>
                        </div>
                    </div>

                    <div class="row border-top pt-3">
                        <div class="col-12">
                            <label class="font-weight-bold">상세 내용 이미지 변경</label>
                            <div class="edit-preview-content mb-2 text-center p-2">
                                <img id="edit_content_preview" src="" style="width: 100%;">
                            </div>
                            <div class="custom-file">
                                <input type="file" class="custom-file-input" name="work_content_img" id="edit_work_content" accept="image/*">
                                <label class="custom-file-label text-truncate">내용 이미지 선택</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-link text-muted" data-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-primary px-4">수정완료</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
(function() {
    let fullWorkList = []; 
    let paging;
    let currentActivePage = 1;

    function loadWorkData() {
        $.ajax({
            url: "/admin/performance/work/list",
            method: "GET",
            success: function(res) {
                fullWorkList = res;
                $("#work-total-count").text(fullWorkList.length);
                renderTable(currentActivePage);
            }
        });
    }

    function renderTable(page) {
        currentActivePage = page;
        paging = new Paging();
        paging.init(fullWorkList, page);

        let num = paging.num;
        let curPos = paging.curPos;
        let html = "";

        if (fullWorkList.length === 0) {
            html = '<tr><td colspan="4" class="text-center py-5 text-muted">등록된 공연 작품이 없습니다.</td></tr>';
        } else {
            for (let i = 0; i < paging.pageSize; i++) {
                if (num < 1) break;
                let work = fullWorkList[curPos++];
                const workJson = JSON.stringify(work).replace(/"/g, '&quot;');

                html += `
                    <tr class="text-center">
                        <td class="text-muted">\${num--}</td>
                        <td><img src="/photo/work/p\${work.work_id}/\${work.work_poster_url}" class="work-poster-thumb" onerror="this.src='/static/assets/img/no-image.png'"></td>
                        <td class="text-left font-weight-bold">\${work.work_title}</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary mr-1" onclick="WorkManager.openEditModal(\${workJson})">
                                <i class="fas fa-edit"></i> 수정
                            </button>
                            <button class="btn btn-sm btn-outline-danger" onclick="WorkManager.handleDelete(\${work.work_id})">
                                <i class="fas fa-trash-alt"></i> 삭제
                            </button>
                        </td>
                    </tr>`;
            }
        }
        $("#work-table-body").html(html);
        renderPagination(page);
    }

    function renderPagination(currentPage) {
        let pageHtml = "";
        if (paging.firstPage > 1) {
            pageHtml += `<li class="page-item"><a class="page-link" href="javascript:WorkManager.renderTable(\${paging.firstPage - 1})">이전</a></li>`;
        }
        for (let i = paging.firstPage; i <= paging.lastPage; i++) {
            pageHtml += `<li class="page-item \${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="javascript:WorkManager.renderTable(\${i})">\${i}</a>
                         </li>`;
        }
        if (paging.lastPage < paging.totalPage) {
            pageHtml += `<li class="page-item"><a class="page-link" href="javascript:WorkManager.renderTable(\${paging.lastPage + 1})">다음</a></li>`;
        }
        $("#work-pagination").html(pageHtml);
    }

    function openEditModal(work) {
        $("#edit_work_id").val(work.work_id);
        $("#edit_work_title").val(work.work_title);
        $("#edit_director").val(work.director);
        $("#edit_age_limit").val(work.age_limit);
        $("#edit_work_price").val(work.work_price);
        $("#edit_running_time").val(work.running_time);
        
        $("#edit_poster_preview").attr("src", `/photo/work/p\${work.work_id}/\${work.work_poster_url}`);
        $("#edit_content_preview").attr("src", `/photo/work/p\${work.work_id}/\${work.work_content_url}`);
        
        $(".custom-file-input").val("");
        $(".custom-file-label").html("파일 선택");
        
        $("#workEditModal").modal("show");
    }

    function handleDelete(id) {
        if(!confirm("정말 이 작품을 삭제하시겠습니까? 관련 회차가 없을 경우 삭제 가능합니다.")) return;
        $.ajax({
            url: "/admin/performance/work/delete",
            method: "POST",
            data: { work_id: id },
            success: function() {
                alert("삭제되었습니다.");
                loadWorkData();
            },
            error: function() {
                alert("삭제 실패: 참조 중인 데이터가 있는지 확인하세요.");
            }
        });
    }

    function setupImagePreview(inputSelector, previewSelector) {
        $(inputSelector).on("change", function() {
            let file = this.files[0];
            if (file) {
                let reader = new FileReader();
                reader.onload = e => $(previewSelector).attr("src", e.target.result);
                reader.readAsDataURL(file);
                $(this).siblings(".custom-file-label").html(file.name);
            }
        });
    }

    // 글로벌 네임스페이스 등록
    window.WorkManager = {
        renderTable: renderTable,
        openEditModal: openEditModal,
        handleDelete: handleDelete
    };

    $(document).ready(function() {
        loadWorkData();
        setupImagePreview("#edit_work_poster", "#edit_poster_preview");
        setupImagePreview("#edit_work_content", "#edit_content_preview");

        $("#editWorkForm").submit(function(e) {
            e.preventDefault();
            let formData = new FormData(this);
            $.ajax({
                url: "/admin/performance/work/update",
                method: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function() {
                    alert("수정 완료!");
                    $("#workEditModal").modal("hide");
                    loadWorkData();
                }
            });
        });
    });
})();
</script>
</body>
</html>