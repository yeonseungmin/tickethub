<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    .table th, .table td { vertical-align: middle !important; }
    .address-text { 
        max-width: 300px; 
        white-space: nowrap; 
        overflow: hidden; 
        text-overflow: ellipsis; 
    }
    /* 보라색 테마 포인트 */
    .pagination .page-item.active .page-link {
        background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%) !important;
        border-color: transparent !important;
    }
</style>
</head>
<body>

<div class="container-fluid" style="max-width: 1100px; padding-top: 20px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="font-weight-bold m-0">공연 장소 관리</h3>
        <span class="text-muted small">총 <strong id="place-total-count" class="text-primary">0</strong>곳 등록됨</span>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="bg-light text-center">
                    <tr>
                        <th style="width: 80px;">번호</th>
                        <th style="width: 200px;">장소명</th>
                        <th>주소</th>
                        <th style="width: 150px;">좌표 (위도/경도)</th>
                        <th style="width: 180px;">관리</th>
                    </tr>
                </thead>
                <tbody id="place-table-body"></tbody>
            </table>
        </div>
    </div>
    <nav class="mt-4"><ul class="pagination justify-content-center" id="place-pagination"></ul></nav>
</div>

<div class="modal fade" id="placeEditModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title font-weight-bold">장소 정보 수정</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <form id="editPlaceForm">
                <div class="modal-body">
                    <input type="hidden" name="place_id" id="edit_place_id">
                    
                    <div class="form-group">
                        <label class="font-weight-bold">장소 이름</label>
                        <input type="text" class="form-control" name="place_name" id="edit_place_name" required>
                    </div>

                    <div class="form-group">
                        <label class="font-weight-bold">주소</label>
                        <input type="text" class="form-control" name="address" id="edit_address" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label class="font-weight-bold">위도 (Latitude)</label>
                            <input type="number" step="any" class="form-control" name="latitude" id="edit_latitude" required>
                        </div>
                        <div class="form-group col-md-6">
                            <label class="font-weight-bold">경도 (Longitude)</label>
                            <input type="number" step="any" class="form-control" name="longitude" id="edit_longitude" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-link text-muted" data-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-success px-4">수정완료</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
(function() {
    let fullPlaceList = []; 
    let paging;
    let currentActivePage = 1;

    // 데이터 로드
    function loadPlaceData() {
        $.ajax({
            url: "/admin/performance/place/list",
            method: "GET",
            success: function(res) {
                fullPlaceList = res;
                $("#place-total-count").text(fullPlaceList.length);
                renderTable(currentActivePage);
            }
        });
    }

    // 테이블 렌더링
    function renderTable(page) {
        currentActivePage = page;
        paging = new Paging();
        paging.init(fullPlaceList, page);

        let num = paging.num;
        let curPos = paging.curPos;
        let html = "";

        if (fullPlaceList.length === 0) {
            html = '<tr><td colspan="5" class="text-center py-5 text-muted">등록된 장소가 없습니다.</td></tr>';
        } else {
            for (let i = 0; i < paging.pageSize; i++) {
                if (num < 1) break;
                let place = fullPlaceList[curPos++];
                const placeJson = JSON.stringify(place).replace(/"/g, '&quot;');

                html += `
                    <tr class="text-center">
                        <td class="text-muted">\${num--}</td>
                        <td class="font-weight-bold">\${place.place_name}</td>
                        <td class="text-left"><div class="address-text" title="\${place.address}">\${place.address}</div></td>
                        <td class="small text-muted">\${place.latitude.toFixed(4)} / \${place.longitude.toFixed(4)}</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary mr-1" onclick="PlaceManager.openEditModal(\${placeJson})">
                                <i class="fas fa-edit"></i> 수정
                            </button>
                            <button class="btn btn-sm btn-outline-danger" onclick="PlaceManager.handleDelete(\${place.place_id})">
                                <i class="fas fa-trash-alt"></i> 삭제
                            </button>
                        </td>
                    </tr>`;
            }
        }
        $("#place-table-body").html(html);
        renderPagination(page);
    }

    // 페이지네이션
    function renderPagination(currentPage) {
        let pageHtml = "";
        if (paging.firstPage > 1) {
            pageHtml += `<li class="page-item"><a class="page-link" href="javascript:PlaceManager.renderTable(\${paging.firstPage - 1})">이전</a></li>`;
        }
        for (let i = paging.firstPage; i <= paging.lastPage; i++) {
            pageHtml += `<li class="page-item \${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="javascript:PlaceManager.renderTable(\${i})">\${i}</a>
                         </li>`;
        }
        if (paging.lastPage < paging.totalPage) {
            pageHtml += `<li class="page-item"><a class="page-link" href="javascript:PlaceManager.renderTable(\${paging.lastPage + 1})">다음</a></li>`;
        }
        $("#place-pagination").html(pageHtml);
    }

    // 모달 오픈
    function openEditModal(place) {
        $("#edit_place_id").val(place.place_id);
        $("#edit_place_name").val(place.place_name);
        $("#edit_address").val(place.address);
        $("#edit_latitude").val(place.latitude);
        $("#edit_longitude").val(place.longitude);
        $("#placeEditModal").modal("show");
    }

    // 삭제 처리
    function handleDelete(id) {
        if(!confirm("이 장소를 삭제하시겠습니까? 관련 공연이 있을 경우, 삭제에 실패됩니다.")) return;
        $.ajax({
            url: "/admin/performance/place/delete",
            method: "POST",
            data: { place_id: id },
            success: function() {
                alert("삭제되었습니다.");
                loadPlaceData();
            },
            error: function() { alert("삭제 실패: 참조 중인 공연 정보를 확인하세요."); }
        });
    }

    // 글로벌 네임스페이스 등록 (Place 전용)
    window.PlaceManager = {
        renderTable: renderTable,
        openEditModal: openEditModal,
        handleDelete: handleDelete
    };

    $(document).ready(function() {
        loadPlaceData();

        // 수정 제출
        $("#editPlaceForm").submit(function(e) {
            e.preventDefault();
            const formData = $(this).serialize();
            
            $.ajax({
                url: "/admin/performance/place/update",
                method: "POST",
                data: formData,
                success: function() {
                    alert("장소 정보가 수정되었습니다.");
                    $("#placeEditModal").modal("hide");
                    loadPlaceData();
                },
                error: function() { alert("수정 중 오류가 발생했습니다."); }
            });
        });
    });
})();
</script>
</body>
</html>