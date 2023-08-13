package express;

typedef IRouter_ = {
	@:selfCall
	function call(?options:RouterOptions):Dynamic;
};