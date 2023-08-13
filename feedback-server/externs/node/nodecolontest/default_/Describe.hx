package node.nodecolontest.default_;

/**
	The `describe()` function imported from the `node:test` module. Each
	invocation of this function results in the creation of a Subtest.
	After invocation of top level `describe` functions,
	all top level tests and suites will execute.
**/
@:jsRequire("node:test", "default.describe") @valueModuleOnly extern class Describe {
	/**
		The `describe()` function imported from the `node:test` module. Each
		invocation of this function results in the creation of a Subtest.
		After invocation of top level `describe` functions,
		all top level tests and suites will execute.
	**/
	@:overload(function(?name:String, ?fn:Describe):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:Describe, ?fn:Describe):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:Describe):js.lib.Promise<ts.Undefined> { })
	@:selfCall
	static function call(?name:String, ?options:Describe, ?fn:Describe):js.lib.Promise<ts.Undefined>;
	/**
		Shorthand for skipping a suite, same as `describe([name], { skip: true }[, fn])`.
	**/
	@:overload(function(?name:String, ?fn:Describe):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:Describe, ?fn:Describe):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:Describe):js.lib.Promise<ts.Undefined> { })
	static function skip(?name:String, ?options:Describe, ?fn:Describe):js.lib.Promise<ts.Undefined>;
	/**
		Shorthand for marking a suite as `TODO`, same as `describe([name], { todo: true }[, fn])`.
	**/
	@:overload(function(?name:String, ?fn:Describe):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:Describe, ?fn:Describe):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:Describe):js.lib.Promise<ts.Undefined> { })
	static function todo(?name:String, ?options:Describe, ?fn:Describe):js.lib.Promise<ts.Undefined>;
	/**
		Shorthand for marking a suite as `only`, same as `describe([name], { only: true }[, fn])`.
	**/
	@:overload(function(?name:String, ?fn:Describe):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:Describe, ?fn:Describe):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:Describe):js.lib.Promise<ts.Undefined> { })
	static function only(?name:String, ?options:Describe, ?fn:Describe):js.lib.Promise<ts.Undefined>;
}