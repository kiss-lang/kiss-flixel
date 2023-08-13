package node;

@:jsRequire("node:timers") @valueModuleOnly extern class NodeTimers {
	@:overload(function<TArgs>(callback:(args:haxe.extern.Rest<Any>) -> Void, ?ms:Float, args:haxe.extern.Rest<Any>):global.nodejs.Timeout { })
	@:overload(function(callback:(args:ts.Undefined) -> Void, ?ms:Float):global.nodejs.Timeout { })
	dynamic static function setTimeout(handler:js.html.TimerHandler, ?timeout:Float, arguments:haxe.extern.Rest<Dynamic>):Float;
	@:overload(function(timeoutId:Null<ts.AnyOf3<String, Float, global.nodejs.Timeout>>):Void { })
	dynamic static function clearTimeout(?handle:Float):Void;
	@:overload(function<TArgs>(callback:(args:haxe.extern.Rest<Any>) -> Void, ?ms:Float, args:haxe.extern.Rest<Any>):global.nodejs.Timeout { })
	@:overload(function(callback:(args:ts.Undefined) -> Void, ?ms:Float):global.nodejs.Timeout { })
	dynamic static function setInterval(handler:js.html.TimerHandler, ?timeout:Float, arguments:haxe.extern.Rest<Dynamic>):Float;
	@:overload(function(intervalId:Null<ts.AnyOf3<String, Float, global.nodejs.Timeout>>):Void { })
	dynamic static function clearInterval(?handle:Float):Void;
	@:overload(function(callback:(args:ts.Undefined) -> Void):global.nodejs.Immediate { })
	dynamic static function setImmediate<TArgs>(callback:(args:haxe.extern.Rest<Any>) -> Void, args:haxe.extern.Rest<Any>):global.nodejs.Immediate;
	dynamic static function clearImmediate(immediateId:Null<global.nodejs.Immediate>):Void;
}