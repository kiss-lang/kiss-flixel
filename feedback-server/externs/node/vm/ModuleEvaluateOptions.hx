package node.vm;

typedef ModuleEvaluateOptions = {
	@:optional
	var timeout : Float;
	@:optional
	var breakOnSigint : Bool;
};