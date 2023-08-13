package node.stream.web;

typedef UnderlyingSource<R> = {
	@:optional
	dynamic function cancel(?reason:Dynamic):ts.AnyOf2<ts.Undefined, js.lib.PromiseLike<ts.Undefined>>;
	@:optional
	dynamic function pull(controller:ReadableStreamController<R>):ts.AnyOf2<ts.Undefined, js.lib.PromiseLike<ts.Undefined>>;
	@:optional
	dynamic function start(controller:ReadableStreamController<R>):Dynamic;
	@:optional
	var type : Any;
};