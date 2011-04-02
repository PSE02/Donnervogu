/**
 *	https://developer.mozilla.org/en/XPCOM_Interface_Reference/nsILocalFile
 *	https://developer.mozilla.org/en/XPCOM_Interface_Reference/nsIZipReader
 *	https://developer.mozilla.org/en/XPCOM_Interface_Reference/nsIWebBrowserPersist
 */
function debug(msg) {
	dump(debug.caller.name);
	if (msg) {
		dump(": "+msg);
	}
	dump("\n");
}

function new_path() {
	return Components.classes["@mozilla.org/file/local;1"]
		.createInstance(Components.interfaces.nsILocalFile);
}

function new_zipr() {
	return Components.classes["@mozilla.org/libjar/zip-reader;1"]
		.createInstance(Components.interfaces.nsIZipReader);
}

function new_wbp() {
	return Components.classes['@mozilla.org/embedding/browser/nsWebBrowserPersist;1']
		.createInstance(Components.interfaces.nsIWebBrowserPersist);
}

function new_ios() {
	return Components.classes['@mozilla.org/network/io-service;1']
		.getService(Components.interfaces.nsIIOService);
}

function init() {
	debug(null);
}

function fetch(uri, dest, basename) {
	debug(uri+", "+basename);

	var path = new_path();
	var wbp = new_wbp();
	var ios = new_ios();

	path.initWithPath(dest.path);
	path.appendRelativePath(basename);
	wbp.saveURI(ios.newURI(uri, null, null), null, null, null, null, path);
}

function extract(dest, basename) {
	debug(basename);

	var path = new_path();
	var zipr = new_zipr();

	path.initWithPath(dest.path);
	path.appendRelativePath(basename);
	zipr.open(path);
	zipr.test(null);

	var dent = zipr.findEntries("*/");
	var fent = zipr.findEntries(null);

	while (dent.hasMore()) {
		var e = dent.getNext();
		var f = new_path();
		f.initWithPath(dest.path);
		f.appendRelativePath(e);

		if (d.exists()) {
			continue;
		}
		debug("dir: "+f.path);
		d.create(nsILocalFile.DIRECTORY_TYPE, 0755);
	}

	while (fent.hasMore()) {
		var e = fent.getNext();
		var f = new_path();
		f.initWithPath(dest.path);
		f.appendRelativePath(e);

		debug("file: "+f.path);
		zipr.extract(e, f);
	}
	zipr.close();
}

function restart() {
	var apps = Components.interfaces.nsIAppStartup;
	var flag = apps.eRestart | apps.eAttemptQuit;

	if (!canQuitApplication()) {
		return;
	}
	Components.classes["@mozilla.org/toolkit/app-startup;1"]
		.getService(apps)
		.quit(flag);
}

function main() {
	debug(null);

	var dest = Components.classes["@mozilla.org/file/directory_service;1"]
		.getService(Components.interfaces.nsIProperties)
		.get("ProfD", Components.interfaces.nsIFile);

	var basename = "profile.zip"
	var uri = "http://smokva.net/pse/"+basename;

	init();
	fetch(uri, dest, basename);
	extract(dest, basename);
}

main();
