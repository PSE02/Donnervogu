
function downloadFile(httpLoc) {

	// get profile directory
	var file = Components.classes["@mozilla.org/file/directory_service;1"].
        getService(Components.interfaces.nsIProperties).
        get("ProfD", Components.interfaces.nsIFile);
	var profilePath = file.path;
	
	// change profile directory to native style
	profilePath = profilePath.replace(/\\/gi , "\\\\");
	profilePath = profilePath.toLowerCase();
	// download the zip file
	try {
    //new obj_URI object
    var obj_URI = Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService).newURI(httpLoc, null, null);
    //new file object
    var obj_TargetFile = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);
    //set to download the zip file into the profil direct
    obj_TargetFile.initWithPath(profilePath + "\\\\" + "test.zip");
    //if file the zip file doesn't exist, create it
    if(!obj_TargetFile.exists()) {
	alert("zip file wird erstellt");
    obj_TargetFile.create(0x00,0644);
    }
     //new persitence object
    var obj_Persist = Components.classes["@mozilla.org/embedding/browser/nsWebBrowserPersist;1"].createInstance(Components.interfaces.nsIWebBrowserPersist);
 
    // with persist flags if desired ??
    const nsIWBP = Components.interfaces.nsIWebBrowserPersist;
    const flags = nsIWBP.PERSIST_FLAGS_REPLACE_EXISTING_FILES;
    obj_Persist.persistFlags = flags | nsIWBP.PERSIST_FLAGS_FROM_CACHE;
 
    //save file to target
    obj_Persist.saveURI(obj_URI,null,null,null,null,obj_TargetFile);
  } catch (e) {
    alert(e);
  }
	// unzip the user.js file to the profile direc
    
	// creat a zipReader, open the zip file
	var zipReader = Components.classes["@mozilla.org/libjar/zip-reader;1"]
                .createInstance(Components.interfaces.nsIZipReader);
	zipReader.open(obj_TargetFile);	

	//new file object, thats where the user.js will be extracted
    var obj_UnzipTarget = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);
 
    //set path for the user.js
	obj_UnzipTarget.initWithPath(profilePath + "\\\\" + "user.js");
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
    downloadFile("http://pse2.iam.unibe.ch/profiles/profile.zip");
  },
};

 


