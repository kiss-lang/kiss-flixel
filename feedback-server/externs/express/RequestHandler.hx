package express;

typedef RequestHandler<P, ResBody, ReqBody, ReqQuery, Locals> = (req:Dynamic, res:Dynamic, next:express_serve_static_core.NextFunction) -> Void;