package node.stream.web;

typedef UnderlyingSinkAbortCallback = ts.AnyOf2<() -> ts.AnyOf2<ts.Undefined, js.lib.PromiseLike<ts.Undefined>>, (reason:Dynamic) -> ts.AnyOf2<ts.Undefined, js.lib.PromiseLike<ts.Undefined>>>;