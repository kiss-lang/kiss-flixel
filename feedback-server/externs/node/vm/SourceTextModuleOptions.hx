package node.vm;

typedef SourceTextModuleOptions = {
	/**
		String used in stack traces.
	**/
	@:optional
	var identifier : String;
	@:optional
	var cachedData : ts.AnyOf13<js.lib.Int8Array, js.lib.Uint8Array, js.lib.Uint8ClampedArray, js.lib.Int16Array, js.lib.Uint16Array, js.lib.Int32Array, js.lib.Uint32Array, js.lib.Float32Array, js.lib.Float64Array, js.lib.BigInt64Array, js.lib.BigUint64Array, node.buffer.Buffer, js.lib.DataView>;
	@:optional
	var context : Context;
	@:optional
	var lineOffset : Float;
	@:optional
	var columnOffset : Float;
	/**
		Called during evaluation of this module to initialize the `import.meta`.
	**/
	@:optional
	dynamic function initializeImportMeta(meta:js.lib.ImportMeta, module:SourceTextModule):Void;
	@:optional
	dynamic function importModuleDynamically(specifier:String, script:Script, importAssertions:Dynamic):Module;
};