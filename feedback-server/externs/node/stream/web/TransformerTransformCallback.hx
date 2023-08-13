package node.stream.web;

typedef TransformerTransformCallback<I, O> = (chunk:I, controller:TransformStreamDefaultController<O>) -> ts.AnyOf2<ts.Undefined, js.lib.PromiseLike<ts.Undefined>>;