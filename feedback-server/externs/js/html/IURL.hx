package js.html;

/**
	The URL interface represents an object providing static methods used for creating object URLs.
	
	`URL` class is a global reference for `require('url').URL`
	https://nodejs.org/api/url.html#the-whatwg-url-api
**/
typedef IURL = {
	var hash : String;
	var host : String;
	var hostname : String;
	var href : String;
	final origin : String;
	var password : String;
	var pathname : String;
	var port : String;
	var protocol : String;
	var search : String;
	final searchParams : js.html.URLSearchParams;
	var username : String;
	function toJSON():String;
	/**
		The `toString()` method on the `URL` object returns the serialized URL. The
		value returned is equivalent to that of {@link href} and {@link toJSON}.
	**/
	function toString():String;
};