/**
 * 사용자 전용 좌석 선택 시스템 (최종 통합본)
 */
window.userReserveIds = [];      
window.userReserveObjs = [];  

const USER_PRICE_MAP = { 
    'vip': 150000, 'r': 120000, 'r석': 120000, 
    's': 90000, 's석': 90000, 'a': 60000, 'a석': 60000 
};

// [1] 초기화 함수
function initUserReservation(roundId) {
    console.log("좌석 시스템 초기화 시작. 회차:", roundId);
    loadUserSeatLayout(roundId);

    $('#seatArea').off('click').on('click', '.available', function(e) {
        e.stopPropagation();
        toggleUserSeatSelection($(this));
    });
}

// [2] 데이터 로드
function loadUserSeatLayout(roundId) {
    $.get(contextPath + '/admin/roundseat/list', { round_id: roundId }, function(list) {
        renderUserSeatMap(list);
    });
}

// [3] 좌석 맵 렌더링 (층 표시 + 구역 표시 + 상태 로직 통합)
function renderUserSeatMap(seatList) {
    const $container = $('#seatArea').empty();
    
    // 1. 층 표시 추가 (CSS에서 z-index: 1로 설정했으므로 좌석보다 뒤에 깔림)
    $container.append('<div class="floor-label" style="top: 0px;">─── 1st FLOOR ───</div>');
    $container.append('<div class="floor-label floor-2-label" style="top: 700px;">─── 2nd FLOOR ───</div>');

    if (!seatList || seatList.length === 0) return;

    let groups = {};

    seatList.forEach(seat => {
        // ID 및 좌표 계산
        const sId = seat.round_seat_id || seat.id || seat.seat_id; 
        const colIndex = (typeof seat.seat_x === 'string') ? seat.seat_x.charCodeAt(0) - 65 : 0;
        const finalX = seat.pos_x + (colIndex * seat.col_gap);
        const finalY = seat.pos_y + ((seat.seat_y - 1) * seat.row_gap);
        
        const gradeName = (seat.grade_name || "a").toLowerCase();
        const seatName = `${seat.group_name || ""} ${seat.seat_x}열 ${seat.seat_y}번`;

        // 구역 경계선 데이터 수집
        if (!groups[seat.seat_group_id]) {
            groups[seat.seat_group_id] = {
                name: seat.group_name || '구역',
                minX: Infinity, minY: Infinity, maxX: -Infinity, maxY: -Infinity
            };
        }
        const g = groups[seat.seat_group_id];
        if (finalX < g.minX) g.minX = finalX; if (finalY < g.minY) g.minY = finalY;
        if (finalX > g.maxX) g.maxX = finalX; if (finalY > g.maxY) g.maxY = finalY;

        // 좌석 엘리먼트 생성
        const $seat = $('<div class="admin-seat"></div>')
            .attr({ 
                'data-seat-id': String(sId), 
                'data-grade': gradeName, 
                'data-name': seatName 
            })
            .css({ left: finalX + 'px', top: finalY + 'px' });

        // 상태별 이미지 적용
        const status = seat.status || seat.is_reserved; 
        if (status === 'RESERVED' || status === 'CANCELED' || status === 'Y') {
            $seat.addClass('reserved').css('background-image', `url(${contextPath}/static/assets/seatImg/sold.jpg)`);
        } else if (status === 'PREEMPTED' || status === 'P') {
            $seat.addClass('preempted').css('background-image', `url(${contextPath}/static/assets/seatImg/preempted.jpg)`);
        } else {
            const imgSuffix = gradeName.includes('vip') ? 'vip' : gradeName[0];
            $seat.addClass('available').css('background-image', `url(${contextPath}/static/assets/seatImg/available_${imgSuffix}.jpg)`);
        }
        $container.append($seat);
    });

    // 2. 구역 경계선 렌더링
    Object.keys(groups).forEach(id => {
        const g = groups[id];
        $('<div class="group-boundary-box"></div>')
            .css({ 
                left: (g.minX - 15) + 'px', 
                top: (g.minY - 15) + 'px', 
                width: (g.maxX - g.minX + 55) + 'px', 
                height: (g.maxY - g.minY + 55) + 'px' 
            })
            .append($('<div class="group-name-label"></div>').text(g.name))
            .appendTo($container);
    });
}

// [4] 좌석 선택 토글
function toggleUserSeatSelection($el) {
    const seatId = $el.attr('data-seat-id');
    const grade = $el.attr('data-grade');
    const seatName = $el.attr('data-name');
    const price = USER_PRICE_MAP[grade] || 0;

    if (!seatId || seatId === "undefined") return;

    const index = window.userReserveIds.indexOf(seatId);

    if (index > -1) {
        window.userReserveIds.splice(index, 1);
        window.userReserveObjs.splice(index, 1);
        $el.removeClass('selected');
    } else {
        if (window.userReserveIds.length >= 4) {
            alert("최대 4좌석까지 선택 가능합니다.");
            return;
        }
        window.userReserveIds.push(seatId);
        window.userReserveObjs.push({ id: seatId, name: seatName, price: price });
        $el.addClass('selected');
    }
    
    const imgSuffix = grade.includes('vip') ? 'vip' : grade[0];
    const isSel = $el.hasClass('selected');
    const imgName = isSel ? `checked_available_${imgSuffix}.jpg` : `available_${imgSuffix}.jpg`;
    $el.css('background-image', `url(${contextPath}/static/assets/seatImg/${imgName})`);
    
    updateUserSelectionUI();
}

// [5] UI 업데이트
function updateUserSelectionUI() {
    const $list = $('#selected-seats-list');
    let totalAmount = 0;
    let html = '';

    if (window.userReserveObjs.length === 0) {
        $list.html('<p class="empty-msg">좌석을 선택해 주세요.</p>');
        $('#total-amount').text('0');
        return;
    }

    window.userReserveObjs.forEach(item => {
        html += `<div class="selected-item" style="display:flex; justify-content:space-between; padding:5px 0;">
                    <span>${item.name}</span>
                    <strong>${item.price.toLocaleString()}원</strong>
                 </div>`;
        totalAmount += item.price;
    });
    $list.html(html);
    $('#total-amount').text(totalAmount.toLocaleString());
}

// [6] 결제 페이지 이동
function goToPayment() {
    if (window.userReserveIds.length === 0) return alert("좌석을 선택해주세요.");
    $.post(`${contextPath}/ticket/reserveSeats`, {
        round_id: currentRoundId,
        seats: window.userReserveIds.join(",")
    }, function(res) {
        if (res.success) {
            location.href = `${contextPath}/ticket/payment?round_id=${currentRoundId}&seats=${window.userReserveIds.join(",")}`;
        } else {
            alert(res.message || "선택하신 좌석이 이미 선점되었습니다.");
            location.reload();
        }
    });
}