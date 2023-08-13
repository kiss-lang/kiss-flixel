package node.vm;

typedef ScriptOptions = {
	/**
		V8's code cache data for the supplied source.
	**/
	@:optional
	var cachedData : ts.AnyOf13<js.lib.Int8Array, js.lib.Uint8Array, js.lib.Uint8ClampedArray, js.lib.Int16Array, js.lib.Uint16Array, js.lib.Int32Array, js.lib.Uint32Array, js.lib.Float32Array, js.lib.Float64Array, js.lib.BigInt64Array, js.lib.BigUint64Array, node.buffer.Buffer, js.lib.DataView>;
	@:optional
	var produceCachedData : Bool;
	/**
		Called during evaluation of this module when `import()` is called.
		If this option is not specified, calls to `import()` will reject with `ERR_VM_DYNAMIC_IMPORT_CALLBACK_MISSING`.
	**/
	@:optional
	dynamic function importModuleDynamically(specifier:String, script:Script, importAssertions:Dynamic):Module;
	/**
		Specifies the filename used in stack traces produced by this script.
		Default: `''`.
	**/
	@:optional
	var filename : String;
	/**
		Specifies the line number offset that is displayed in stack traces produced by this script.
		Default: `0`.
	**/
	@:optional
	var lineOffset : Float;
	/**
		Specifies the column number offset that is displayed in stack traces produced by this script.
	**/
	@:optional
	var columnOffset : Float;
};