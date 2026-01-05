function getZeroNum(n) {
    let result = n;
    if(n < 10) {
        result = "0" + result;
    }

    return result;
}

function getNum(n){
	let result = parseInt(n);
	
	return result;
}