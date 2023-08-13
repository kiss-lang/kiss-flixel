package node.fs;

typedef ReadAsyncOptions<TBuffer> = {
	@:optional
	var buffer : TBuffer;
	@:optional
	var offset : Float;
	@:optional
	var length : Float;
	@:optional
	var position : ts.AnyOf2<Float, js.lib.BigInt>;
};