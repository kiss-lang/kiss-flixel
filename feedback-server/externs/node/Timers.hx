package node;

/**
	The `timer` module exposes a global API for scheduling functions to
	be called at some future period of time. Because the timer functions are
	globals, there is no need to call `require('node:timers')` to use the API.
	
	The timer functions within Node.js implement a similar API as the timers API
	provided by Web Browsers but use a different internal implementation that is
	built around the Node.js [Event Loop](https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick/#setimmediate-vs-settimeout).
**/
@:jsRequire("timers") @valueModuleOnly extern class Timers {
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