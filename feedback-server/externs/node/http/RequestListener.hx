package node.http;

typedef RequestListener<Request, Response> = (req:js.lib.InstanceType<Request>, res:Dynamic) -> Void;