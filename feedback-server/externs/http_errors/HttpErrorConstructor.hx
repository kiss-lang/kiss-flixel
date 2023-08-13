package http_errors;

typedef HttpErrorConstructor<N> = ts.AnyOf2<() -> HttpError<N>, (msg:String) -> HttpError<N>>;