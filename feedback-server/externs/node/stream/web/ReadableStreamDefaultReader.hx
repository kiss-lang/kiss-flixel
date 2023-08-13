package node.stream.web;

@:jsRequire("stream/web", "ReadableStreamDefaultReader") extern class ReadableStreamDefaultReader<R> {
	function new<R>(stream:ReadableStream<R>);
	function read():js.lib.Promise<ReadableStreamDefaultReadResult<R>>;
	function releaseLock():Void;
	final closed : js.lib.Promise<Null<Any>>;
	function cancel(?reason:Dynamic):js.lib.Promise<ts.Undefined>;
	static var prototype : ReadableStreamDefaultReader<Dynamic>;
}