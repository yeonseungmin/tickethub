/**
 * 사용자 전용 좌석 선택 시스템 (최종 통합본)
 */
window.userReserveIds = [];      
window.userReserveObjs = [];  

const USER_PRICE_MAP = { 
    'vip': 150000, 
	'r': 120000, 'r석': 120000, 
    's': 90000, 's석': 90000,
	'a': 60000, 'a석': 60000 
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

// [3] 좌석 맵 렌더링 (층 표시 + 구역 표시 + 상태 로직 + angle 회전 통합)
function renderUserSeatMap(seatList) {
    const $container = $('#seatArea').empty();
    
    // 1. 층 표시 추가
    $container.append('<div class="floor-label" style="top: 0px;">─── 1st FLOOR ───</div>');
    $container.append('<div class="floor-label floor-2-label" style="top: 700px;">─── 2nd FLOOR ───</div>');

    if (!seatList || seatList.length === 0) return;

    let groups = {};

    // 1단계: 구역별 회전값 및 기준 위치 데이터 수집
    seatList.forEach(seat => {
        if (!groups[seat.seat_group_id]) {
            groups[seat.seat_group_id] = {
                name: seat.group_name || '구역',
                angle: seat.angle || 0,   // [추가] 회전 각도
                posX: seat.pos_x || 0,     // 구역 시작 X
                posY: seat.pos_y || 0,     // 구역 시작 Y
                maxRelX: 0,
                maxRelY: 0
            };
        }
        const g = groups[seat.seat_group_id];
        const colIndex = (typeof seat.seat_x === 'string') ? seat.seat_x.charCodeAt(0) - 65 : 0;
        const relX = colIndex * (seat.col_gap || 30);
        const relY = (seat.seat_y - 1) * (seat.row_gap || 30);

        if (relX > g.maxRelX) g.maxRelX = relX;
        if (relY > g.maxRelY) g.maxRelY = relY;
    });

    // 2단계: 구역 박스 생성 및 그 안에 좌석 배치
    Object.keys(groups).forEach(groupId => {
        const g = groups[groupId];
        
        // 구역 경계선 박스 (transform으로 회전 적용)
        const $box = $('<div class="group-boundary-box"></div>')
            .css({ 
                left: g.posX + 'px', 
                top: g.posY + 'px', 
                width: (g.maxRelX + 72) + 'px', // 여백 포함
                height: (g.maxRelY + 72) + 'px',
                position: 'absolute',
                // [핵심] 회전값 적용
                transform: `rotate(${g.angle}deg)`,
                'transform-origin': '0 0'
            });

        $box.append($('<div class="group-name-label"></div>').text(g.name));
        $container.append($box);

        // 해당 구역에 속한 좌석들만 필터링하여 박스 내부(Relative)에 배치
        seatList.filter(s => s.seat_group_id == groupId).forEach(seat => {
            const sId = seat.round_seat_id || seat.id || seat.seat_id; 
            const colIndex = (typeof seat.seat_x === 'string') ? seat.seat_x.charCodeAt(0) - 65 : 0;
            
            // 박스 내부 기준 상대 좌표 (+20은 박스 테두리와의 여백)
            const innerX = (colIndex * (seat.col_gap || 30)) + 20;
            const innerY = ((seat.seat_y - 1) * (seat.row_gap || 30)) + 20;
            
            const gradeName = (seat.grade_name || "a").toLowerCase();
            const seatName = `${seat.group_name || ""} ${seat.seat_x}열 ${seat.seat_y}번`;

            const $seat = $('<div class="admin-seat"></div>')
                .attr({ 
                    'data-seat-id': String(sId), 
                    'data-grade': gradeName, 
                    'data-name': seatName 
                })
                .css({ 
                    left: innerX + 'px', 
                    top: innerY + 'px',
                    position: 'absolute' 
                });

            // 상태별 이미지 및 클래스 적용 로직 유지
            const status = seat.status || seat.is_reserved; 
            if (status === 'RESERVED' || status === 'CANCELED' || status === 'Y') {
                $seat.addClass('reserved').css('background-image', `url(${contextPath}/static/assets/seatImg/sold.jpg)`);
            } else if (status === 'PREEMPTED' || status === 'P') {
                $seat.addClass('preempted').css('background-image', `url(${contextPath}/static/assets/seatImg/preempted.jpg)`);
            } else {
                const imgSuffix = gradeName.includes('vip') ? 'vip' : gradeName[0];
                $seat.addClass('available').css('background-image', `url(${contextPath}/static/assets/seatImg/available_${imgSuffix}.jpg)`);
            }
            
            // [중요] $container가 아닌 $box에 추가해야 함께 회전합니다.
            $box.append($seat);
        });
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