/**
	Creates an Express application. The express() function is a top-level function exported by the express module.
**/
@:jsRequire("express") @valueModuleOnly extern class Express {
	/**
		Creates an Express application. The express() function is a top-level function exported by the express module.
	**/
	@:selfCall
	static function call():Dynamic;
	/**
		This is a built-in middleware function in Express. It parses incoming request query parameters.
	**/
	static function query(options:ts.AnyOf2<qs.IParseOptions, { @:overload(function(str:ts.AnyOf2<String, haxe.DynamicAccess<String>>, ?options:qs.IParseOptions):haxe.DynamicAccess<Any> { }) @:selfCall function call(str:String, ?options:Dynamic):qs.ParsedQs; }>):express.Handler;
	static function Router(?options:express.RouterOptions):Dynamic;
	/**
		This is a built-in middleware function in Express. It parses incoming requests with JSON payloads and is based on body-parser.
	**/
	dynamic static function json(?options:body_parser.OptionsJson):connect.NextHandleFunction;
	/**
		This is a built-in middleware function in Express. It parses incoming requests with Buffer payloads and is based on body-parser.
	**/
	dynamic static function raw(?options:body_parser.Options):connect.NextHandleFunction;
	/**
		This is a built-in middleware function in Express. It parses incoming requests with text payloads and is based on body-parser.
	**/
	dynamic static function text(?options:body_parser.OptionsText):connect.NextHandleFunction;
	/**
		These are the exposed prototypes.
	**/
	static var application : express.Application;
	static var request : express.Request<express_serve_static_core.ParamsDictionary, Dynamic, Dynamic, qs.ParsedQs, haxe.DynamicAccess<Dynamic>>;
	static var response : express.Response<Dynamic, haxe.DynamicAccess<Dynamic>>;
	/**
		This is a built-in middleware function in Express. It serves static files and is based on serve-static.
	**/
	@:native("static")
	static var static_ : serve_static.RequestHandlerConstructor<express.Response<Dynamic, haxe.DynamicAccess<Dynamic>>>;
	/**
		This is a built-in middleware function in Express. It parses incoming requests with urlencoded payloads and is based on body-parser.
	**/
	dynamic static function urlencoded(?options:body_parser.OptionsUrlencoded):connect.NextHandleFunction;
}