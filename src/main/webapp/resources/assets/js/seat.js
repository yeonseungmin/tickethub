/* [/static/assets/js/seat.js] */
window.selectedSeatIds = [];
window.isSelecting = false;

$(document).ready(function() {
    // 1. 장소 -> 공연 -> 회차 필터 연동 (공통)
    $(document).off('change', '#placeSelect').on('change', '#placeSelect', function() {
        var placeId = $(this).val();
        // 요청 직후 하위 메뉴 초기화
        $('#workSelect, #roundSelect').empty().append('<option value="">선택</option>');
        if (!placeId) return;

        $.get(contextPath + '/admin/roundseat/workList', { place_id: placeId }, function(data) {
            var $workSelect = $('#workSelect');
            // [해결 방안 1] 응답이 왔을 때 목록을 한 번 더 비워서 중복 응답 누적 방지
            $workSelect.empty().append('<option value="">공연 선택</option>');
            
            // [해결 방안 2] 서버 데이터 자체에 중복이 있을 경우를 대비한 Set 활용
            var uniqueWorks = new Set(); 
            data.forEach(function(w) {
                if(!uniqueWorks.has(w.work_id)) {
                    uniqueWorks.add(w.work_id);
                    $workSelect.append('<option value="'+w.work_id+'">'+w.work_title+'</option>');
                }
            });
        });
    });

    $(document).off('change', '#workSelect').on('change', '#workSelect', function() {
        var workId = $(this).val();
        var placeId = $('#placeSelect').val();
        $('#roundSelect').empty().append('<option value="">회차 선택</option>');
        if (!workId) return;

        $.get(contextPath + '/admin/roundseat/roundList', { work_id: workId, place_id: placeId }, function(data) {
            var $roundSelect = $('#roundSelect');
            // 응답 시점에 초기화
            $roundSelect.empty().append('<option value="">회차 선택</option>');
            
            var uniqueRounds = new Set();
            data.forEach(function(r) {
                if(!uniqueRounds.has(r.round_id)) {
                    uniqueRounds.add(r.round_id);
                    var roundText = r.round_date + ' (' + r.round_start_time + ')';
                    $roundSelect.append('<option value="'+r.round_id+'">'+roundText+'</option>');
                }
            });
        });
    });
    // 2. Lasso 다중 선택 (공통)
    if (!$('#selection-box').length) $('body').append('<div id="selection-box" class="selection-box"></div>');
    var $box = $('#selection-box');
    var startX, startY;

    $('#seatArea').on('mousedown', function(e) {
        if ($(e.target).closest('.admin-seat, .group-boundary-box').length > 0) return;
        window.isSelecting = true;
        var areaOffset = $(this).offset();
        startX = e.pageX - areaOffset.left;
        startY = e.pageY - areaOffset.top;
        $box.css({ left: startX, top: startY, width: 0, height: 0, display: 'block' }).appendTo($(this));
        if (!e.ctrlKey) { window.selectedSeatIds = []; $('.admin-seat').removeClass('selected-multi'); }
    });

    $(document).on('mousemove', function(e) {
        if (!window.isSelecting) return;
        var areaOffset = $('#seatArea').offset();
        var curX = e.pageX - areaOffset.left, curY = e.pageY - areaOffset.top;
        var left = Math.min(startX, curX), top = Math.min(startY, curY);
        var width = Math.abs(startX - curX), height = Math.abs(startY - curY);
        $box.css({ left: left, top: top, width: width, height: height });

        $('.admin-seat').each(function() {
            var $s = $(this), pos = $s.position();
            if (pos.left >= left && pos.left <= left + width && pos.top >= top && pos.top <= top + height) {
                if (!window.selectedSeatIds.includes($s.data('seat-id'))) {
                    window.selectedSeatIds.push($s.data('seat-id'));
                    $s.addClass('selected-multi');
                }
            }
        });
        if (typeof updateSelectionInfo === 'function') updateSelectionInfo();
    }).on('mouseup', function() {
        window.isSelecting = false; $box.hide();
    });
});

function updateSelectionInfo(info) {
    const count = window.selectedSeatIds.length;
    $('#selName').html(count > 0 ? `<b style="color:#2563eb;">${count}</b>개` : "-");
    $('#selState').text(info || (count > 1 ? "다중 선택" : "-"));
}