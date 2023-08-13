package express_serve_static_core;

typedef RequestHandler<P, ResBody, ReqBody, ReqQuery, LocalsObj> = (req:Dynamic, res:Dynamic, next:NextFunction) -> Void;