class MoneyConverter {
    // 자바의 NumberFormat.getInstance(Locale.KOREA)와 동일한 설정
	constructor(){
		this.krwFormat = new Intl.NumberFormat('ko-KR');
	}

    format(price) {
        return this.krwFormat.format(Number(price));
    }
}