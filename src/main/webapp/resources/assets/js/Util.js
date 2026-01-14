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