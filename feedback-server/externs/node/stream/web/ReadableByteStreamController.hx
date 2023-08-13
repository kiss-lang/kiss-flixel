package node.stream.web;

@:jsRequire("stream/web", "ReadableByteStreamController") extern class ReadableByteStreamController {
	function new();
	final byobRequest : Null<Any>;
	final desiredSize : Null<Float>;
	function close():Void;
	function enqueue(chunk:js.lib.ArrayBufferView):Void;
	function error(?error:Dynamic):Void;
	static var prototype : ReadableByteStreamController;
}