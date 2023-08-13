package node.stream.web;

typedef ReadableStreamErrorCallback = (reason:Dynamic) -> ts.AnyOf2<ts.Undefined, js.lib.PromiseLike<ts.Undefined>>;