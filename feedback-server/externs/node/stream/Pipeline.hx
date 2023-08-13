package node.stream;

/**
	A module method to pipe between streams and generators forwarding errors and
	properly cleaning up and provide a callback when the pipeline is complete.
	
	```js
	const { pipeline } = require('node:stream');
	const fs = require('node:fs');
	const zlib = require('node:zlib');
	
	// Use the pipeline API to easily pipe a series of streams
	// together and get notified when the pipeline is fully done.
	
	// A pipeline to gzip a potentially huge tar file efficiently:
	
	pipeline(
	   fs.createReadStream('archive.tar'),
	   zlib.createGzip(),
	   fs.createWriteStream('archive.tar.gz'),
	   (err) => {
	     if (err) {
	       console.error('Pipeline failed.', err);
	     } else {
	       console.log('Pipeline succeeded.');
	     }
	   },
	);
	```
	
	The `pipeline` API provides a `promise version`.
	
	`stream.pipeline()` will call `stream.destroy(err)` on all streams except:
	
	* `Readable` streams which have emitted `'end'` or `'close'`.
	* `Writable` streams which have emitted `'finish'` or `'close'`.
	
	`stream.pipeline()` leaves dangling event listeners on the streams
	after the `callback` has been invoked. In the case of reuse of streams after
	failure, this can cause event listener leaks and swallowed errors. If the last
	stream is readable, dangling event listeners will be removed so that the last
	stream can be consumed later.
	
	`stream.pipeline()` closes all the streams when an error is raised.
	The `IncomingRequest` usage with `pipeline` could lead to an unexpected behavior
	once it would destroy the socket without sending the expected response.
	See the example below:
	
	```js
	const fs = require('node:fs');
	const http = require('node:http');
	const { pipeline } = require('node:stream');
	
	const server = http.createServer((req, res) => {
	   const fileStream = fs.createReadStream('./fileNotExist.txt');
	   pipeline(fileStream, res, (err) => {
	     if (err) {
	       console.log(err); // No such file
	       // this message can't be sent once `pipeline` already destroyed the socket
	       return res.end('error!!!');
	     }
	   });
	});
	```
**/
@:jsRequire("stream", "pipeline") @valueModuleOnly extern class Pipeline {
	/**
		A module method to pipe between streams and generators forwarding errors and
		properly cleaning up and provide a callback when the pipeline is complete.
		
		```js
		const { pipeline } = require('node:stream');
		const fs = require('node:fs');
		const zlib = require('node:zlib');
		
		// Use the pipeline API to easily pipe a series of streams
		// together and get notified when the pipeline is fully done.
		
		// A pipeline to gzip a potentially huge tar file efficiently:
		
		pipeline(
		   fs.createReadStream('archive.tar'),
		   zlib.createGzip(),
		   fs.createWriteStream('archive.tar.gz'),
		   (err) => {
		     if (err) {
		       console.error('Pipeline failed.', err);
		     } else {
		       console.log('Pipeline succeeded.');
		     }
		   },
		);
		```
		
		The `pipeline` API provides a `promise version`.
		
		`stream.pipeline()` will call `stream.destroy(err)` on all streams except:
		
		* `Readable` streams which have emitted `'end'` or `'close'`.
		* `Writable` streams which have emitted `'finish'` or `'close'`.
		
		`stream.pipeline()` leaves dangling event listeners on the streams
		after the `callback` has been invoked. In the case of reuse of streams after
		failure, this can cause event listener leaks and swallowed errors. If the last
		stream is readable, dangling event listeners will be removed so that the last
		stream can be consumed later.
		
		`stream.pipeline()` closes all the streams when an error is raised.
		The `IncomingRequest` usage with `pipeline` could lead to an unexpected behavior
		once it would destroy the socket without sending the expected response.
		See the example below:
		
		```js
		const fs = require('node:fs');
		const http = require('node:http');
		const { pipeline } = require('node:stream');
		
		const server = http.createServer((req, res) => {
		   const fileStream = fs.createReadStream('./fileNotExist.txt');
		   pipeline(fileStream, res, (err) => {
		     if (err) {
		       console.log(err); // No such file
		       // this message can't be sent once `pipeline` already destroyed the socket
		       return res.end('error!!!');
		     }
		   });
		});
		```
	**/
	@:overload(function<A, T1, B>(source:A, transform1:T1, destination:B, ?callback:PipelineCallback<B>):Dynamic { })
	@:overload(function<A, T1, T2, B>(source:A, transform1:T1, transform2:T2, destination:B, ?callback:PipelineCallback<B>):Dynamic { })
	@:overload(function<A, T1, T2, T3, B>(source:A, transform1:T1, transform2:T2, transform3:T3, destination:B, ?callback:PipelineCallback<B>):Dynamic { })
	@:overload(function<A, T1, T2, T3, T4, B>(source:A, transform1:T1, transform2:T2, transform3:T3, transform4:T4, destination:B, ?callback:PipelineCallback<B>):Dynamic { })
	@:overload(function(streams:haxe.ds.ReadOnlyArray<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>>, ?callback:(err:Null<global.nodejs.ErrnoException>) -> Void):global.nodejs.WritableStream { })
	@:overload(function(stream1:global.nodejs.ReadableStream, stream2:ts.AnyOf2<global.nodejs.WritableStream, global.nodejs.ReadWriteStream>, streams:haxe.extern.Rest<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadWriteStream, (err:Null<global.nodejs.ErrnoException>) -> Void>>):global.nodejs.WritableStream { })
	@:selfCall
	static function call<A, B>(source:A, destination:B, ?callback:PipelineCallback<B>):Dynamic;
}