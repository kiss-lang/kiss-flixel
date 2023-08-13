package express;

@:jsRequire("express", "Router") extern class Router {
	@:selfCall
	static function call(?options:RouterOptions):Dynamic;
}