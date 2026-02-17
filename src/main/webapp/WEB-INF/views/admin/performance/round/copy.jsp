<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<style>
    .table th, .table td { vertical-align: middle !important; }
    .select2-container .select2-selection--single { height: 45px !important; border: 1px solid #ced4da; display: flex; align-items: center; }
    .select2-container--default .select2-selection--single .select2-selection__arrow { height: 43px; }
    
    .date-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(130px, 1fr)); gap: 12px; max-height: 450px; overflow-y: auto; padding: 15px; border: 1px solid #eee; border-radius: 8px; background-color: #fcfcfc; }
    .date-card { cursor: pointer; border: 1px solid #dee2e6; border-radius: 8px; padding: 12px; text-align: center; background-color: white; transition: all 0.2s; font-size: 0.9rem; }
    .date-card.selected { border-color: #6366f1; background-color: #f0f1ff; color: #4f46e5; font-weight: bold; box-shadow: 0 2px 5px rgba(99,102,241,0.2); }
    .date-card.disabled { background-color: #e9ecef; color: #adb5bd; cursor: not-allowed; border-color: #ddd; }
    
    /* 원본 스케줄 미리보기 박스 */
    .source-info { background: #f4f7fe; border-radius: 8px; padding: 15px; border-left: 5px solid #6366f1; margin-top: 15px; }
    .round-item-preview { padding: 8px; border-bottom: 1px solid #d1d9e6; margin-bottom: 5px; }
    .round-item-preview:last-child { border-bottom: none; }
    .section-title { font-size: 1rem; font-weight: 700; color: #444; margin-bottom: 15px; display: block; }
</style>
</head>
<body>

<div class="container-fluid" style="max-width: 1200px; padding-top: 20px;">
    <h3 class="font-weight-bold mb-4">📅 회차 일괄 복사 (하루 스케줄 단위)</h3>

    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body">
            <span class="section-title"><i class="fas fa-search mr-2"></i>1. 관리할 작품 선택</span>
            <select id="work-selector" class="form-control">
                <option value="">작품을 검색하여 선택하세요</option>
            </select>
        </div>
    </div>

    <div id="copy-step-container" style="display: none;">
        <div class="row">
            <div class="col-md-5">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body">
                        <span class="section-title"><i class="fas fa-history mr-2"></i>2. 복사할 기준 날짜 선택</span>
                        <p class="small text-muted">스케줄을 그대로 가져올 '원본 날짜'를 선택하세요.</p>
                        <select id="source-date-selector" class="form-control mb-3">
                            <option value="">기준 날짜 선택</option>
                        </select>
                        
                        <div id="source-detail" class="source-info" style="display: none;">
                            <label class="badge badge-primary mb-2">선택된 날짜 스케줄</label>
                            <div id="source-rounds-list">
                                </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-body">
                        <span class="section-title"><i class="fas fa-calendar-check mr-2"></i>3. 복사 대상 날짜 선택</span>
                        <p class="small text-muted"><i class="fas fa-info-circle"></i> 오늘 이후이며, 아직 회차가 하나도 없는 날짜만 선택 가능합니다.</p>
                        <div class="date-grid" id="target-date-grid"></div>
                        <div class="mt-4 d-flex justify-content-between align-items-center">
                            <div><span class="text-dark">선택된 대상: <strong id="selected-count" class="text-primary">0</strong>일</span></div>
                            <button class="btn btn-primary px-5 font-weight-bold" onclick="CopyManager.executeCopy()">
                                <i class="fas fa-copy"></i> 선택한 날짜들에 스케줄 복사
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script>
(function() {
    let workMap = {};
    let fullRoundList = [];
    let selectedDates = [];

    function init() {
        $.get("/admin/performance/work/list", function(works) {
            let html = '<option value="">작품 선택</option>';
            works.forEach(w => {
                workMap[w.work_id] = w;
                html += `<option value="\${w.work_id}">\${w.work_title}</option>`;
            });
            $("#work-selector").html(html).select2({ placeholder: "작품 제목 검색", allowClear: true });
        });
    }

    $("#work-selector").on("change", function() {
        const workId = $(this).val();
        if(!workId) { $("#copy-step-container").hide(); return; }
        
        $.get("/admin/performance/round/list?work_id=" + workId, function(res) {
            fullRoundList = res;
            renderSourceDates(); // 회차가 등록된 날짜들만 필터링
            renderTargetDates(workMap[workId]);
            $("#copy-step-container").fadeIn();
        });
    });

    // 회차가 존재하는 날짜들만 골라내기
    function renderSourceDates() {
        const datesWithRounds = [...new Set(fullRoundList.map(r => r.round_date))].sort();
        let html = '<option value="">기준 날짜 선택</option>';
        datesWithRounds.forEach(date => {
            const count = fullRoundList.filter(r => r.round_date === date).length;
            html += `<option value="\${date}">\${date} (\${count}개 회차)</option>`;
        });
        $("#source-date-selector").html(html).select2({ dropdownParent: $('#copy-step-container') });
    }

    // 원본 날짜 선택 시 해당 날짜의 모든 회차 미리보기
    $("#source-date-selector").on("change", function() {
        const date = $(this).val();
        const rounds = fullRoundList.filter(r => r.round_date === date);
        
        if(rounds.length > 0) {
            let html = "";
            rounds.forEach(r => {
                const castingStr = r.roundCastingList.map(c => `\${c.person.person_name}`).join(", ") || "캐스팅 없음";
                html += `
                    <div class="round-item-preview">
                        <div class="small font-weight-bold text-dark">\${r.round_start_time} | \${r.place.place_name}</div>
                        <div class="x-small text-muted">\${castingStr}</div>
                    </div>`;
            });
            $("#source-rounds-list").html(html);
            $("#source-detail").fadeIn();
        } else {
            $("#source-detail").hide();
        }
    });

    function renderTargetDates(work) {
        const start = new Date(work.work_start_date);
        const end = new Date(work.work_end_date);
        const today = new Date();
        today.setHours(0,0,0,0);
        
        const existingDates = [...new Set(fullRoundList.map(r => r.round_date))];
        
        let html = "";
        selectedDates = [];
        $("#selected-count").text(0);

        for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
            const dateStr = d.toISOString().split('T')[0];
            const isExist = existingDates.includes(dateStr);
            const isPast = d < today;
            
            if(isExist) {
                html += `<div class="date-card disabled" title="이미 회차가 존재함">\${dateStr}<br><small>(등록됨)</small></div>`;
            } else if(isPast) {
                html += `<div class="date-card disabled" title="과거 날짜">\${dateStr}<br><small>(종료)</small></div>`;
            } else {
                html += `<div class="date-card" onclick="CopyManager.toggleDate(this, '\${dateStr}')">\${dateStr}</div>`;
            }
        }
        $("#target-date-grid").html(html);
    }

    function toggleDate(el, date) {
        if($(el).hasClass('disabled')) return;
        $(el).toggleClass('selected');
        if($(el).hasClass('selected')) {
            selectedDates.push(date);
        } else {
            selectedDates = selectedDates.filter(d => d !== date);
        }
        $("#selected-count").text(selectedDates.length);
    }

    function executeCopy() {
        const sourceDate = $("#source-date-selector").val();
        if(!sourceDate) return alert("복사할 기준 날짜를 선택해주세요.");
        if(selectedDates.length === 0) return alert("복사 대상 날짜를 선택해주세요.");

        if(!confirm(`\${sourceDate}의 스케줄을 \${selectedDates.length}일치로 복사하시겠습니까?`)) return;

        $.ajax({
            url: "/admin/performance/round/copy",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify({
                work_id: $("#work-selector").val(),
                source_date: sourceDate,
                target_dates: selectedDates
            }),
            success: function() {
                alert("일괄 복사가 완료되었습니다.");
                $("#work-selector").trigger("change");
            }
        });
    }

    window.CopyManager = { toggleDate, executeCopy };
    $(document).ready(init);
})();
</script>
</body>
</html>