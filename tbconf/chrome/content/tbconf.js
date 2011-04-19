/**
 *	https://developer.mozilla.org/en/XPCOM_Interface_Reference/nsILocalFile
 *	https://developer.mozilla.org/en/XPCOM_Interface_Reference/nsIZipReader
 *	https://developer.mozilla.org/en/XMLHttpRequest
 *	https://developer.mozilla.org/en/PR_Open
 */
var i = 0;
var t = { /* object types */
	prof:i++,
	path:i++,
	zipr:i++,
	fstr:i++
}

function newb(type) { /* new object */
	if (type == t.prof) {
		return Components
			.classes["@mozilla.org/file/directory_service;1"]
			.getService(Components.interfaces.nsIProperties)
			.get("ProfD", Components.interfaces.nsIFile);
	}
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
	if (type == t.fstr) {
		return Components
			.classes["@mozilla.org/network/file-output-stream;1"]
			.createInstance(Components.interfaces.nsIFileOutputStream);
	}
}

function newp(dest, basename) { /* new path */
	path = newb(t.path);
	path.initWithPath(dest.path);
	path.appendRelativePath(basename);
	return path;
}

function debug(msg) {
	dump("[tbconf."+debug.caller.name+"]");
	if (msg) {
		dump(" "+msg);
	}
	dump("\n");
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
		if (!val) {
			return p.getCharPref(key);
		}
		return p.setCharPref(key, val);
	}
	if (t == p.PREF_INT) {
		if (!val) {
			return p.getIntPref(key);
		}
		return p.setIntPref(key, val);
	}
	if (t == p.PREF_BOOL) {
		if (!val) {
			return p.getBoolPref(key);
		}
		return p.setBoolPref(key, val);
	}
}

function pad(s) {
	return s<10?'0'+s:s;
}

function hdate(msec) { /* HTTP-date */
	var date = new Date(msec);
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
	d = pad(date.getUTCDate());
	M = mons[date.getUTCMonth()];
	y = date.getUTCFullYear();
	h = pad(date.getUTCHours());
	m = pad(date.getUTCMinutes());
	s = pad(date.getUTCSeconds());

	/* Sat, 02 Apr 1998 14:18:22 GMT */
	return D+", "+d+" "+M+" "+y+" "+h+":"+m+":"+s+" GMT";
}

function fetch(uri, dest, basename) {
	debug(uri);

	var mime = "text/plain; charset=x-user-defined";
	var hdrn = "If-Modified-Since";
	var hdrc = hdate(lastupdate());
	var path = newp(dest, basename);
	var hreq = new XMLHttpRequest();
	var fstr = newb(t.fstr);

	hreq.open("GET", uri, false);
	hreq.setRequestHeader(hdrn, hdrc);
	hreq.overrideMimeType(mime);
	try {
		hreq.send();
	}
	catch (e) {
		debug(e.message);
		return 0;
	}

	fstr.init(path, 0x02 | 0x08 | 0x20, 0644, 0);
	fstr.write(hreq.responseText, hreq.responseText.length);
	debug("status: "+hreq.status);
	return hreq.status;
}

function lastupdate(date) {
	var key = "update.last";
	if (!date) {
		return parseInt(getp(key));
	}
	return setp(key, date.getTime()+"");
}

function extract(dest, basename) {
	var path = newp(dest, basename);
	var zipr = newb(t.zipr);

	try {
		zipr.open(path);
		zipr.test(null);
	}
	catch (e) {
		debug(e.message);
		return false;
	}

	var dent = zipr.findEntries("*/");
	var fent = zipr.findEntries("*[^/]");

	while (dent.hasMore()) {
		var e = dent.getNext();
		var d = newp(dest, e);

		if (d.exists()) {
			debug("d: ="+d.path);
			continue;
		}
		debug("d: +"+d.path);
		d.create(0x01, 0755);
	}

	while (fent.hasMore()) {
		var e = fent.getNext();
		var f = newp(dest, e);

		if (f.exists()) {
			debug("f: -"+f.path);
			f.remove(false);
		}
		debug("f: +"+f.path);
		zipr.extract(e, f);
	}
	zipr.close();
	return true;
}

function restart() {
	debug();

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

function msec(min) { /* milliseconds */
	return min*60000;
}

function sec(msec) { /* seconds */
	return parseInt(msec/1000);
}

function main() {
	var now = new Date();
	var diff = now.getTime()-lastupdate();
	var mindiff = msec(getp("update.interval"));

	var dest = newb(t.prof);
	var basename = getp("basename");
	var uri = getp("source")+getp("id");

	if (diff < mindiff) {
		debug("too soon, "+sec(mindiff-diff)+" seconds left");
		return;
	}

	if (fetch(uri, dest, basename) == 200) {
		if (!extract(dest, basename)) {
			return;
		}
		lastupdate(now);
		restart();
	}
}

main();
