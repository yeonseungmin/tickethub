window.userReserveIds = [];      
window.userReserveObjs = [];  

function initUserReservation(roundId) {
	window.userReserveIds = []; 	// 캐쉬 문제로 한번도 초기화
	window.userReserveObjs = [];	// 캐쉬 문제로 한번도 초기화
    loadUserSeatLayout(roundId);

    // 좌석 클릭 이벤트 바인딩
    $('#seatArea').off('click').on('click', '.available', function(e) {
        e.stopPropagation();
        handleSeatClick($(this));
    });
}

/* ==========================================
   1. 좌석 레이아웃 로드 및 렌더링
   ========================================== */
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

    // 구역(Group)별 데이터 정리
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
        
        const colIndex = seat.seat_y - 1; 
        const rowIndex = (typeof seat.seat_x === 'string') ? seat.seat_x.charCodeAt(0) - 65 : 0;

        const relX = colIndex * (seat.col_gap || 35);
        const relY = rowIndex * (seat.row_gap || 35);

        if (relX > g.maxRelX) g.maxRelX = relX;
        if (relY > g.maxRelY) g.maxRelY = relY;
    });

    // 구역 및 좌석 그리기
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
            // [보강 1] 우선순위를 확실히 정함: round_seat_id가 0이거나 null이면 seat_id를 쓰는 것이 아니라 에러 로그를 남겨야 함
            const rSeatId = seat.round_seat_id || seat.roundSeatId; 
            
            const colIndex = seat.seat_y - 1; 
            const rowIndex = (typeof seat.seat_x === 'string') ? seat.seat_x.charCodeAt(0) - 65 : 0;

            const innerX = (colIndex * (seat.col_gap || 35)) + 20;
            const innerY = (rowIndex * (seat.row_gap || 35)) + 20;
            
            const gradeName = (seat.grade_name || "a").toLowerCase();
            const seatName = `${seat.group_name || ""} ${seat.seat_x}열 ${seat.seat_y}번`;

            // [보강 2] data-round-seat-id 속성을 명확히 함
            // 만약 rSeatId가 제대로 안넘어오면 여기서 좌석 태그 생성이 엉망이 되므로 확인용 로그 추가 가능
            const $seat = $('<div class="admin-seat"></div>').attr({ 
                'data-round-seat-id': String(rSeatId), 
                'data-grade': gradeName, 
                'data-name': seatName 
            }).css({ left: innerX + 'px', top: innerY + 'px', position: 'absolute' });

            const status = seat.status; 
            
            // [보강 3] 상태값 체크 로직 강화 (AVAILABLE인 경우만 클래스 부여)
            if (status === 'RESERVED' || status === 'Y') {
                $seat.addClass('reserved').css('background-image', `url(${contextPath}/static/assets/seatImg/sold.jpg)`);
            } else if (status === 'PREEMPTED' || status === 'P') {
                $seat.addClass('preempted').css('background-image', `url(${contextPath}/static/assets/seatImg/preempted.jpg)`);
            } else if (status === 'AVAILABLE') {
                const imgSuffix = gradeName.includes('vip') ? 'vip' : gradeName[0];
                $seat.addClass('available').css('background-image', `url(${contextPath}/static/assets/seatImg/available_${imgSuffix}.jpg)`);
            } else {
                // 알 수 없는 상태일 경우 기본 available 처리
                $seat.addClass('available').css('background-image', `url(${contextPath}/static/assets/seatImg/available_a.jpg)`);
            }
            $box.append($seat);
        });
    });
}

/* ==========================================
   2. 좌석 클릭 핸들러 (인원수 맞춤 선택)
   ========================================== */
   function handleSeatClick($el) {
       const personCount = parseInt($('#personCount').val()) || 1;
       const seatName = $el.attr('data-name'); 
       
       // 1. 인접 좌석 탐색을 위한 정규식
       const match = seatName.match(/^(.*?\s[A-Z]열\s)(\d+)번$/);
       if (!match) return;
       const seatPrefix = match[1];
       const seatNum = parseInt(match[2]);

       let potentialSeats = [];
       let tempRight = [];
       for (let i = 0; i < personCount; i++) {
           let targetNum = seatNum + i;
           let $s = $(`.admin-seat[data-name="${seatPrefix}${targetNum}번"]`);
           if ($s.length > 0 && $s.hasClass('available')) {
               tempRight.push($s);
           } else { break; }
       }
       
       if (tempRight.length < personCount) {
           let tempLeft = [];
           for (let i = 0; i < personCount; i++) {
               let targetNum = seatNum - i;
               let $s = $(`.admin-seat[data-name="${seatPrefix}${targetNum}번"]`);
               if ($s.length > 0 && $s.hasClass('available')) {
                   tempLeft.unshift($s);
               } else { break; }
           }
           if (tempLeft.length === personCount) potentialSeats = tempLeft;
       } else {
           potentialSeats = tempRight;
       }

       // 2. 선택 처리 (핵심 데이터 추출)
       if (potentialSeats.length === personCount) {
           resetSelection(); // 전역 배열 window.userReserveIds = [] 초기화 포함
           
           potentialSeats.forEach($s => {
               // [중요!] data-seat-id가 아니라 renderUserSeatMap에서 넣은 data-round-seat-id를 가져옵니다.
               const rSeatId = $s.attr('data-round-seat-id'); 
               const grade = String($s.attr('data-grade')).trim().toLowerCase();

               // 등급별 할증료 계산
               let surcharge = 0;
               if (grade === 'vip') surcharge = 100000;
               else if (grade === 'r') surcharge = 50000;
               else if (grade === 's') surcharge = 30000;
               else surcharge = 10000;

               const price = BASE_PRICE + surcharge;

               // [확인] 전역 배열에 round_seat_id(4000번대)를 push
               if (rSeatId && rSeatId !== "undefined") {
                   window.userReserveIds.push(rSeatId);
                   window.userReserveObjs.push({ id: rSeatId, name: $s.attr('data-name'), price: price });
                   
                   // 브라우저 콘솔에 강제로 찍어봅니다.
                   console.log("✅ 좌석 선택됨! PK 확인 ->", rSeatId);
               } else {
                   console.error("❌ 에러: round_seat_id를 찾을 수 없습니다! HTML 구조를 확인하세요.");
               }

               $s.addClass('selected');
               let imgFile = (grade === 'vip') ? "checked_available_vip.jpg" : "checked_available_" + grade.charAt(0) + ".jpg";
               $s.css('background-image', 'url(' + contextPath + '/static/assets/seatImg/' + imgFile + ')');
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

/**
 * 결제하기 버튼 클릭 시 실행
 */
function goToPayment() {
    // [수정] URL에서 round_id 파라미터를 강제로 추출해서 undefined 방지
    const urlParams = new URLSearchParams(window.location.search);
    const rId = urlParams.get('round_id') || "12"; 
    
    if (!window.userReserveIds || window.userReserveIds.length === 0) {
        alert("좌석을 선택해주세요.");
        return;
    }

    const params = {
        round_id: rId,
        seats: window.userReserveIds.join(",")
    };

    console.log("최종 전송 데이터:", params);

    // [중요] contextPath가 포함된 정확한 경로 확인
    // 네트워크 로그에 reserveSeats가 찍혔으므로 경로는 비슷하지만 302가 문제임
    const url = contextPath + "/ticket/reservation/reserveSeats";
    
    $.ajax({
        url: url,
        type: 'POST',
        data: params,
        success: function(res) {
            console.log("서버 응답:", res);
            if (res.success) {
                // 성공 시 이동 (데이터 보존을 위해 params 사용)
                location.href = contextPath + "/ticket/reservation/payment?round_id=" + rId + "&seats=" + params.seats;
            } else {
                alert(res.message || "이미 선택된 좌석이 포함되어 있습니다.");
                location.reload();
            }
        },
        error: function(xhr) {
            // 여기서 302 리다이렉트가 발생하면 에러 블록으로 올 수 있음
            console.error("통신 에러:", xhr.status);
            if(xhr.status === 302 || xhr.status === 0) {
                alert("세션이 만료되었거나 접근 권한이 없습니다. 다시 로그인해주세요.");
            } else {
                alert("서버 통신 중 오류가 발생했습니다.");
            }
        }
    });
}