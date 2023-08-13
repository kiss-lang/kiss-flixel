package node.stream.web;

typedef ReadableStreamDefaultReadResult<T> = ts.AnyOf2<ReadableStreamDefaultReadDoneResult, ReadableStreamDefaultReadValueResult<T>>;