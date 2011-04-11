var toShow = true;
	function show()
	{
		if (!toShow){
			this.hide()
		}
		else {
			var myAttr = document.createAttribute("class");
			myAttr.nodeValue = "showElem";
			var myObj = document.getElementById('offlineMode');
			myObj.setAttributeNode(myAttr);
			toShow = false;
		}
	}
	
	function hide()
	{
		var myObj = document.getElementById('offlineMode');
		myObj.setAttribute('class','hideElem');
		toShow = true;
	}