function getZeroNum(n) {
    let result = n;
    if(n < 10) {
        result = "0" + result;
    }

    return result;
}

function getCookie(key){
    cookieRow = document.cookie.split("; ")
        .find(row=>row.startsWith(key));
        
	return cookieRow ? cookieRow.split("=")[1] : null;
}

function checkAgeLimit(birthDateStr, limitAge) {
    const today = new Date();
    const birthDate = new Date(birthDateStr);

    // 1. 단순히 연도 차이 계산
    let age = today.getFullYear() - birthDate.getFullYear();

    // 2. 월/일 비교를 통해 생일이 지났는지 확인
    const monthDiff = today.getMonth() - birthDate.getMonth();
    const dayDiff = today.getDate() - birthDate.getDate();

    // 생일이 아직 안 지났다면 나이에서 1을 뺌
    if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
        age--;
    }

    console.log("계산된 만 나이:", age);
    return age >= limitAge;
}