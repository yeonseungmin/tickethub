<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    .table th, .table td { vertical-align: middle !important; }
    /* 보라색 테마 포인트 */
    .pagination .page-item.active .page-link {
        background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%) !important;
        border-color: transparent !important;
    }
</style>
</head>
<body>

<div class="container-fluid" style="max-width: 900px; padding-top: 20px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="font-weight-bold m-0">주최/기획 관리</h3>
        <span class="text-muted small">총 <strong id="publisher-total-count" class="text-primary">0</strong>곳 등록됨</span>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="bg-light text-center">
                    <tr>
                        <th style="width: 80px;">번호</th>
                        <th>주최/기획명</th>
                        <th style="width: 250px;">연락처 (문의번호)</th>
                        <th style="width: 180px;">관리</th>
                    </tr>
                </thead>
                <tbody id="publisher-table-body"></tbody>
            </table>
        </div>
    </div>
    <nav class="mt-4"><ul class="pagination justify-content-center" id="publisher-pagination"></ul></nav>
</div>

<div class="modal fade" id="publisherEditModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title font-weight-bold">주최/기획 정보 수정</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <form id="editPublisherForm">
                <div class="modal-body">
                    <input type="hidden" name="publisher_id" id="edit_publisher_id">
                    
                    <div class="form-group">
                        <label class="font-weight-bold">주최/기획 명칭</label>
                        <input type="text" class="form-control" name="publisher_name" id="edit_publisher_name" required placeholder="기획사 이름을 입력하세요">
                    </div>

                    <div class="form-group">
                        <label class="font-weight-bold">연락처</label>
                        <input type="text" class="form-control" name="publisher_phone" id="edit_publisher_phone" required placeholder="02-123-4567">
                        <small class="text-muted">상세페이지 하단 판매정보에 노출됩니다.</small>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-link text-muted" data-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-info px-4 text-white">수정완료</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
(function() {
    let fullPublisherList = []; 
    let paging;
    let currentActivePage = 1;

    // 데이터 로드
    function loadPublisherData() {
        $.ajax({
            url: "/admin/performance/publisher/list",
            method: "GET",
            success: function(res) {
                fullPublisherList = res;
                $("#publisher-total-count").text(fullPublisherList.length);
                renderTable(currentActivePage);
            }
        });
    }

    // 테이블 렌더링
    function renderTable(page) {
        currentActivePage = page;
        paging = new Paging();
        paging.init(fullPublisherList, page);

        let num = paging.num;
        let curPos = paging.curPos;
        let html = "";

        if (fullPublisherList.length === 0) {
            html = '<tr><td colspan="4" class="text-center py-5 text-muted">등록된 주최사가 없습니다.</td></tr>';
        } else {
            for (let i = 0; i < paging.pageSize; i++) {
                if (num < 1) break;
                let pub = fullPublisherList[curPos++];
                const pubJson = JSON.stringify(pub).replace(/"/g, '&quot;');

                html += `
                    <tr class="text-center">
                        <td class="text-muted">\${num--}</td>
                        <td class="font-weight-bold text-left pl-4">\${pub.publisher_name}</td>
                        <td class="text-secondary">\${pub.publisher_phone}</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary mr-1" onclick="PublisherManager.openEditModal(\${pubJson})">
                                <i class="fas fa-edit"></i> 수정
                            </button>
                            <button class="btn btn-sm btn-outline-danger" onclick="PublisherManager.handleDelete(\${pub.publisher_id})">
                                <i class="fas fa-trash-alt"></i> 삭제
                            </button>
                        </td>
                    </tr>`;
            }
        }
        $("#publisher-table-body").html(html);
        renderPagination(page);
    }

    // 페이지네이션
    function renderPagination(currentPage) {
        let pageHtml = "";
        if (paging.firstPage > 1) {
            pageHtml += `<li class="page-item"><a class="page-link" href="javascript:PublisherManager.renderTable(\${paging.firstPage - 1})">이전</a></li>`;
        }
        for (let i = paging.firstPage; i <= paging.lastPage; i++) {
            pageHtml += `<li class="page-item \${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="javascript:PublisherManager.renderTable(\${i})">\${i}</a>
                         </li>`;
        }
        if (paging.lastPage < paging.totalPage) {
            pageHtml += `<li class="page-item"><a class="page-link" href="javascript:PublisherManager.renderTable(\${paging.lastPage + 1})">다음</a></li>`;
        }
        $("#publisher-pagination").html(pageHtml);
    }

    // 모달 오픈
    function openEditModal(pub) {
        $("#edit_publisher_id").val(pub.publisher_id);
        $("#edit_publisher_name").val(pub.publisher_name);
        $("#edit_publisher_phone").val(pub.publisher_phone);
        $("#publisherEditModal").modal("show");
    }

    // 삭제 처리
    function handleDelete(id) {
        if(!confirm("해당 주최/기획사를 삭제하시겠습니까?\n이미 등록된 공연이 있을 경우 삭제되지 않습니다.")) return;
        $.ajax({
            url: "/admin/performance/publisher/delete",
            method: "POST",
            data: { publisher_id: id },
            success: function() {
                alert("성공적으로 삭제되었습니다.");
                loadPublisherData();
            },
            error: function() { alert("삭제 실패: 이 주최사가 등록한 공연이 있는지 확인하세요."); }
        });
    }

    // 글로벌 네임스페이스 등록
    window.PublisherManager = {
        renderTable: renderTable,
        openEditModal: openEditModal,
        handleDelete: handleDelete
    };

    $(document).ready(function() {
        loadPublisherData();

        // 수정 제출
        $("#editPublisherForm").submit(function(e) {
            e.preventDefault();
            const formData = $(this).serialize();
            
            $.ajax({
                url: "/admin/performance/publisher/update",
                method: "POST",
                data: formData,
                success: function() {
                    alert("주최 정보가 수정되었습니다.");
                    $("#publisherEditModal").modal("hide");
                    loadPublisherData();
                },
                error: function() { alert("수정 중 서버 오류가 발생했습니다."); }
            });
        });
    });
})();
</script>
</body>
</html>