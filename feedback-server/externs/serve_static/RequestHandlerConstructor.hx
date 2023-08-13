package serve_static;

typedef RequestHandlerConstructor<R> = {
	@:selfCall
	function call(root:String, ?options:ServeStaticOptions<R>):RequestHandler<R>;
	var mime : {
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
};