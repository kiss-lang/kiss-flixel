package node.stream.web;

@:jsRequire("stream/web", "TextEncoderStream") extern class TextEncoderStream {
	function new();
	/**
		Returns "utf-8".
	**/
	final encoding : String;
	final readable : ReadableStream<js.lib.Uint8Array>;
	final writable : WritableStream<String>;
	static var prototype : TextEncoderStream;
}