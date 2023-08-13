/**
	Create a new middleware function to serve files from within a given root directory.
	The file to serve will be determined by combining req.url with the provided root directory.
	When a file is not found, instead of sending a 404 response, this module will instead call next() to move on to the next middleware, allowing for stacking and fall-backs.
**/
@:jsRequire("serve-static") @valueModuleOnly extern class ServeStatic {
	/**
		Create a new middleware function to serve files from within a given root directory.
		The file to serve will be determined by combining req.url with the provided root directory.
		When a file is not found, instead of sending a 404 response, this module will instead call next() to move on to the next middleware, allowing for stacking and fall-backs.
	**/
	@:selfCall
	static function call<R>(root:String, ?options:serve_static.ServeStaticOptions<R>):serve_static.RequestHandler<R>;
	static var mime : {
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