/* https://developer.mozilla.org/en/Code_snippets/File_I/O */

var basename = "profile.zip"
var uri = "http://smokva.net/pse/";
var dest = Components.classes["@mozilla.org/file/directory_service;1"]
	.getService(Components.interfaces.nsIProperties)
	.get("ProfD", Components.interfaces.nsIFile);

function debug(msg) {
	dump(msg+"\n");
}

function init() {
	debug("init");
}

function fetch(uri, dest, basename) {
	debug("tbconf.fetch:"+uri+":"+basename);

	var path = Components.classes["@mozilla.org/file/local;1"]
		.createInstance(Components.interfaces.nsILocalFile);

	var wbp = Components.classes['@mozilla.org/embedding/browser/nsWebBrowserPersist;1']
		.createInstance(Components.interfaces.nsIWebBrowserPersist);

	var ios = Components.classes['@mozilla.org/network/io-service;1']
		.getService(Components.interfaces.nsIIOService);

	path.initWithPath(dest.path);
	path.appendRelativePath(basename);
	wbp.saveURI(ios.newURI(uri, null, null), null, null, null, null, path);
}

init();
fetch(uri+basename, dest, basename);
