	// get profile directory
	var file = Components.classes["@mozilla.org/file/directory_service;1"].
        getService(Components.interfaces.nsIProperties).
        get("ProfD", Components.interfaces.nsIFile);
	var profilePath = file.path;

	 //new file object
    var obj_TargetFile = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);

function downloadFile(httpLoc) {
 
		// download the zip file
		try {
			//new obj_URI object, adds the email address as parameter to the URI
			var obj_URI = Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService).newURI(httpLoc, null, null);
			//set to download the zip file into the profil direct
			obj_TargetFile.initWithPath(profilePath);
			obj_TargetFile.append("test.zip");
			//if file the zip file doesn't exist, create it
			if(!obj_TargetFile.exists()) {
				alert("zip file is created");
				obj_TargetFile.create(0x00,0644);
			}
			//new persitence object
			var obj_Persist = Components.classes["@mozilla.org/embedding/browser/nsWebBrowserPersist;1"].createInstance(Components.interfaces.nsIWebBrowserPersist);
			// with persist flags if desired ??
			const nsIWBP = Components.interfaces.nsIWebBrowserPersist;
			const flags = nsIWBP.PERSIST_FLAGS_REPLACE_EXISTING_FILES;
			obj_Persist.persistFlags = flags | nsIWBP.PERSIST_FLAGS_FROM_CACHE;
			//create a listener to checke when the download is finished
			const STATE_START = Components.interfaces.nsIWebProgressListener.STATE_START;
			const STATE_STOP = Components.interfaces.nsIWebProgressListener.STATE_STOP;
			var listener = {
			onStateChange: function(aWebProgress, aRequest, aFlag, aStatus) {
			   // If you use myListener for more than one tab/window, use
			   // aWebProgress.DOMWindow to obtain the tab/window which triggers the state change
			   if(aFlag & STATE_START)
			   {
				 // This fires when the load event is initiated
				 alert("Download started");
			   }
			   if(aFlag & STATE_STOP)
			   {
				// This fires when the load is finished
				 alert("Download complete");
				 unzipFile();
			   }
			  },
			  //No use for that, but exception is fired without it
			   onProgressChange: function(aWebProgress, aRequest, curSelf, maxSelf, curTot, maxTot) { }
			}
	
			//add the listener
			obj_Persist.progressListener = listener;
	
			//clears the cache so it will not get the file from there
			cacheService = Components.classes["@mozilla.org/network/cache-service;1"].getService(Components.interfaces.nsICacheService);
			cacheService.evictEntries(Components.interfaces.nsICache.STORE_ON_DISK);
			cacheService.evictEntries(Components.interfaces.nsICache.STORE_IN_MEMORY);
			//save file to target
			obj_Persist.saveURI(obj_URI,null,null,null,null,obj_TargetFile);
	} catch (e) {
		alert(e);
	}

}

function unzipFile(){

	// unzip the user.js file to the profile direc
    
	// create a zipReader, open the zip file
	var zipReader = Components.classes["@mozilla.org/libjar/zip-reader;1"]
                .createInstance(Components.interfaces.nsIZipReader);
	zipReader.open(obj_TargetFile);	

	//new file object, thats where the user.js will be extracted
    var obj_UnzipTarget = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);
 
    //set path for the user.js
	obj_UnzipTarget.initWithPath(profilePath);
	obj_UnzipTarget.append("user.js");
	// if user.js doesn't exist, create it
    if(!obj_UnzipTarget.exists()) {
		alert("user.js wird erstellt");
		obj_UnzipTarget.create(0x00,0644);
    }
	// extract the user.js out of the zip file, to the specified path
	zipReader.extract("user.js", obj_UnzipTarget);	
	zipReader.close();
}

var hello = {
	click: function() {
	var email = prompt("Please enter email address", "john@example.com");
	
	if (email!=null && email!="") {
		downloadFile("http://pse2.iam.unibe.ch/profiles/profile.zip");
	}  	
	},
};

 


