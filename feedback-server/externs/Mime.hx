@:jsRequire("mime") @valueModuleOnly extern class Mime {
	/**
		Look up a mime type based on extension.
		
		If not found, uses the fallback argument if provided, and otherwise
		uses `default_type`.
	**/
	static function lookup(path:String, ?fallback:String):String;
	/**
		Return a file extensions associated with a mime type.
	**/
	static function extension(mime:String):Null<String>;
	/**
		Load an Apache2-style ".types" file.
	**/
	static function load(filepath:String):Void;
	static function define(mimes:mime.TypeMap):Void;
	static final charsets : mime.Charsets;
	static final default_type : String;
}