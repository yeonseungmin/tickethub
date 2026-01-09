/* [seat-common.js] 공통 로직 (이전 방식 유지) */
var selectedSeatIds = [];
var isDragging = false;
var currentGroup = null;
var offset = { x: 0, y: 0 };
var groupsData = {}; 

// Lasso 다중 선택용 변수
var isSelecting = false;
var startX, startY;
var $selectionBox = $('<div class="selection-box"></div>');

$(document).ready(function() {
    // [공용] 필터 선택 이벤트
    $('#placeSelect').on('change', function() {
        var placeId = $(this).val();
        $('#workSelect, #roundSelect').empty().append('<option value="">선택</option>');
        if (!placeId) return;
        $.get(contextPath + '/admin/roundseat/workList', { place_id: placeId }, function(data) {
            data.forEach(function(w) {
                $('#workSelect').append('<option value="'+w.work_id+'">'+w.work_title+'</option>');
            });
        });
        // seatstate 전용 구역 목록 갱신 (함수가 정의되어 있을 때만 실행)
        if(typeof refreshGroupSelect === 'function') refreshGroupSelect(placeId);
    });

    $('#workSelect').on('change', function() {
        var workId = $(this).val();
        var placeId = $('#placeSelect').val();
        $('#roundSelect').empty().append('<option value="">회차 선택</option>');
        if (!workId || !placeId) return;
        $.get(contextPath + '/admin/roundseat/roundList', { work_id: workId, place_id: placeId }, function(data) {
            data.forEach(function(r) {
                var txt = r.round_date + ' (' + r.round_start_time + ')';
                $('#roundSelect').append('<option value="'+r.round_id+'">'+txt+'</option>');
            });
        });
    });

    // [공용] 마우스 이벤트 (Lasso 및 드래그)
    $('#seatArea').on('mousedown', function(e) {
        if (isDragging || $(e.target).closest('.admin-seat').length > 0) return;
        isSelecting = true;
        var areaOffset = $(this).offset();
        startX = e.pageX - areaOffset.left;
        startY = e.pageY - areaOffset.top;
        $selectionBox.css({ left: startX, top: startY, width: 0, height: 0 });
        $(this).append($selectionBox);
        if (!e.ctrlKey) { selectedSeatIds = []; $('.admin-seat').removeClass('selected-multi'); }
    });

    $(document).on('mousemove', function(e) {
        if (isSelecting) {
            var areaOffset = $('#seatArea').offset();
            var curX = e.pageX - areaOffset.left, curY = e.pageY - areaOffset.top;
            var left = Math.min(startX, curX), top = Math.min(startY, curY);
            var width = Math.abs(startX - curX), height = Math.abs(startY - curY);
            $selectionBox.css({ left: left, top: top, width: width, height: height });
            $('.admin-seat').each(function() {
                var $s = $(this), sPos = $s.position(), sId = $s.data('seat-id');
                var isInside = (sPos.left >= left && sPos.left <= left + width && sPos.top >= top && sPos.top <= top + height);
                if (isInside && !selectedSeatIds.includes(sId)) {
                    selectedSeatIds.push(sId); $s.addClass('selected-multi');
                }
            });
            updateSelectionInfo();
        }
        if (isDragging && currentGroup) {
            var g = groupsData[currentGroup], $box = $('.group-boundary-box[data-group-id="' + currentGroup + '"]');
            var newL = e.pageX - offset.x, newT = e.pageY - offset.y;
            $box.css({ left: newL + 'px', top: newT + 'px' });
            var dx = (newL + 20) - g.minX, dy = (newT + 20) - g.minY;
            $('.admin-seat[data-group-id="' + currentGroup + '"]').each(function() {
                var $s = $(this), ox = parseFloat($s.attr('data-orig-x')), oy = parseFloat($s.attr('data-orig-y'));
                $s.css({ left: (ox + dx) + 'px', top: (oy + dy) + 'px' });
            });
        }
    });

    $(document).on('mouseup', function() {
        if (isSelecting) { isSelecting = false; $selectionBox.remove(); }
        if (isDragging) {
            var $box = $('.group-boundary-box[data-group-id="' + currentGroup + '"]'), g = groupsData[currentGroup];
            var dx = (parseFloat($box.css('left')) + 20) - g.minX, dy = (parseFloat($box.css('top')) + 20) - g.minY;
            g.posX += dx; g.posY += dy; g.minX += dx; g.minY += dy;
            $('.admin-seat[data-group-id="' + currentGroup + '"]').each(function() {
                $(this).attr('data-orig-x', parseFloat($(this).css('left'))).attr('data-orig-y', parseFloat($(this).css('top')));
            });
            $box.removeClass('dragging'); isDragging = false; currentGroup = null;
        }
    });
});

// [공용] 좌석 렌더링 함수 (mode: 'grade' 또는 'state')
function renderStatusMap(seatList, mode) {
    var $container = $('#seatArea');
    $container.find('.admin-seat, .group-boundary-box').remove();
    var groups = {};
    seatList.forEach(function(seat) {
        if (!groups[seat.seat_group_id]) {
            groups[seat.seat_group_id] = { name: seat.group_name, minX: Infinity, minY: Infinity, maxX: -Infinity, maxY: -Infinity, posX: seat.pos_x, posY: seat.pos_y, rowGap: seat.row_gap, colGap: seat.col_gap };
        }
        var curX = seat.pos_x + (seat.seat_x.charCodeAt(0) - 65) * seat.col_gap;
        var curY = seat.pos_y + (seat.seat_y - 1) * seat.row_gap;
        var g = groups[seat.seat_group_id];
        if (curX < g.minX) g.minX = curX; if (curY < g.minY) g.minY = curY;
        if (curX > g.maxX) g.maxX = curX; if (curY > g.maxY) g.maxY = curY;
    });
    groupsData = groups;
    Object.keys(groups).forEach(function(id) {
        var g = groups[id];
        var $box = $('<div class="group-boundary-box"></div>').attr('data-group-id', id).css({ left: (g.minX - 20) + 'px', top: (g.minY - 20) + 'px', width: (g.maxX - g.minX + 72) + 'px', height: (g.maxY - g.minY + 72) + 'px' });
        $box.append($('<div class="group-name-label"></div>').text(g.name)).appendTo($container);
        $box.on('mousedown', function(e) {
            if ($(e.target).hasClass('admin-seat')) return;
            isDragging = true; currentGroup = id;
            var boxOffset = $box.position();
            offset.x = e.pageX - boxOffset.left; offset.y = e.pageY - boxOffset.top;
            $box.addClass('dragging'); e.preventDefault();
        });
    });

    seatList.forEach(function(seat) {
        var finalX = seat.pos_x + (seat.seat_x.charCodeAt(0) - 65) * seat.col_gap;
        var finalY = seat.pos_y + (seat.seat_y - 1) * seat.row_gap;
        
        // mode가 grade일 때는 등급별 jpg, 아니면 상태별 png
        var imgUrl = (mode === 'grade') 
            ? contextPath + "/static/assets/seatImg/available_" + (['vip','r','s'].includes(seat.grade_name.toLowerCase()) ? seat.grade_name.toLowerCase() : 'a') + ".jpg"
            : contextPath + "/static/assets/adminSeatImg/" + (seat.status || 'AVAILABLE').toUpperCase() + ".png";

        $('<div class="admin-seat"></div>')
            .attr({ 'data-seat-id': seat.seat_id, 'data-group-id': seat.seat_group_id, 'data-orig-x': finalX, 'data-orig-y': finalY })
            .css({ left: finalX + 'px', top: finalY + 'px', backgroundImage: "url('" + imgUrl + "')" })
            .on('click', function(e) {
                e.stopPropagation();
                if (e.ctrlKey) {
                    var idx = selectedSeatIds.indexOf(seat.seat_id);
                    if (idx > -1) { selectedSeatIds.splice(idx, 1); $(this).removeClass('selected-multi'); }
                    else { selectedSeatIds.push(seat.seat_id); $(this).addClass('selected-multi'); }
                } else {
                    $('.admin-seat').removeClass('selected-multi');
                    selectedSeatIds = [seat.seat_id]; $(this).addClass('selected-multi');
                }
                updateSelectionInfo(mode === 'grade' ? seat.grade_name : seat.status);
            }).appendTo($container);
    });
}

function updateSelectionInfo(info) {
    $('#selName').text(selectedSeatIds.length > 0 ? selectedSeatIds.length + "개 선택" : "-");
    $('#selState').text(info || (selectedSeatIds.length > 1 ? "MULTI" : "-"));
}