package express;

typedef ErrorRequestHandler<P, ResBody, ReqBody, ReqQuery, Locals> = (err:Dynamic, req:Dynamic, res:Dynamic, next:express_serve_static_core.NextFunction) -> Void;