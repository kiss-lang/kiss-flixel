package node.zlib;

typedef BrotliOptions = {
	@:optional
	var flush : Float;
	@:optional
	var finishFlush : Float;
	@:optional
	var chunkSize : Float;
	@:optional
	var params : Array<ts.AnyOf2<Float, Bool>>;
	@:optional
	var maxOutputLength : Float;
};