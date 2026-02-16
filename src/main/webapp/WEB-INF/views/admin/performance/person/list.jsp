<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    .person-thumb { width: 45px; height: 45px; object-fit: cover; border-radius: 50%; border: 1px solid #eee; }
    .table th, .table td { vertical-align: middle !important; }
    .pagination .page-item.active .page-link {
        background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%) !important;
        border-color: transparent !important;
    }
</style>
</head>
<body>

<div class="container-fluid" style="max-width: 1000px; padding-top: 20px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="font-weight-bold m-0">인물(출연진) 관리</h3>
        <span class="text-muted small">총 <strong id="total-count" class="text-primary">0</strong>명 등록됨</span>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="bg-light text-center">
                    <tr>
                        <th style="width: 80px;">번호</th>
                        <th style="width: 100px;">프로필</th>
                        <th>이름</th>
                        <th style="width: 180px;">관리</th>
                    </tr>
                </thead>
                <tbody id="person-table-body"></tbody>
            </table>
        </div>
    </div>
    <nav class="mt-4"><ul class="pagination justify-content-center" id="person-pagination"></ul></nav>
</div>

<div class="modal fade" id="personEditModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title font-weight-bold">인물 정보 수정</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <form id="editPersonForm">
                <div class="modal-body">
                    <input type="hidden" name="person_id" id="edit_person_id">
                    <div class="text-center mb-4">
                        <img id="edit_preview" src="" class="person-thumb shadow-sm" style="width: 100px; height: 100px;">
                    </div>
                    <div class="form-group">
                        <label class="font-weight-bold">이름</label>
                        <input type="text" class="form-control" name="person_name" id="edit_person_name" required>
                    </div>
                    <div class="form-group">
                        <label class="font-weight-bold">프로필 이미지 변경</label>
                        <div class="custom-file">
                            <input type="file" class="custom-file-input" name="profile_img" id="edit_profile_img">
                            <label class="custom-file-label">파일을 선택하세요</label>
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
    let fullPersonList = []; 
    let paging;
    let currentActivePage = 1;

    function loadPersonData() {
        $.ajax({
            url: "/admin/performance/person/list",
            method: "GET",
            success: function(res) {
                fullPersonList = res;
                $("#total-count").text(fullPersonList.length);
                renderTable(currentActivePage);
            }
        });
    }

    function renderTable(page) {
        currentActivePage = page;
        paging = new Paging();
        paging.init(fullPersonList, page);

        let num = paging.num;
        let curPos = paging.curPos;
        let html = "";

        if (fullPersonList.length === 0) {
            html = '<tr><td colspan="4" class="text-center py-5 text-muted">등록된 인물이 없습니다.</td></tr>';
        } else {
            for (let i = 0; i < paging.pageSize; i++) {
                if (num < 1) break;
                let person = fullPersonList[curPos++];
                const personJson = JSON.stringify(person).replace(/"/g, '&quot;');

                html += `
                    <tr class="text-center">
                        <td class="text-muted">\${num--}</td>
                        <td><img src="/photo/person/p\${person.person_id}/\${person.profile_url}" class="person-thumb" onerror="this.src='/static/assets/img/no-profile.png'"></td>
                        <td class="text-left font-weight-bold">\${person.person_name}</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary mr-1" onclick="PersonManager.openEditModal(\${personJson})">
                                <i class="fas fa-edit"></i> 수정
                            </button>
                            <button class="btn btn-sm btn-outline-danger" onclick="PersonManager.handleDelete(\${person.person_id})">
                                <i class="fas fa-trash-alt"></i> 삭제
                            </button>
                        </td>
                    </tr>`;
            }
        }
        $("#person-table-body").html(html);
        renderPagination(page);
    }

    function renderPagination(currentPage) {
        let pageHtml = "";
        if (paging.firstPage > 1) {
            pageHtml += `<li class="page-item"><a class="page-link" href="javascript:PersonManager.renderTable(\${paging.firstPage - 1})">이전</a></li>`;
        }
        for (let i = paging.firstPage; i <= paging.lastPage; i++) {
            pageHtml += `<li class="page-item \${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="javascript:PersonManager.renderTable(\${i})">\${i}</a>
                         </li>`;
        }
        if (paging.lastPage < paging.totalPage) {
            pageHtml += `<li class="page-item"><a class="page-link" href="javascript:PersonManager.renderTable(\${paging.lastPage + 1})">다음</a></li>`;
        }
        $("#person-pagination").html(pageHtml);
    }

    function openEditModal(person) {
        $("#edit_person_id").val(person.person_id);
        $("#edit_person_name").val(person.person_name);
        $("#edit_preview").attr("src", `/photo/person/p\${person.person_id}/\${person.profile_url}`);
        $(".custom-file-label").html("파일을 선택하세요");
        $("#personEditModal").modal("show");
    }

    function handleDelete(id) {
        if(!confirm("정말 삭제하시겠습니까?")) return;
        $.ajax({
            url: "/admin/performance/person/delete",
            method: "POST",
            data: { person_id: id },
            success: function() {
                alert("삭제되었습니다.");
                loadPersonData();
            }
        });
    }

    // 글로벌 네임스페이스 등록
    window.PersonManager = {
        renderTable: renderTable,
        openEditModal: openEditModal,
        handleDelete: handleDelete
    };

    $(document).ready(function() {
        loadPersonData();
        $("#editPersonForm").submit(function(e) {
            e.preventDefault();
            let formData = new FormData(this);
            $.ajax({
                url: "/admin/performance/person/update",
                method: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function() {
                    alert("정보가 수정되었습니다.");
                    $("#personEditModal").modal("hide");
                    loadPersonData();
                }
            });
        });
        $(".custom-file-input").on("change", function() {
            let fileName = $(this).val().split("\\").pop();
            $(this).siblings(".custom-file-label").addClass("selected").html(fileName);
        });
    });
})();
</script>
</body>
</html>