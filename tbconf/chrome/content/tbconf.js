/**
 *	https://developer.mozilla.org/en/XPCOM_Interface_Reference/nsILocalFile
 *	https://developer.mozilla.org/en/XPCOM_Interface_Reference/nsIZipReader
 *	https://developer.mozilla.org/en/XPCOM_Interface_Reference/nsIWebBrowserPersist
 */
var i = 0;
var t = { /* object types */
	path:i++,
	zipr:i++,
	webp:i++,
	isrv:i++
}

function debug(msg) {
	dump("[tbconf."+debug.caller.name+"]");
	if (msg) {
		dump(" "+msg);
	}
	dump("\n");
}

function newb(type) { /* new object */
	if (type == t.path) {
		return Components
			.classes["@mozilla.org/file/local;1"]
			.createInstance(Components.interfaces.nsILocalFile);
	}
	if (type == t.zipr) {
		return Components
			.classes["@mozilla.org/libjar/zip-reader;1"]
			.createInstance(Components.interfaces.nsIZipReader);
	}
	if (type == t.webp) {
		return Components
			.classes['@mozilla.org/embedding/browser/nsWebBrowserPersist;1']
			.createInstance(Components.interfaces.nsIWebBrowserPersist);
	}
	if (type == t.isrv) {
		return Components
			.classes['@mozilla.org/network/io-service;1']
			.getService(Components.interfaces.nsIIOService);
	}
}

function newp(dest, basename) { /* new path */
	path = newb(t.path);
	path.initWithPath(dest.path);
	path.appendRelativePath(basename);
	return path;
}

function getp(key) { /* get preference */
	return setp(key);
}

function setp(key, val) { /* set preference */
	var b = "extensions.tbconf.";
	var p = Components
		.classes["@mozilla.org/preferences-service;1"]
		.getService(Components.interfaces.nsIPrefService)
		.getBranch(b);
	var t = p.getPrefType(key);

	if (t == p.PREF_INVALID) {
		debug("key: invalid: "+key);
		return;
	}
	if (t == p.PREF_STRING) {
		debug("key: string: "+key);
		if (!val) {
			return p.getCharPref(key);
		}
		return p.setCharPref(key, val);
	}
	if (t == p.PREF_INT) {
		debug("key: int: "+key);
		if (!val) {
			return p.getIntPref(key);
		}
		return p.setIntPref(key, val);
	}
	if (t == p.PREF_BOOL) {
		debug("key: bool: "+key);
		if (!val) {
			return p.getBoolPref(key);
		}
		return p.setBoolPref(key, val);
	}
}

function init() {
	debug();
}

function pad(s) {
	return s<10?'0'+s:s;
}

function hdate() { /* HTTP-date */
	debug();

	var date = new Date();
	days = [
		"Mon", "Tue", "Wed", "Thu",
		"Fri", "Sat", "Sun"
	];
	mons = [
		"Jan", "Feb", "Mar", "Apr",
		"May", "Jun", "Jul", "Aug",
		"Sep", "Oct", "Nov", "Dec"
	];

	D = days[date.getUTCDay()];
	d = pad(date.getUTCDay());
	M = mons[date.getUTCMonth()];
	y = date.getUTCFullYear();
	h = pad(date.getUTCHours());
	m = pad(date.getUTCMinutes());
	s = pad(date.getUTCSeconds());

	/* Sat, 02 Apr 1998 14:18:22 GMT */
	return D+", "+d+" "+M+" "+y+" "+h+":"+m+":"+s+" GMT";
}

function fetch(uri, dest, basename) {
	debug(uri+", "+basename);

	var path = newp(dest, basename);
	var webp = newb(t.webp);
	var isrv = newb(t.isrv);
	var hedr = "If-Modified-Since: "+hdate();

	webp.saveURI(isrv.newURI(uri, null, null), null, null, null, null, path);
}

function extract(dest, basename) {
	debug(basename);

	var path = newp(dest, basename);
	var zipr = newb(t.zipr);

	zipr.open(path);
	zipr.test(null);

	var dent = zipr.findEntries("*/");
	var fent = zipr.findEntries(null);

	while (dent.hasMore()) {
		var e = dent.getNext();
		var d = newp(dest, e);

		if (d.exists()) {
			continue;
		}
		debug("dir: "+d.path);
		d.create(nsILocalFile.DIRECTORY_TYPE, 0755);
	}

	while (fent.hasMore()) {
		var e = fent.getNext();
		var f = newp(dest, e);

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
	Components
		.classes["@mozilla.org/toolkit/app-startup;1"]
		.getService(apps)
		.quit(flag);
}

function main() {
	debug();

	var basename = getp("profile.basename");
	var uri = getp("source")+getp("profile.id");
	var dest = Components
		.classes["@mozilla.org/file/directory_service;1"]
		.getService(Components.interfaces.nsIProperties)
		.get("ProfD", Components.interfaces.nsIFile);

	init();
	fetch(uri, dest, basename);
	extract(dest, basename);
}

main();
