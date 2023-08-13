package node.stream.web;

typedef TransformerFlushCallback<O> = (controller:TransformStreamDefaultController<O>) -> ts.AnyOf2<ts.Undefined, js.lib.PromiseLike<ts.Undefined>>;