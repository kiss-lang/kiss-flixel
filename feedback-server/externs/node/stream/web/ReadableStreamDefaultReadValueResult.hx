package node.stream.web;

typedef ReadableStreamDefaultReadValueResult<T> = {
	var done : Bool;
	var value : T;
};