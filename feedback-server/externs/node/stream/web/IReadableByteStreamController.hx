package node.stream.web;

typedef IReadableByteStreamController = {
	final byobRequest : Null<Any>;
	final desiredSize : Null<Float>;
	function close():Void;
	function enqueue(chunk:js.lib.ArrayBufferView):Void;
	function error(?error:Dynamic):Void;
};