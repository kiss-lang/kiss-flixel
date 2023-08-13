package node.stream.web;

typedef ReadableStreamDefaultReadDoneResult = {
	var done : Bool;
	@:optional
	var value : Any;
};