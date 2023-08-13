package node.stream.web;

typedef UnderlyingSinkWriteCallback<W> = (chunk:W, controller:WritableStreamDefaultController) -> ts.AnyOf2<ts.Undefined, js.lib.PromiseLike<ts.Undefined>>;