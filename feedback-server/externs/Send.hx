/**
	Create a new SendStream for the given path to send to a res.
	The req is the Node.js HTTP request and the path is a urlencoded path to send (urlencoded, not the actual file-system path).
**/
@:jsRequire("send") @valueModuleOnly extern class Send {
	/**
		Create a new SendStream for the given path to send to a res.
		The req is the Node.js HTTP request and the path is a urlencoded path to send (urlencoded, not the actual file-system path).
	**/
	@:selfCall
	static function call(req:node.stream.Readable, path:String, ?options:send.SendOptions):send.SendStream;
	static final mime : {
		/**
			Look up a mime type based on extension.
			
			If not found, uses the fallback argument if provided, and otherwise
			uses `default_type`.
		**/
		function lookup(path:String, ?fallback:String):String;
		/**
			Return a file extensions associated with a mime type.
		**/
		function extension(mime:String):Null<String>;
		/**
			Load an Apache2-style ".types" file.
		**/
		function load(filepath:String):Void;
		function define(mimes:mime.TypeMap):Void;
		final charsets : mime.Charsets;
		final default_type : String;
	};
}