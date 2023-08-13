package node.fs.promises;

typedef CreateReadStreamOptions = {
	@:optional
	var encoding : global.nodejs.BufferEncoding;
	@:optional
	var autoClose : Bool;
	@:optional
	var emitClose : Bool;
	@:optional
	var start : Float;
	@:optional
	var end : Float;
	@:optional
	var highWaterMark : Float;
};