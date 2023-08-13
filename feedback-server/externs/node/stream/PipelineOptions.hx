package node.stream;

typedef PipelineOptions = {
	@:optional
	var signal : js.html.AbortSignal;
	@:optional
	var end : Bool;
};