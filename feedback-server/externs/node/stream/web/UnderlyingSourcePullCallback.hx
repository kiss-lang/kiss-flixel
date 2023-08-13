package node.stream.web;

typedef UnderlyingSourcePullCallback<R> = (controller:ReadableStreamController<R>) -> ts.AnyOf2<ts.Undefined, js.lib.PromiseLike<ts.Undefined>>;