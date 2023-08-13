package node.stream.web;

typedef IReadableStreamDefaultReader<R> = {
	function read():js.lib.Promise<ReadableStreamDefaultReadResult<R>>;
	function releaseLock():Void;
	final closed : js.lib.Promise<Null<Any>>;
	function cancel(?reason:Dynamic):js.lib.Promise<ts.Undefined>;
};