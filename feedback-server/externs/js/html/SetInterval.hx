package js.html;

/**
	Schedules repeated execution of `callback` every `delay` milliseconds.
	
	When `delay` is larger than `2147483647` or less than `1`, the `delay` will be
	set to `1`. Non-integer delays are truncated to an integer.
	
	If `callback` is not a function, a `TypeError` will be thrown.
	
	This method has a custom variant for promises that is available using `timersPromises.setInterval()`.
**/
@:native("setInterval") @valueModuleOnly extern class SetInterval {
	@:overload(function<TArgs>(callback:(args:haxe.extern.Rest<Any>) -> Void, ?ms:Float, args:haxe.extern.Rest<Any>):global.nodejs.Timeout { })
	@:overload(function(callback:(args:ts.Undefined) -> Void, ?ms:Float):global.nodejs.Timeout { })
	@:selfCall
	static function call(handler:TimerHandler, ?timeout:Float, arguments:haxe.extern.Rest<Dynamic>):Float;
}