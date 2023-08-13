package node.nodecolontest.default_;

/**
	Shorthand for `test()`.
	
	The `it()` function is imported from the `node:test` module.
**/
@:jsRequire("node:test", "default.it") @valueModuleOnly extern class It {
	/**
		Shorthand for `test()`.
		
		The `it()` function is imported from the `node:test` module.
	**/
	@:overload(function(?name:String, ?fn:It):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:It, ?fn:It):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:It):js.lib.Promise<ts.Undefined> { })
	@:selfCall
	static function call(?name:String, ?options:It, ?fn:It):js.lib.Promise<ts.Undefined>;
	/**
		Shorthand for skipping a test, same as `it([name], { skip: true }[, fn])`.
	**/
	@:overload(function(?name:String, ?fn:It):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:It, ?fn:It):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:It):js.lib.Promise<ts.Undefined> { })
	static function skip(?name:String, ?options:It, ?fn:It):js.lib.Promise<ts.Undefined>;
	/**
		Shorthand for marking a test as `TODO`, same as `it([name], { todo: true }[, fn])`.
	**/
	@:overload(function(?name:String, ?fn:It):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:It, ?fn:It):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:It):js.lib.Promise<ts.Undefined> { })
	static function todo(?name:String, ?options:It, ?fn:It):js.lib.Promise<ts.Undefined>;
	/**
		Shorthand for marking a test as `only`, same as `it([name], { only: true }[, fn])`.
	**/
	@:overload(function(?name:String, ?fn:It):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:It, ?fn:It):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:It):js.lib.Promise<ts.Undefined> { })
	static function only(?name:String, ?options:It, ?fn:It):js.lib.Promise<ts.Undefined>;
}