package express_serve_static_core;

typedef ErrorRequestHandler<P, ResBody, ReqBody, ReqQuery, LocalsObj> = (err:Dynamic, req:Dynamic, res:Dynamic, next:NextFunction) -> Void;