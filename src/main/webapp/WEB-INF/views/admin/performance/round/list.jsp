<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<style>
    .table th, .table td { vertical-align: middle !important; }
    .is-cancelled { opacity: 0.6; background-color: #f8f9fa; }
    .is-cancelled .round-info-text { text-decoration: line-through; color: #adb5bd; }
    
    /* Select2 기본 디자인 보정 */
    .select2-container .select2-selection--single { height: 45px !important; border: 1px solid #ced4da; display: flex; align-items: center; }
    .select2-container--default .select2-selection--single .select2-selection__arrow { height: 43px; }
    
    /* Select2 내 인물 사진 스타일 */
    .select2-person-res { display: flex; align-items: center; }
    .select2-person-img { width: 30px; height: 30px; border-radius: 50%; object-fit: cover; margin-right: 10px; border: 1px solid #eee; }
    
    .pagination .page-item.active .page-link {
        background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%) !important;
        border-color: transparent !important;
    }
    
    .casting-row { background: #fdfdfd; border: 1px solid #eee; border-radius: 8px; padding: 15px; margin-bottom: 10px; transition: all 0.2s; }
    .casting-row:hover { background: #f8f9ff; border-color: #6366f1; }

    /* 비활성화된 버튼 마우스 커서 처리 */
    .btn:disabled { cursor: not-allowed; }
</style>
</head>
<body>

<div class="container-fluid" style="max-width: 1200px; padding-top: 20px;">
    <h3 class="font-weight-bold mb-4">회차 및 캐스팅 관리</h3>

    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body">
            <div class="row">
                <div class="col-md-12">
                    <label class="font-weight-bold">관리할 작품 선택</label>
                    <select id="work-selector" class="form-control">
                        <option value="">작품을 검색하여 선택하세요</option>
                    </select>
                </div>
            </div>
        </div>
    </div>

    <div id="round-list-container" style="display: none;">
        <div class="d-flex justify-content-between align-items-end mb-2">
            <h5 class="font-weight-bold m-0 text-secondary">공연 회차 목록</h5>
            <span class="text-muted small">총 <strong id="total-round-count" class="text-primary">0</strong>건</span>
        </div>
        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="bg-light text-center">
                        <tr>
                            <th style="width: 60px;">번호</th>
                            <th style="width: 150px;">공연 날짜</th>
                            <th style="width: 100px;">시간</th>
                            <th>장소</th>
                            <th>캐스팅 요약</th>
                            <th style="width: 180px;">관리</th>
                        </tr>
                    </thead>
                    <tbody id="round-table-body"></tbody>
                </table>
            </div>
        </div>
        <nav class="mt-4"><ul class="pagination justify-content-center" id="round-pagination"></ul></nav>
    </div>

    <div id="empty-msg" class="py-5 text-center text-muted">
        <i class="fas fa-search fa-3x mb-3"></i>
        <p>작품을 먼저 선택하시면 회차 목록이 표시됩니다.</p>
    </div>
</div>

<div class="modal fade" id="castingModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title font-weight-bold">출연진(캐스팅) 설정</h5>
                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body bg-light" style="max-height: 600px; overflow-y: auto;">
                <div id="casting-list-area"></div>
                <button class="btn btn-outline-primary btn-block mt-3 font-weight-bold" onclick="RoundManager.addCastingRow()">
                    <i class="fas fa-plus"></i> 배우 추가하기
                </button>
            </div>
            <div class="modal-footer bg-white border-top">
                <button type="button" class="btn btn-link text-muted" data-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-dark px-5 font-weight-bold" onclick="RoundManager.saveCasting()">캐스팅 저장하기</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script>
(function() {
    let fullRoundList = [];
    let placeList = [];
    let personList = [];
    let workMap = {};
    let paging;
    let selectedWorkId = 0;
    let targetRoundId = 0;

    function init() {
        $.get("/admin/performance/work/list", function(works) {
            let html = '<option value="">작품을 검색하여 선택하세요</option>';
            works.forEach(w => {
                workMap[w.work_id] = w; // [추가] 작품 객체를 맵에 저장
                html += `<option value="\${w.work_id}">\${w.work_title}</option>`;
            });
            $("#work-selector").html(html).select2({ placeholder: "작품 제목 검색", allowClear: true });
        });

        $.get("/admin/performance/place/list", res => placeList = res);
        $.get("/admin/performance/person/list", res => personList = res);
    }

    $("#work-selector").on("change", function() {
        selectedWorkId = $(this).val();
        if (!selectedWorkId) {
            $("#round-list-container").hide();
            $("#empty-msg").show();
            return;
        }
        loadRoundData();
    });

    function loadRoundData() {
        $.get("/admin/performance/round/list?work_id=" + selectedWorkId, function(res) {
            fullRoundList = res;
            $("#total-round-count").text(fullRoundList.length);
            $("#round-list-container").show();
            $("#empty-msg").hide();
            renderTable(1);
        });
    }

    function renderTable(page) {
        paging = new Paging();
        paging.init(fullRoundList, page);
        let html = "";
        let curPos = paging.curPos;
        let num = paging.num;

        const currentWork = workMap[selectedWorkId];
        console.log(currentWork.genre.genre_name);
        const canHaveCasting = (currentWork.genre.genre_name === '뮤지컬' || currentWork.genre.genre_name === '연극');
        const castingBtnAttr = canHaveCasting ? '' : 'disabled title="뮤지컬/연극 장르만 캐스팅 설정이 가능합니다."';

        for (let i = 0; i < paging.pageSize; i++) {
            let r = fullRoundList[curPos++];
            if (!r) break; 

            let cancelClass = r.is_cancelled ? "is-cancelled" : "";
            let castingInfo = (r.roundCastingList) ? r.roundCastingList.map(c => `\${c.person.person_name}(\${c.role})`).join(", ") : "";

            html += `
                <tr class="text-center \${cancelClass}">
                    <td class="text-muted">\${num--}</td>
                    <td class="round-info-text font-weight-bold">\${r.round_date}</td>
                    <td class="round-info-text">\${r.round_start_time}</td>
                    <td class="round-info-text">\${r.place.place_name}</td>
                    <td class="text-left small text-truncate" style="max-width:250px;">\${castingInfo || '<span class="text-muted">미지정</span>'}</td>
                    <td>
                        <div class="btn-group">
                            <button class="btn btn-sm btn-outline-info" \${castingBtnAttr} onclick="RoundManager.openCastingModal(\${r.round_id})">
                                <i class="fas fa-users"></i> 캐스팅 설정
                            </button>
                            <button class="btn btn-sm btn-outline-warning" onclick="RoundManager.handleCancel(\${r.round_id}, \${r.is_cancelled})">
                                <i class="fas fa-ban"></i>
                            </button>
                            <button class="btn btn-sm btn-outline-danger" onclick="RoundManager.handleDelete(\${r.round_id})">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                    </td>
                </tr>`;
        }
        $("#round-table-body").html(html || '<tr><td colspan="6" class="text-center py-5">등록된 회차가 없습니다.</td></tr>');
        renderPagination(page);
    }

    function renderPagination(currentPage) {
        let pageHtml = "";
        if (paging.firstPage > 1) pageHtml += `<li class="page-item"><a class="page-link" href="javascript:RoundManager.renderTable(\${paging.firstPage - 1})">이전</a></li>`;
        for (let i = paging.firstPage; i <= paging.lastPage; i++) {
            pageHtml += `<li class="page-item \${i == currentPage ? 'active' : ''}"><a class="page-link" href="javascript:RoundManager.renderTable(\${i})">\${i}</a></li>`;
        }
        if (paging.lastPage < paging.totalPage) pageHtml += `<li class="page-item"><a class="page-link" href="javascript:RoundManager.renderTable(\${paging.lastPage + 1})">다음</a></li>`;
        $("#round-pagination").html(pageHtml);
    }

    function formatPerson(person) {
        if (!person.id) return person.text;
        let imgUrl = $(person.element).data('img');
        return $(`<span class="select2-person-res"><img src="\${imgUrl}" class="select2-person-img" onerror="this.src='/static/assets/img/no-profile.png'"> \${person.text}</span>`);
    }

    function openCastingModal(roundId) {
        targetRoundId = roundId;
        $("#casting-list-area").empty();
        const round = fullRoundList.find(r => r.round_id == roundId);
        
        if(round.roundCastingList && round.roundCastingList.length > 0) {
            round.roundCastingList.forEach(c => addCastingRow(c.person.person_id, c.role));
        } else {
            addCastingRow();
        }
        $("#castingModal").modal("show");
    }

    function addCastingRow(selectedId = "", role = "") {
        const rowId = 'casting_' + Date.now() + Math.floor(Math.random() * 100);
        let personOpts = personList.map(p => 
            `<option value="\${p.person_id}" data-img="/photo/person/p\${p.person_id}/\${p.profile_url}" \${p.person_id == selectedId ? 'selected' : ''}>\${p.person_name}</option>`
        ).join("");

        let row = `
            <div class="casting-row shadow-sm" id="\${rowId}">
                <div class="form-row align-items-center">
                    <div class="col-md-5">
                        <label class="small font-weight-bold text-primary">배역 이름</label>
                        <input type="text" class="form-control role-input" placeholder="예: 장발장, 지휘자" value="\${role}">
                    </div>
                    <div class="col-md-6">
                        <label class="small font-weight-bold text-primary">출연 배우 선택</label>
                        <select class="form-control person-select-2">\${personOpts}</select>
                    </div>
                    <div class="col-md-1 text-right mt-4">
                        <button class="btn btn-link text-danger p-0" onclick="$('#\${rowId}').remove()"><i class="fas fa-minus-circle fa-lg"></i></button>
                    </div>
                </div>
            </div>`;
            
        $("#casting-list-area").append(row);

        $(`#\${rowId} .person-select-2`).select2({
            templateResult: formatPerson,
            templateSelection: formatPerson,
            width: '100%',
            dropdownParent: $('#castingModal')
        });
    }

    function saveCasting() {
        let castings = [];
        $(".casting-row").each(function() {
            let p_id = $(this).find(".person-select-2").val();
            let role = $(this).find(".role-input").val();
            if(p_id && role) {
                castings.push({ 
                    role: role, 
                    person: { person_id: p_id }, 
                    round: { round_id: targetRoundId } 
                });
            }
        });

        $.ajax({
            url: "/admin/performance/casting/update",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify({ round_id: targetRoundId, roundCastingList: castings }),
            success: function() {
                alert("캐스팅 정보가 업데이트되었습니다.");
                $("#castingModal").modal("hide");
                loadRoundData();
            }
        });
    }

    function handleCancel(id, status) {
        if(!confirm(status ? "이 회차를 다시 활성화하시겠습니까?" : "이 회차를 취소하시겠습니까?")) return;
        $.post("/admin/performance/round/cancel", { round_id: id, is_cancelled: !status }, loadRoundData);
    }

    function handleDelete(id) {
        if(!confirm("회차를 영구 삭제하시겠습니까? 복구할 수 없습니다.")) return;
        $.post("/admin/performance/round/delete", { round_id: id }, loadRoundData);
    }

    window.RoundManager = { renderTable, openCastingModal, addCastingRow, saveCasting, handleCancel, handleDelete };

    $(document).ready(init);
})();
</script>
</body>
</html>