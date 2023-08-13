package node.child_process;

typedef CommonExecOptions = {
	@:optional
	var input : node.crypto.BinaryLike;
	/**
		Can be set to 'pipe', 'inherit, or 'ignore', or an array of these strings.
		If passed as an array, the first element is used for `stdin`, the second for
		`stdout`, and the third for `stderr`. A fourth element can be used to
		specify the `stdio` behavior beyond the standard streams. See
		{@link ChildProcess.stdio} for more information.
	**/
	@:optional
	var stdio : StdioOptions;
	@:optional
	var killSignal : ts.AnyOf2<Float, String>;
	@:optional
	var maxBuffer : Float;
	@:optional
	var encoding : String;
	@:optional
	var windowsHide : Bool;
	@:optional
	var timeout : Float;
	@:optional
	var uid : Float;
	@:optional
	var gid : Float;
	@:optional
	var cwd : ts.AnyOf2<String, node.url.URL>;
	@:optional
	var env : global.nodejs.ProcessEnv;
};