/* 상품 이미지를 선택하면, 해당 상품이미지를 화면에 미리보기 기능 구현을 위한 클래스 정의 */
class PreviewImg{
	constructor(container, file, src, width, height){
		this.container = container;
		this.file = file;	// 자바 스크립트 배열 내에서 이 파일이 몇 번째에 들어있는지 조사하기 위한 용도로 File을 넘겨받아 보관해놓자!!
		this.src = src;
		this.width = width;
		this.height = height;
		
		
		this.wrapper = document.createElement("div");
		this.header = document.createElement("div");
		this.img = document.createElement("img");
		this.img.src = this.src;
		
		// style
		this.img.style.width = this.width + "px";
		this.img.style.height = this.height + "px";
		
		this.wrapper.style.width = (this.width + 10) + "px";
		this.wrapper.style.height = (this.height + 30) + "px";
		this.wrapper.style.display = "inline-block";		// 너비, 높이 등의 블락요소의 특징을 유지하면서, 다른 요소와 수평선상에 공존하게 하려고
		this.wrapper.style.margin = 5 + "px";
		this.wrapper.style.border = "1px solid red";
		this.wrapper.style.borderRadius = "5px";
		this.wrapper.style.textAlign = "center";
		
		this.header.innerHTML = "<a href='#'>X</a>";
		this.header.style.textAlign = "right";
		
		// 조립
		this.wrapper.appendChild(this.header);
		this.wrapper.appendChild(this.img);
		this.container.appendChild(this.wrapper);
		
		// X자에 이벤트 연결
		this.header.addEventListener("click", (e)=>{
			console.log("지울거야?");
			// 링크를 누를 때마다 스크롤이 자꾸 원상태로 돌아오는 현상의 이유?
			// a tag를 사용자가 클릭하면 기본적으로 y축을 0으로 위치시키는 특징때문임..
			// 해결책? 기본 특징을 제거하자
			e.preventDefault();		// a태그에 의해 스크롤 위로 이동하는 현상 방지
			
			this.remove();
		});
	}
	
	// 삭제 메서드
	remove(){
		// product-preview 컨테이너 안에 있는 나의 wrapper를 지운다!
		this.container.removeChild(this.wrapper);		// 화면에서 제거 성공
		
		// 화면에서 제거되었다고 안심하면 안 된다!
		// 이유? 제거된 최종 결과를 결국 서버로 전송할 것이므로, 화면에서 제거했다면 원본 배열도 함께 제거해야 한다.
		selectedFile.splice(1, selectedFile.indexOf(this.file));
		console.log("제거 후 파일 ", selectedFile);
	}
}