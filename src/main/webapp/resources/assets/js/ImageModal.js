function displayImageModal(parentClass, src){
	
	tag = `
		<div id="myModal" class="modal">
		  <span class="close">&times;</span>
		  <img class="modal-content" id="img01">
		  <div id="caption"></div>
		</div>
	`
	if(document.getElementById("myModal") == null){
		document.getElementsByClassName(parentClass)[0].innerHTML += tag;
	}
	
	// Get the modal
	var modal = document.getElementById("myModal");
	
	// Get the image and insert it inside the modal - use its "alt" text as a caption
	var img = document.getElementById("myImg");
	var modalImg = document.getElementById("img01");
	
	  modal.style.display = "block";
	  modalImg.src = src;
	
	// Get the <span> element that closes the modal
	var span = document.getElementsByClassName("close")[0];
	
	// When the user clicks on <span> (x), close the modal
	span.onclick = function() { 
	  modal.style.display = "none";
	}
	
	
}
