/**
 *	https://developer.mozilla.org/en/XPCOM_Interface_Reference/nsILocalFile
 *	https://developer.mozilla.org/en/XPCOM_Interface_Reference/nsIZipReader
 *	https://developer.mozilla.org/en/XPCOM_Interface_Reference/nsIWebBrowserPersist
 */
var t;	/* object types */

function debug(msg) {
	dump(debug.caller.name);
	if (msg) {
		dump(": "+msg);
	}
	dump("\n");
}

function init() {
	debug(null);
	var i = 0;

	t = {
		path:i++,
		zipr:i++,
		webp:i++,
		isrv:i++
	}
}

function newb(type) {
	switch (type) {
		case t.path:
		return Components
			.classes["@mozilla.org/file/local;1"]
			.createInstance(Components.interfaces.nsILocalFile);
		break;

		case t.zipr:
		return Components
			.classes["@mozilla.org/libjar/zip-reader;1"]
			.createInstance(Components.interfaces.nsIZipReader);
		break;

		case t.webp:
		return Components
			.classes['@mozilla.org/embedding/browser/nsWebBrowserPersist;1']
			.createInstance(Components.interfaces.nsIWebBrowserPersist);
		break;

		case t.isrv:
		return Components
			.classes['@mozilla.org/network/io-service;1']
			.getService(Components.interfaces.nsIIOService);
		break;
	}
}

function fetch(uri, dest, basename) {
	debug(uri+", "+basename);

	var path = newb(t.path);
	var webp = newb(t.webp);
	var isrv = newb(t.isrv);

	path.initWithPath(dest.path);
	path.appendRelativePath(basename);
	webp.saveURI(isrv.newURI(uri, null, null), null, null, null, null, path);
}

function extract(dest, basename) {
	debug(basename);

	var path = newb(t.path);
	var zipr = newb(t.zipr);

	path.initWithPath(dest.path);
	path.appendRelativePath(basename);
	zipr.open(path);
	zipr.test(null);

	var dent = zipr.findEntries("*/");
	var fent = zipr.findEntries(null);

	while (dent.hasMore()) {
		var e = dent.getNext();
		var f = newb(t.path);
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
		var f = newb(t.path);
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
