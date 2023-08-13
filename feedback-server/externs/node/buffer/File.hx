package node.buffer;

/**
	A [`File`](https://developer.mozilla.org/en-US/docs/Web/API/File) provides information about files.
**/
@:jsRequire("buffer", "File") extern class File extends Blob {
	function new(sources:Array<ts.AnyOf14<String, Blob, js.lib.Int8Array, js.lib.Uint8Array, js.lib.Uint8ClampedArray, js.lib.Int16Array, js.lib.Uint16Array, js.lib.Int32Array, js.lib.Uint32Array, js.lib.Float32Array, js.lib.Float64Array, js.lib.BigInt64Array, js.lib.BigUint64Array, js.lib.DataView>>, fileName:String, ?options:FileOptions);
	/**
		The name of the `File`.
	**/
	final name : String;
	/**
		The last modified date of the `File`.
	**/
	final lastModified : Float;
	static var prototype : File;
}