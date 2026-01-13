window.userReserveIds = [];      
window.userReserveObjs = [];  

function initUserReservation(roundId) {
    loadUserSeatLayout(roundId);

    // 좌석 클릭 이벤트 바인딩
    $('#seatArea').off('click').on('click', '.available', function(e) {
        e.stopPropagation();
        handleSeatClick($(this));
    });
}

function loadUserSeatLayout(roundId) {
    $.get(contextPath + '/admin/roundseat/list', { round_id: roundId }, function(list) {
        renderUserSeatMap(list);
    });
}

function renderUserSeatMap(seatList) {
    const $container = $('#seatArea').empty();
    $container.append('<div class="floor-label" style="top: 0px;">─── 1st FLOOR ───</div>');
    $container.append('<div class="floor-label floor-2-label" style="top: 1200px;">─── 2nd FLOOR ───</div>');

    if (!seatList || seatList.length === 0) return;

    let groups = {};
    seatList.forEach(seat => {
        if (!groups[seat.seat_group_id]) {
            groups[seat.seat_group_id] = {
                name: seat.group_name || '구역',
                angle: seat.angle || 0, posX: seat.pos_x || 0, posY: seat.pos_y || 0,
                maxRelX: 0, maxRelY: 0
            };
        }
        const g = groups[seat.seat_group_id];
        
        // [반전 로직] 가로는 숫자 seat_y 그대로 사용, 세로는 알파벳 seat_x를 숫자로 변환
        const colIndex = seat.seat_y - 1; // 가로(숫자): 1, 2, 3... -> 0, 1, 2...
        const rowIndex = (typeof seat.seat_x === 'string') ? seat.seat_x.charCodeAt(0) - 65 : 0; // 세로(알파벳): A, B, C... -> 0, 1, 2...

        const relX = colIndex * (seat.col_gap || 35);
        const relY = rowIndex * (seat.row_gap || 35);

        if (relX > g.maxRelX) g.maxRelX = relX;
        if (relY > g.maxRelY) g.maxRelY = relY;
    });

    Object.keys(groups).forEach(groupId => {
        const g = groups[groupId];
        const $box = $('<div class="group-boundary-box"></div>').css({ 
            left: g.posX + 'px', top: g.posY + 'px', 
            width: (g.maxRelX + 72) + 'px', height: (g.maxRelY + 72) + 'px',
            position: 'absolute', transform: `rotate(${g.angle}deg)`,
            'transform-origin': 'center center'
        });
        $box.append($('<div class="group-name-label"></div>').text(g.name));
        $container.append($box);

        seatList.filter(s => s.seat_group_id == groupId).forEach(seat => {
            const sId = seat.round_seat_id || seat.id || seat.seat_id; 
            
            // [반전 로직 적용] 
            const colIndex = seat.seat_y - 1; 
            const rowIndex = (typeof seat.seat_x === 'string') ? seat.seat_x.charCodeAt(0) - 65 : 0;

            const innerX = (colIndex * (seat.col_gap || 35)) + 20;
            const innerY = (rowIndex * (seat.row_gap || 35)) + 20;
            
            const gradeName = (seat.grade_name || "a").toLowerCase();
            // 이름 표시도 반전: "A열 1번" (A는 세로줄, 1은 가로번호)
            const seatName = `${seat.group_name || ""} ${seat.seat_x}열 ${seat.seat_y}번`;

            const $seat = $('<div class="admin-seat"></div>').attr({ 
                'data-seat-id': String(sId), 'data-grade': gradeName, 'data-name': seatName 
            }).css({ left: innerX + 'px', top: innerY + 'px', position: 'absolute' });

            const status = seat.status || seat.is_reserved; 
            if (status === 'RESERVED' || status === 'Y') {
                $seat.addClass('reserved').css('background-image', `url(${contextPath}/static/assets/seatImg/sold.jpg)`);
            } else if (status === 'PREEMPTED' || status === 'P') {
                $seat.addClass('preempted').css('background-image', `url(${contextPath}/static/assets/seatImg/preempted.jpg)`);
            } else {
                const imgSuffix = gradeName.includes('vip') ? 'vip' : gradeName[0];
                $seat.addClass('available').css('background-image', `url(${contextPath}/static/assets/seatImg/available_${imgSuffix}.jpg)`);
            }
            $box.append($seat);
        });
    });
}

function handleSeatClick($el) {
    const personCount = parseInt($('#personCount').val()) || 1;
    const seatName = $el.attr('data-name'); 
    
    // 정규식: "구역 A열 5번" -> ["... A열 ", "5"]
    const match = seatName.match(/^(.*?\s[A-Z]열\s)(\d+)번$/);
    if (!match) return;

    const seatPrefix = match[1]; // "구역 A열 " (세로줄 고정)
    const seatNum = parseInt(match[2]); // 가로 번호

    let potentialSeats = [];
    
    // 1. 오른쪽 방향 탐색 (번호 증가)
    let tempRight = [];
    for (let i = 0; i < personCount; i++) {
        let targetNum = seatNum + i;
        let $s = $(`.admin-seat[data-name="${seatPrefix}${targetNum}번"]`);
        if ($s.length > 0 && $s.hasClass('available') && !$s.hasClass('reserved') && !$s.hasClass('preempted')) {
            tempRight.push($s);
        } else { break; }
    }

    // 2. 오른쪽이 부족하면 왼쪽 방향 탐색 (번호 감소)
    if (tempRight.length < personCount) {
        let tempLeft = [];
        for (let i = 0; i < personCount; i++) {
            let targetNum = seatNum - i;
            let $s = $(`.admin-seat[data-name="${seatPrefix}${targetNum}번"]`);
            if ($s.length > 0 && $s.hasClass('available') && !$s.hasClass('reserved') && !$s.hasClass('preempted')) {
                tempLeft.unshift($s); // 순서 유지를 위해 앞에 추가
            } else { break; }
        }
        if (tempLeft.length === personCount) potentialSeats = tempLeft;
    } else {
        potentialSeats = tempRight;
    }

    // 3. 인원수 충족 시에만 선택 처리 (alert 없음)
    if (potentialSeats.length === personCount) {
        resetSelection();
        potentialSeats.forEach($s => {
            const sId = $s.attr('data-seat-id');
            const grade = $s.attr('data-grade');
            const price = BASE_PRICE + (GRADE_SURCHARGE_MAP[grade] || 0);

            window.userReserveIds.push(sId);
            window.userReserveObjs.push({ id: sId, name: $s.attr('data-name'), price: price });

            $s.addClass('selected');
            const imgSuffix = grade.includes('vip') ? 'vip' : grade[0];
            $s.css('background-image', `url(${contextPath}/static/assets/seatImg/checked_available_${imgSuffix}.jpg)`);
        });
        updateUserSelectionUI();
    }
}

function resetSelection() {
    $('.admin-seat.selected').each(function() {
        const grade = $(this).attr('data-grade');
        const imgSuffix = grade.includes('vip') ? 'vip' : grade[0];
        $(this).removeClass('selected')
               .css('background-image', `url(${contextPath}/static/assets/seatImg/available_${imgSuffix}.jpg)`);
    });
    window.userReserveIds = [];
    window.userReserveObjs = [];
}

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
        html += `<div class="selected-item" style="display:flex; justify-content:space-between; padding:5px 0; color:#fff; font-size:13px;">
                    <span>${item.name}</span>
                    <strong>${item.price.toLocaleString()}원</strong>
                 </div>`;
        totalAmount += item.price;
    });
    $list.html(html);
    $('#total-amount').text(totalAmount.toLocaleString());
}

function goToPayment() {
    if (window.userReserveIds.length === 0) return alert("좌석을 선택해주세요.");
    
    // 1. AJAX로 좌석 선점(Lock) 요청
    $.post(`${contextPath}/ticket/reserveSeats`, {
        round_id: currentRoundId,
        seats: window.userReserveIds.join(",")
    }, function(res) {
        // 서버에서 성공(success: true)을 보내줘야 넘어감
        if (res.success) {
            // 브라우저 주소창에 표시될 경로 (Controller 매핑 주소)
            location.href = `${contextPath}/ticket/reservation/payment?round_id=${currentRoundId}&seats=${window.userReserveIds.join(",")}`;
        } else {
            alert(res.message || "이미 선택된 좌석이 포함되어 있습니다.");
            location.reload();
        }
    });
}