class Paging{
	constructor(pageSize = 10, blockSize = 10){
		this.pageSize = pageSize;	// 한 페이지당 보여질 레코드 수
		this.blockSize = blockSize;	// 블럭당 보여질 페이지 수 1 2 3 4 5 6 7 8 9 10
	}
	
	init(list, currentPage) {
		if (!list) return;
		
		this.totalRecord = list.length;	// 총 레코드 수
		this.totalPage = Math.ceil(this.totalRecord / this.pageSize);
		
		// 넘긴 페이지가 없으면 1페이지
		this.currentPage = parseInt(currentPage) || 1;
		
		this.firstPage = this.currentPage - (this.currentPage - 1) % this.blockSize;
		this.lastPage = this.firstPage + (this.blockSize - 1);
		
		if(this.lastPage > this.totalPage) {
			this.lastPage = this.totalPage;
		}
		
		this.curPos = (this.currentPage - 1) * this.pageSize;	// list의 시작 index
		this.num = this.totalRecord - this.curPos;					// 페이지당 시작 번호
	}
}