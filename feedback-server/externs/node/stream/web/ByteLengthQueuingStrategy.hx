package node.stream.web;

/**
	This Streams API interface provides a built-in byte length queuing
	strategy that can be used when constructing streams.
**/
@:jsRequire("stream/web", "ByteLengthQueuingStrategy") extern class ByteLengthQueuingStrategy {
	function new(init:QueuingStrategyInit);
	final highWaterMark : Float;
	function size(?chunk:js.lib.ArrayBufferView):Float;
	static var prototype : ByteLengthQueuingStrategy;
}