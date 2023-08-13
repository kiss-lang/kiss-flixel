package node.stream.web;

/**
	This Streams API interface represents a readable stream of byte data.
**/
@:jsRequire("stream/web", "ReadableStream") extern class ReadableStream<R> {
	@:overload(function<R>(?underlyingSource:UnderlyingSource<R>, ?strategy:QueuingStrategy<R>):ReadableStream<R> { })
	function new(underlyingSource:UnderlyingByteSource, ?strategy:QueuingStrategy<js.lib.Uint8Array>);
	final locked : Bool;
	function cancel(?reason:Dynamic):js.lib.Promise<ts.Undefined>;
	function getReader():ReadableStreamDefaultReader<R>;
	function pipeThrough<T>(transform:ReadableWritablePair<T, R>, ?options:StreamPipeOptions):ReadableStream<T>;
	function pipeTo(destination:WritableStream<R>, ?options:StreamPipeOptions):js.lib.Promise<ts.Undefined>;
	function tee():ts.Tuple2<ReadableStream<R>, ReadableStream<R>>;
	function values(?options:{ @:optional var preventCancel : Bool; }):js.lib.AsyncIterableIterator<R>;
	static var prototype : ReadableStream<Dynamic>;
}