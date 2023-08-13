package node.stream.web;

typedef UnderlyingSourceCancelCallback = ts.AnyOf2<() -> ts.AnyOf2<ts.Undefined, js.lib.PromiseLike<ts.Undefined>>, (reason:Dynamic) -> ts.AnyOf2<ts.Undefined, js.lib.PromiseLike<ts.Undefined>>>;