package node.fs;

/**
	Read data from the file specified by `fd`.
	
	The callback is given the three arguments, `(err, bytesRead, buffer)`.
	
	If the file is not modified concurrently, the end-of-file is reached when the
	number of bytes read is zero.
	
	If this method is invoked as its `util.promisify()` ed version, it returns
	a promise for an `Object` with `bytesRead` and `buffer` properties.
	
	Similar to the above `fs.read` function, this version takes an optional `options` object.
	If not otherwise specified in an `options` object,
	`buffer` defaults to `Buffer.alloc(16384)`,
	`offset` defaults to `0`,
	`length` defaults to `buffer.byteLength`, `- offset` as of Node 17.6.0
	`position` defaults to `null`
**/
@:jsRequire("fs", "read") @valueModuleOnly extern class Read {
	/**
		Read data from the file specified by `fd`.
		
		The callback is given the three arguments, `(err, bytesRead, buffer)`.
		
		If the file is not modified concurrently, the end-of-file is reached when the
		number of bytes read is zero.
		
		If this method is invoked as its `util.promisify()` ed version, it returns
		a promise for an `Object` with `bytesRead` and `buffer` properties.
	**/
	@:overload(function<TBuffer>(fd:Float, options:ReadAsyncOptions<TBuffer>, callback:(err:Null<global.nodejs.ErrnoException>, bytesRead:Float, buffer:TBuffer) -> Void):Void { })
	@:overload(function(fd:Float, callback:(err:Null<global.nodejs.ErrnoException>, bytesRead:Float, buffer:global.nodejs.ArrayBufferView) -> Void):Void { })
	@:selfCall
	static function call<TBuffer>(fd:Float, buffer:TBuffer, offset:Float, length:Float, position:Null<ts.AnyOf2<Float, js.lib.BigInt>>, callback:(err:Null<global.nodejs.ErrnoException>, bytesRead:Float, buffer:TBuffer) -> Void):Void;
}