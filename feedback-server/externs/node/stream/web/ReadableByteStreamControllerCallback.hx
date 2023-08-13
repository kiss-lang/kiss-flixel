package node.stream.web;

typedef ReadableByteStreamControllerCallback = (controller:ReadableByteStreamController) -> ts.AnyOf2<ts.Undefined, js.lib.PromiseLike<ts.Undefined>>;