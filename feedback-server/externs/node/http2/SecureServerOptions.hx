package node.http2;

typedef SecureServerOptions = {
	@:optional
	var allowHTTP1 : Bool;
	@:optional
	var origins : Array<String>;
	@:optional
	var Http1IncomingMessage : {
		var prototype : node.http.IncomingMessage;
		/**
			A utility method for creating a `Readable` from a web `ReadableStream`.
		**/
		function fromWeb(readableStream:node.stream.web.ReadableStream<Dynamic>, ?options:{ /** When provided the corresponding `AbortController` can be used to cancel an asynchronous action. **/ @:optional var signal : js.html.AbortSignal; @:optional var encoding : global.nodejs.BufferEncoding; @:optional var highWaterMark : Float; @:optional var objectMode : Bool; }):node.stream.Readable;
		/**
			A utility method for creating a web `ReadableStream` from a `Readable`.
		**/
		function toWeb(streamReadable:node.stream.Readable):node.stream.web.ReadableStream<Dynamic>;
		/**
			A utility method for creating Readable Streams out of iterators.
		**/
		function from(iterable:ts.AnyOf2<Iterable<Dynamic>, js.lib.AsyncIterable<Dynamic>>, ?options:node.stream.ReadableOptions):node.stream.Readable;
		/**
			Returns whether the stream has been read from or cancelled.
		**/
		function isDisturbed(stream:ts.AnyOf2<global.nodejs.ReadableStream, node.stream.Readable>):Bool;
		/**
			A stream to attach a signal to.
			
			Attaches an AbortSignal to a readable or writeable stream. This lets code
			control stream destruction using an `AbortController`.
			
			Calling `abort` on the `AbortController` corresponding to the passed`AbortSignal` will behave the same way as calling `.destroy(new AbortError())`on the stream, and `controller.error(new
			AbortError())` for webstreams.
			
			```js
			const fs = require('node:fs');
			
			const controller = new AbortController();
			const read = addAbortSignal(
			   controller.signal,
			   fs.createReadStream(('object.json')),
			);
			// Later, abort the operation closing the stream
			controller.abort();
			```
			
			Or using an `AbortSignal` with a readable stream as an async iterable:
			
			```js
			const controller = new AbortController();
			setTimeout(() => controller.abort(), 10_000); // set a timeout
			const stream = addAbortSignal(
			   controller.signal,
			   fs.createReadStream(('object.json')),
			);
			(async () => {
			   try {
			     for await (const chunk of stream) {
			       await process(chunk);
			     }
			   } catch (e) {
			     if (e.name === 'AbortError') {
			       // The operation was cancelled
			     } else {
			       throw e;
			     }
			   }
			})();
			```
			
			Or using an `AbortSignal` with a ReadableStream:
			
			```js
			const controller = new AbortController();
			const rs = new ReadableStream({
			   start(controller) {
			     controller.enqueue('hello');
			     controller.enqueue('world');
			     controller.close();
			   },
			});
			
			addAbortSignal(controller.signal, rs);
			
			finished(rs, (err) => {
			   if (err) {
			     if (err.name === 'AbortError') {
			       // The operation was cancelled
			     }
			   }
			});
			
			const reader = rs.getReader();
			
			reader.read().then(({ value, done }) => {
			   console.log(value); // hello
			   console.log(done); // false
			   controller.abort();
			});
			```
		**/
		function addAbortSignal<T>(signal:js.html.AbortSignal, stream:T):T;
		/**
			Returns the default highWaterMark used by streams.
			Defaults to `16384` (16 KiB), or `16` for `objectMode`.
		**/
		function getDefaultHighWaterMark(objectMode:Bool):Float;
		/**
			Sets the default highWaterMark used by streams.
		**/
		function setDefaultHighWaterMark(objectMode:Bool, value:Float):Void;
		/**
			A readable and/or writable stream/webstream.
			
			A function to get notified when a stream is no longer readable, writable
			or has experienced an error or a premature close event.
			
			```js
			const { finished } = require('node:stream');
			const fs = require('node:fs');
			
			const rs = fs.createReadStream('archive.tar');
			
			finished(rs, (err) => {
			   if (err) {
			     console.error('Stream failed.', err);
			   } else {
			     console.log('Stream is done reading.');
			   }
			});
			
			rs.resume(); // Drain the stream.
			```
			
			Especially useful in error handling scenarios where a stream is destroyed
			prematurely (like an aborted HTTP request), and will not emit `'end'`or `'finish'`.
			
			The `finished` API provides `promise version`.
			
			`stream.finished()` leaves dangling event listeners (in particular`'error'`, `'end'`, `'finish'` and `'close'`) after `callback` has been
			invoked. The reason for this is so that unexpected `'error'` events (due to
			incorrect stream implementations) do not cause unexpected crashes.
			If this is unwanted behavior then the returned cleanup function needs to be
			invoked in the callback:
			
			```js
			const cleanup = finished(rs, (err) => {
			   cleanup();
			   // ...
			});
			```
		**/
		@:overload(function(stream:ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>, callback:ts.AnyOf2<() -> Void, (err:global.nodejs.ErrnoException) -> Void>):() -> Void { })
		function finished(stream:ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>, options:node.stream.FinishedOptions, callback:ts.AnyOf2<() -> Void, (err:global.nodejs.ErrnoException) -> Void>):() -> Void;
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
		@:overload(function<A, T1, B>(source:A, transform1:T1, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function<A, T1, T2, B>(source:A, transform1:T1, transform2:T2, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function<A, T1, T2, T3, B>(source:A, transform1:T1, transform2:T2, transform3:T3, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function<A, T1, T2, T3, T4, B>(source:A, transform1:T1, transform2:T2, transform3:T3, transform4:T4, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function(streams:haxe.ds.ReadOnlyArray<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>>, ?callback:(err:Null<global.nodejs.ErrnoException>) -> Void):global.nodejs.WritableStream { })
		@:overload(function(stream1:global.nodejs.ReadableStream, stream2:ts.AnyOf2<global.nodejs.WritableStream, global.nodejs.ReadWriteStream>, streams:haxe.extern.Rest<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadWriteStream, (err:Null<global.nodejs.ErrnoException>) -> Void>>):global.nodejs.WritableStream { })
		function pipeline<A, B>(source:A, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic;
		/**
			Returns whether the stream has encountered an error.
		**/
		function isErrored(stream:ts.AnyOf4<global.nodejs.WritableStream, global.nodejs.ReadableStream, node.stream.Readable, node.stream.Writable>):Bool;
		/**
			Returns whether the stream is readable.
		**/
		function isReadable(stream:ts.AnyOf2<global.nodejs.ReadableStream, node.stream.Readable>):Bool;
		final promises : {
			function finished(stream:ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>, ?options:node.stream.FinishedOptions):js.lib.Promise<ts.Undefined>;
			@:overload(function<A, T1, B>(source:A, transform1:T1, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function<A, T1, T2, B>(source:A, transform1:T1, transform2:T2, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function<A, T1, T2, T3, B>(source:A, transform1:T1, transform2:T2, transform3:T3, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function<A, T1, T2, T3, T4, B>(source:A, transform1:T1, transform2:T2, transform3:T3, transform4:T4, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function(streams:haxe.ds.ReadOnlyArray<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>>, ?options:node.stream.PipelineOptions):js.lib.Promise<ts.Undefined> { })
			@:overload(function(stream1:global.nodejs.ReadableStream, stream2:ts.AnyOf2<global.nodejs.WritableStream, global.nodejs.ReadWriteStream>, streams:haxe.extern.Rest<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadWriteStream, node.stream.PipelineOptions>>):js.lib.Promise<ts.Undefined> { })
			function pipeline<A, B>(source:A, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B>;
		};
		final consumers : {
			function buffer(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<node.buffer.Buffer>;
			function text(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<String>;
			function arrayBuffer(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<js.lib.ArrayBuffer>;
			function blob(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<node.buffer.Blob>;
			function json(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<Any>;
		};
		/**
			Creates a `Promise` that is fulfilled when the `EventEmitter` emits the given
			event or that is rejected if the `EventEmitter` emits `'error'` while waiting.
			The `Promise` will resolve with an array of all the arguments emitted to the
			given event.
			
			This method is intentionally generic and works with the web platform [EventTarget](https://dom.spec.whatwg.org/#interface-eventtarget) interface, which has no special`'error'` event
			semantics and does not listen to the `'error'` event.
			
			```js
			import { once, EventEmitter } from 'node:events';
			import process from 'node:process';
			
			const ee = new EventEmitter();
			
			process.nextTick(() => {
			   ee.emit('myevent', 42);
			});
			
			const [value] = await once(ee, 'myevent');
			console.log(value);
			
			const err = new Error('kaboom');
			process.nextTick(() => {
			   ee.emit('error', err);
			});
			
			try {
			   await once(ee, 'myevent');
			} catch (err) {
			   console.error('error happened', err);
			}
			```
			
			The special handling of the `'error'` event is only used when `events.once()`is used to wait for another event. If `events.once()` is used to wait for the
			'`error'` event itself, then it is treated as any other kind of event without
			special handling:
			
			```js
			import { EventEmitter, once } from 'node:events';
			
			const ee = new EventEmitter();
			
			once(ee, 'error')
			   .then(([err]) => console.log('ok', err.message))
			   .catch((err) => console.error('error', err.message));
			
			ee.emit('error', new Error('boom'));
			
			// Prints: ok boom
			```
			
			An `AbortSignal` can be used to cancel waiting for the event:
			
			```js
			import { EventEmitter, once } from 'node:events';
			
			const ee = new EventEmitter();
			const ac = new AbortController();
			
			async function foo(emitter, event, signal) {
			   try {
			     await once(emitter, event, { signal });
			     console.log('event emitted!');
			   } catch (error) {
			     if (error.name === 'AbortError') {
			       console.error('Waiting for the event was canceled!');
			     } else {
			       console.error('There was an error', error.message);
			     }
			   }
			}
			
			foo(ee, 'foo', ac.signal);
			ac.abort(); // Abort waiting for the event
			ee.emit('foo'); // Prints: Waiting for the event was canceled!
			```
		**/
		@:overload(function(emitter:SecureServerOptions, eventName:String, ?options:SecureServerOptions):js.lib.Promise<Array<Dynamic>> { })
		function once(emitter:SecureServerOptions, eventName:ts.AnyOf2<String, js.lib.Symbol>, ?options:SecureServerOptions):js.lib.Promise<Array<Dynamic>>;
		/**
			```js
			import { on, EventEmitter } from 'node:events';
			import process from 'node:process';
			
			const ee = new EventEmitter();
			
			// Emit later on
			process.nextTick(() => {
			   ee.emit('foo', 'bar');
			   ee.emit('foo', 42);
			});
			
			for await (const event of on(ee, 'foo')) {
			   // The execution of this inner block is synchronous and it
			   // processes one event at a time (even with await). Do not use
			   // if concurrent execution is required.
			   console.log(event); // prints ['bar'] [42]
			}
			// Unreachable here
			```
			
			Returns an `AsyncIterator` that iterates `eventName` events. It will throw
			if the `EventEmitter` emits `'error'`. It removes all listeners when
			exiting the loop. The `value` returned by each iteration is an array
			composed of the emitted event arguments.
			
			An `AbortSignal` can be used to cancel waiting on events:
			
			```js
			import { on, EventEmitter } from 'node:events';
			import process from 'node:process';
			
			const ac = new AbortController();
			
			(async () => {
			   const ee = new EventEmitter();
			
			   // Emit later on
			   process.nextTick(() => {
			     ee.emit('foo', 'bar');
			     ee.emit('foo', 42);
			   });
			
			   for await (const event of on(ee, 'foo', { signal: ac.signal })) {
			     // The execution of this inner block is synchronous and it
			     // processes one event at a time (even with await). Do not use
			     // if concurrent execution is required.
			     console.log(event); // prints ['bar'] [42]
			   }
			   // Unreachable here
			})();
			
			process.nextTick(() => ac.abort());
			```
		**/
		function on(emitter:global.nodejs.EventEmitter, eventName:String, ?options:SecureServerOptions):js.lib.AsyncIterableIterator<Dynamic>;
		/**
			A class method that returns the number of listeners for the given `eventName`registered on the given `emitter`.
			
			```js
			import { EventEmitter, listenerCount } from 'node:events';
			
			const myEmitter = new EventEmitter();
			myEmitter.on('event', () => {});
			myEmitter.on('event', () => {});
			console.log(listenerCount(myEmitter, 'event'));
			// Prints: 2
			```
		**/
		function listenerCount(emitter:global.nodejs.EventEmitter, eventName:ts.AnyOf2<String, js.lib.Symbol>):Float;
		/**
			Returns a copy of the array of listeners for the event named `eventName`.
			
			For `EventEmitter`s this behaves exactly the same as calling `.listeners` on
			the emitter.
			
			For `EventTarget`s this is the only way to get the event listeners for the
			event target. This is useful for debugging and diagnostic purposes.
			
			```js
			import { getEventListeners, EventEmitter } from 'node:events';
			
			{
			   const ee = new EventEmitter();
			   const listener = () => console.log('Events are fun');
			   ee.on('foo', listener);
			   console.log(getEventListeners(ee, 'foo')); // [ [Function: listener] ]
			}
			{
			   const et = new EventTarget();
			   const listener = () => console.log('Events are fun');
			   et.addEventListener('foo', listener);
			   console.log(getEventListeners(et, 'foo')); // [ [Function: listener] ]
			}
			```
		**/
		function getEventListeners(emitter:ts.AnyOf2<global.nodejs.EventEmitter, SecureServerOptions>, name:ts.AnyOf2<String, js.lib.Symbol>):Array<haxe.Constraints.Function>;
		/**
			Returns the currently set max amount of listeners.
			
			For `EventEmitter`s this behaves exactly the same as calling `.getMaxListeners` on
			the emitter.
			
			For `EventTarget`s this is the only way to get the max event listeners for the
			event target. If the number of event handlers on a single EventTarget exceeds
			the max set, the EventTarget will print a warning.
			
			```js
			import { getMaxListeners, setMaxListeners, EventEmitter } from 'node:events';
			
			{
			   const ee = new EventEmitter();
			   console.log(getMaxListeners(ee)); // 10
			   setMaxListeners(11, ee);
			   console.log(getMaxListeners(ee)); // 11
			}
			{
			   const et = new EventTarget();
			   console.log(getMaxListeners(et)); // 10
			   setMaxListeners(11, et);
			   console.log(getMaxListeners(et)); // 11
			}
			```
		**/
		function getMaxListeners(emitter:ts.AnyOf2<global.nodejs.EventEmitter, SecureServerOptions>):Float;
		/**
			```js
			import { setMaxListeners, EventEmitter } from 'node:events';
			
			const target = new EventTarget();
			const emitter = new EventEmitter();
			
			setMaxListeners(5, target, emitter);
			```
		**/
		function setMaxListeners(?n:Float, eventTargets:haxe.extern.Rest<ts.AnyOf2<global.nodejs.EventEmitter, SecureServerOptions>>):Void;
		/**
			Listens once to the `abort` event on the provided `signal`.
			
			Listening to the `abort` event on abort signals is unsafe and may
			lead to resource leaks since another third party with the signal can
			call `e.stopImmediatePropagation()`. Unfortunately Node.js cannot change
			this since it would violate the web standard. Additionally, the original
			API makes it easy to forget to remove listeners.
			
			This API allows safely using `AbortSignal`s in Node.js APIs by solving these
			two issues by listening to the event such that `stopImmediatePropagation` does
			not prevent the listener from running.
			
			Returns a disposable so that it may be unsubscribed from more easily.
			
			```js
			import { addAbortListener } from 'node:events';
			
			function example(signal) {
			   let disposable;
			   try {
			     signal.addEventListener('abort', (e) => e.stopImmediatePropagation());
			     disposable = addAbortListener(signal, (e) => {
			       // Do something when signal is aborted.
			     });
			   } finally {
			     disposable?.[Symbol.dispose]();
			   }
			}
			```
		**/
		function addAbortListener(signal:js.html.AbortSignal, resource:(event:js.html.Event) -> Void):global.Disposable;
		/**
			This symbol shall be used to install a listener for only monitoring `'error'`events. Listeners installed using this symbol are called before the regular`'error'` listeners are called.
			
			Installing a listener using this symbol does not change the behavior once an`'error'` event is emitted. Therefore, the process will still crash if no
			regular `'error'` listener is installed.
		**/
		final errorMonitor : js.lib.Symbol;
		/**
			Value: `Symbol.for('nodejs.rejection')`
			
			See how to write a custom `rejection handler`.
		**/
		final captureRejectionSymbol : js.lib.Symbol;
		/**
			Value: [boolean](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Boolean_type)
			
			Change the default `captureRejections` option on all new `EventEmitter` objects.
		**/
		var captureRejections : Bool;
		/**
			By default, a maximum of `10` listeners can be registered for any single
			event. This limit can be changed for individual `EventEmitter` instances
			using the `emitter.setMaxListeners(n)` method. To change the default
			for _all_`EventEmitter` instances, the `events.defaultMaxListeners`property can be used. If this value is not a positive number, a `RangeError`is thrown.
			
			Take caution when setting the `events.defaultMaxListeners` because the
			change affects _all_`EventEmitter` instances, including those created before
			the change is made. However, calling `emitter.setMaxListeners(n)` still has
			precedence over `events.defaultMaxListeners`.
			
			This is not a hard limit. The `EventEmitter` instance will allow
			more listeners to be added but will output a trace warning to stderr indicating
			that a "possible EventEmitter memory leak" has been detected. For any single`EventEmitter`, the `emitter.getMaxListeners()` and `emitter.setMaxListeners()`methods can be used to
			temporarily avoid this warning:
			
			```js
			import { EventEmitter } from 'node:events';
			const emitter = new EventEmitter();
			emitter.setMaxListeners(emitter.getMaxListeners() + 1);
			emitter.once('event', () => {
			   // do stuff
			   emitter.setMaxListeners(Math.max(emitter.getMaxListeners() - 1, 0));
			});
			```
			
			The `--trace-warnings` command-line flag can be used to display the
			stack trace for such warnings.
			
			The emitted warning can be inspected with `process.on('warning')` and will
			have the additional `emitter`, `type`, and `count` properties, referring to
			the event emitter instance, the event's name and the number of attached
			listeners, respectively.
			Its `name` property is set to `'MaxListenersExceededWarning'`.
		**/
		var defaultMaxListeners : Float;
	};
	@:optional
	var Http1ServerResponse : {
		var prototype : node.http.ServerResponse<Dynamic>;
		/**
			A utility method for creating a `Writable` from a web `WritableStream`.
		**/
		function fromWeb(writableStream:node.stream.web.WritableStream<Dynamic>, ?options:{ /** When provided the corresponding `AbortController` can be used to cancel an asynchronous action. **/ @:optional var signal : js.html.AbortSignal; @:optional var highWaterMark : Float; @:optional var objectMode : Bool; @:optional var decodeStrings : Bool; }):node.stream.Writable;
		/**
			A utility method for creating a web `WritableStream` from a `Writable`.
		**/
		function toWeb(streamWritable:node.stream.Writable):node.stream.web.WritableStream<Dynamic>;
		/**
			A stream to attach a signal to.
			
			Attaches an AbortSignal to a readable or writeable stream. This lets code
			control stream destruction using an `AbortController`.
			
			Calling `abort` on the `AbortController` corresponding to the passed`AbortSignal` will behave the same way as calling `.destroy(new AbortError())`on the stream, and `controller.error(new
			AbortError())` for webstreams.
			
			```js
			const fs = require('node:fs');
			
			const controller = new AbortController();
			const read = addAbortSignal(
			   controller.signal,
			   fs.createReadStream(('object.json')),
			);
			// Later, abort the operation closing the stream
			controller.abort();
			```
			
			Or using an `AbortSignal` with a readable stream as an async iterable:
			
			```js
			const controller = new AbortController();
			setTimeout(() => controller.abort(), 10_000); // set a timeout
			const stream = addAbortSignal(
			   controller.signal,
			   fs.createReadStream(('object.json')),
			);
			(async () => {
			   try {
			     for await (const chunk of stream) {
			       await process(chunk);
			     }
			   } catch (e) {
			     if (e.name === 'AbortError') {
			       // The operation was cancelled
			     } else {
			       throw e;
			     }
			   }
			})();
			```
			
			Or using an `AbortSignal` with a ReadableStream:
			
			```js
			const controller = new AbortController();
			const rs = new ReadableStream({
			   start(controller) {
			     controller.enqueue('hello');
			     controller.enqueue('world');
			     controller.close();
			   },
			});
			
			addAbortSignal(controller.signal, rs);
			
			finished(rs, (err) => {
			   if (err) {
			     if (err.name === 'AbortError') {
			       // The operation was cancelled
			     }
			   }
			});
			
			const reader = rs.getReader();
			
			reader.read().then(({ value, done }) => {
			   console.log(value); // hello
			   console.log(done); // false
			   controller.abort();
			});
			```
		**/
		function addAbortSignal<T>(signal:js.html.AbortSignal, stream:T):T;
		/**
			Returns the default highWaterMark used by streams.
			Defaults to `16384` (16 KiB), or `16` for `objectMode`.
		**/
		function getDefaultHighWaterMark(objectMode:Bool):Float;
		/**
			Sets the default highWaterMark used by streams.
		**/
		function setDefaultHighWaterMark(objectMode:Bool, value:Float):Void;
		/**
			A readable and/or writable stream/webstream.
			
			A function to get notified when a stream is no longer readable, writable
			or has experienced an error or a premature close event.
			
			```js
			const { finished } = require('node:stream');
			const fs = require('node:fs');
			
			const rs = fs.createReadStream('archive.tar');
			
			finished(rs, (err) => {
			   if (err) {
			     console.error('Stream failed.', err);
			   } else {
			     console.log('Stream is done reading.');
			   }
			});
			
			rs.resume(); // Drain the stream.
			```
			
			Especially useful in error handling scenarios where a stream is destroyed
			prematurely (like an aborted HTTP request), and will not emit `'end'`or `'finish'`.
			
			The `finished` API provides `promise version`.
			
			`stream.finished()` leaves dangling event listeners (in particular`'error'`, `'end'`, `'finish'` and `'close'`) after `callback` has been
			invoked. The reason for this is so that unexpected `'error'` events (due to
			incorrect stream implementations) do not cause unexpected crashes.
			If this is unwanted behavior then the returned cleanup function needs to be
			invoked in the callback:
			
			```js
			const cleanup = finished(rs, (err) => {
			   cleanup();
			   // ...
			});
			```
		**/
		@:overload(function(stream:ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>, callback:ts.AnyOf2<() -> Void, (err:global.nodejs.ErrnoException) -> Void>):() -> Void { })
		function finished(stream:ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>, options:node.stream.FinishedOptions, callback:ts.AnyOf2<() -> Void, (err:global.nodejs.ErrnoException) -> Void>):() -> Void;
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
		@:overload(function<A, T1, B>(source:A, transform1:T1, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function<A, T1, T2, B>(source:A, transform1:T1, transform2:T2, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function<A, T1, T2, T3, B>(source:A, transform1:T1, transform2:T2, transform3:T3, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function<A, T1, T2, T3, T4, B>(source:A, transform1:T1, transform2:T2, transform3:T3, transform4:T4, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function(streams:haxe.ds.ReadOnlyArray<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>>, ?callback:(err:Null<global.nodejs.ErrnoException>) -> Void):global.nodejs.WritableStream { })
		@:overload(function(stream1:global.nodejs.ReadableStream, stream2:ts.AnyOf2<global.nodejs.WritableStream, global.nodejs.ReadWriteStream>, streams:haxe.extern.Rest<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadWriteStream, (err:Null<global.nodejs.ErrnoException>) -> Void>>):global.nodejs.WritableStream { })
		function pipeline<A, B>(source:A, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic;
		/**
			Returns whether the stream has encountered an error.
		**/
		function isErrored(stream:ts.AnyOf4<global.nodejs.WritableStream, global.nodejs.ReadableStream, node.stream.Readable, node.stream.Writable>):Bool;
		/**
			Returns whether the stream is readable.
		**/
		function isReadable(stream:ts.AnyOf2<global.nodejs.ReadableStream, node.stream.Readable>):Bool;
		final promises : {
			function finished(stream:ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>, ?options:node.stream.FinishedOptions):js.lib.Promise<ts.Undefined>;
			@:overload(function<A, T1, B>(source:A, transform1:T1, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function<A, T1, T2, B>(source:A, transform1:T1, transform2:T2, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function<A, T1, T2, T3, B>(source:A, transform1:T1, transform2:T2, transform3:T3, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function<A, T1, T2, T3, T4, B>(source:A, transform1:T1, transform2:T2, transform3:T3, transform4:T4, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function(streams:haxe.ds.ReadOnlyArray<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>>, ?options:node.stream.PipelineOptions):js.lib.Promise<ts.Undefined> { })
			@:overload(function(stream1:global.nodejs.ReadableStream, stream2:ts.AnyOf2<global.nodejs.WritableStream, global.nodejs.ReadWriteStream>, streams:haxe.extern.Rest<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadWriteStream, node.stream.PipelineOptions>>):js.lib.Promise<ts.Undefined> { })
			function pipeline<A, B>(source:A, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B>;
		};
		final consumers : {
			function buffer(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<node.buffer.Buffer>;
			function text(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<String>;
			function arrayBuffer(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<js.lib.ArrayBuffer>;
			function blob(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<node.buffer.Blob>;
			function json(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<Any>;
		};
		/**
			Creates a `Promise` that is fulfilled when the `EventEmitter` emits the given
			event or that is rejected if the `EventEmitter` emits `'error'` while waiting.
			The `Promise` will resolve with an array of all the arguments emitted to the
			given event.
			
			This method is intentionally generic and works with the web platform [EventTarget](https://dom.spec.whatwg.org/#interface-eventtarget) interface, which has no special`'error'` event
			semantics and does not listen to the `'error'` event.
			
			```js
			import { once, EventEmitter } from 'node:events';
			import process from 'node:process';
			
			const ee = new EventEmitter();
			
			process.nextTick(() => {
			   ee.emit('myevent', 42);
			});
			
			const [value] = await once(ee, 'myevent');
			console.log(value);
			
			const err = new Error('kaboom');
			process.nextTick(() => {
			   ee.emit('error', err);
			});
			
			try {
			   await once(ee, 'myevent');
			} catch (err) {
			   console.error('error happened', err);
			}
			```
			
			The special handling of the `'error'` event is only used when `events.once()`is used to wait for another event. If `events.once()` is used to wait for the
			'`error'` event itself, then it is treated as any other kind of event without
			special handling:
			
			```js
			import { EventEmitter, once } from 'node:events';
			
			const ee = new EventEmitter();
			
			once(ee, 'error')
			   .then(([err]) => console.log('ok', err.message))
			   .catch((err) => console.error('error', err.message));
			
			ee.emit('error', new Error('boom'));
			
			// Prints: ok boom
			```
			
			An `AbortSignal` can be used to cancel waiting for the event:
			
			```js
			import { EventEmitter, once } from 'node:events';
			
			const ee = new EventEmitter();
			const ac = new AbortController();
			
			async function foo(emitter, event, signal) {
			   try {
			     await once(emitter, event, { signal });
			     console.log('event emitted!');
			   } catch (error) {
			     if (error.name === 'AbortError') {
			       console.error('Waiting for the event was canceled!');
			     } else {
			       console.error('There was an error', error.message);
			     }
			   }
			}
			
			foo(ee, 'foo', ac.signal);
			ac.abort(); // Abort waiting for the event
			ee.emit('foo'); // Prints: Waiting for the event was canceled!
			```
		**/
		@:overload(function(emitter:SecureServerOptions, eventName:String, ?options:SecureServerOptions):js.lib.Promise<Array<Dynamic>> { })
		function once(emitter:SecureServerOptions, eventName:ts.AnyOf2<String, js.lib.Symbol>, ?options:SecureServerOptions):js.lib.Promise<Array<Dynamic>>;
		/**
			```js
			import { on, EventEmitter } from 'node:events';
			import process from 'node:process';
			
			const ee = new EventEmitter();
			
			// Emit later on
			process.nextTick(() => {
			   ee.emit('foo', 'bar');
			   ee.emit('foo', 42);
			});
			
			for await (const event of on(ee, 'foo')) {
			   // The execution of this inner block is synchronous and it
			   // processes one event at a time (even with await). Do not use
			   // if concurrent execution is required.
			   console.log(event); // prints ['bar'] [42]
			}
			// Unreachable here
			```
			
			Returns an `AsyncIterator` that iterates `eventName` events. It will throw
			if the `EventEmitter` emits `'error'`. It removes all listeners when
			exiting the loop. The `value` returned by each iteration is an array
			composed of the emitted event arguments.
			
			An `AbortSignal` can be used to cancel waiting on events:
			
			```js
			import { on, EventEmitter } from 'node:events';
			import process from 'node:process';
			
			const ac = new AbortController();
			
			(async () => {
			   const ee = new EventEmitter();
			
			   // Emit later on
			   process.nextTick(() => {
			     ee.emit('foo', 'bar');
			     ee.emit('foo', 42);
			   });
			
			   for await (const event of on(ee, 'foo', { signal: ac.signal })) {
			     // The execution of this inner block is synchronous and it
			     // processes one event at a time (even with await). Do not use
			     // if concurrent execution is required.
			     console.log(event); // prints ['bar'] [42]
			   }
			   // Unreachable here
			})();
			
			process.nextTick(() => ac.abort());
			```
		**/
		function on(emitter:global.nodejs.EventEmitter, eventName:String, ?options:SecureServerOptions):js.lib.AsyncIterableIterator<Dynamic>;
		/**
			A class method that returns the number of listeners for the given `eventName`registered on the given `emitter`.
			
			```js
			import { EventEmitter, listenerCount } from 'node:events';
			
			const myEmitter = new EventEmitter();
			myEmitter.on('event', () => {});
			myEmitter.on('event', () => {});
			console.log(listenerCount(myEmitter, 'event'));
			// Prints: 2
			```
		**/
		function listenerCount(emitter:global.nodejs.EventEmitter, eventName:ts.AnyOf2<String, js.lib.Symbol>):Float;
		/**
			Returns a copy of the array of listeners for the event named `eventName`.
			
			For `EventEmitter`s this behaves exactly the same as calling `.listeners` on
			the emitter.
			
			For `EventTarget`s this is the only way to get the event listeners for the
			event target. This is useful for debugging and diagnostic purposes.
			
			```js
			import { getEventListeners, EventEmitter } from 'node:events';
			
			{
			   const ee = new EventEmitter();
			   const listener = () => console.log('Events are fun');
			   ee.on('foo', listener);
			   console.log(getEventListeners(ee, 'foo')); // [ [Function: listener] ]
			}
			{
			   const et = new EventTarget();
			   const listener = () => console.log('Events are fun');
			   et.addEventListener('foo', listener);
			   console.log(getEventListeners(et, 'foo')); // [ [Function: listener] ]
			}
			```
		**/
		function getEventListeners(emitter:ts.AnyOf2<global.nodejs.EventEmitter, SecureServerOptions>, name:ts.AnyOf2<String, js.lib.Symbol>):Array<haxe.Constraints.Function>;
		/**
			Returns the currently set max amount of listeners.
			
			For `EventEmitter`s this behaves exactly the same as calling `.getMaxListeners` on
			the emitter.
			
			For `EventTarget`s this is the only way to get the max event listeners for the
			event target. If the number of event handlers on a single EventTarget exceeds
			the max set, the EventTarget will print a warning.
			
			```js
			import { getMaxListeners, setMaxListeners, EventEmitter } from 'node:events';
			
			{
			   const ee = new EventEmitter();
			   console.log(getMaxListeners(ee)); // 10
			   setMaxListeners(11, ee);
			   console.log(getMaxListeners(ee)); // 11
			}
			{
			   const et = new EventTarget();
			   console.log(getMaxListeners(et)); // 10
			   setMaxListeners(11, et);
			   console.log(getMaxListeners(et)); // 11
			}
			```
		**/
		function getMaxListeners(emitter:ts.AnyOf2<global.nodejs.EventEmitter, SecureServerOptions>):Float;
		/**
			```js
			import { setMaxListeners, EventEmitter } from 'node:events';
			
			const target = new EventTarget();
			const emitter = new EventEmitter();
			
			setMaxListeners(5, target, emitter);
			```
		**/
		function setMaxListeners(?n:Float, eventTargets:haxe.extern.Rest<ts.AnyOf2<global.nodejs.EventEmitter, SecureServerOptions>>):Void;
		/**
			Listens once to the `abort` event on the provided `signal`.
			
			Listening to the `abort` event on abort signals is unsafe and may
			lead to resource leaks since another third party with the signal can
			call `e.stopImmediatePropagation()`. Unfortunately Node.js cannot change
			this since it would violate the web standard. Additionally, the original
			API makes it easy to forget to remove listeners.
			
			This API allows safely using `AbortSignal`s in Node.js APIs by solving these
			two issues by listening to the event such that `stopImmediatePropagation` does
			not prevent the listener from running.
			
			Returns a disposable so that it may be unsubscribed from more easily.
			
			```js
			import { addAbortListener } from 'node:events';
			
			function example(signal) {
			   let disposable;
			   try {
			     signal.addEventListener('abort', (e) => e.stopImmediatePropagation());
			     disposable = addAbortListener(signal, (e) => {
			       // Do something when signal is aborted.
			     });
			   } finally {
			     disposable?.[Symbol.dispose]();
			   }
			}
			```
		**/
		function addAbortListener(signal:js.html.AbortSignal, resource:(event:js.html.Event) -> Void):global.Disposable;
		/**
			This symbol shall be used to install a listener for only monitoring `'error'`events. Listeners installed using this symbol are called before the regular`'error'` listeners are called.
			
			Installing a listener using this symbol does not change the behavior once an`'error'` event is emitted. Therefore, the process will still crash if no
			regular `'error'` listener is installed.
		**/
		final errorMonitor : js.lib.Symbol;
		/**
			Value: `Symbol.for('nodejs.rejection')`
			
			See how to write a custom `rejection handler`.
		**/
		final captureRejectionSymbol : js.lib.Symbol;
		/**
			Value: [boolean](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Boolean_type)
			
			Change the default `captureRejections` option on all new `EventEmitter` objects.
		**/
		var captureRejections : Bool;
		/**
			By default, a maximum of `10` listeners can be registered for any single
			event. This limit can be changed for individual `EventEmitter` instances
			using the `emitter.setMaxListeners(n)` method. To change the default
			for _all_`EventEmitter` instances, the `events.defaultMaxListeners`property can be used. If this value is not a positive number, a `RangeError`is thrown.
			
			Take caution when setting the `events.defaultMaxListeners` because the
			change affects _all_`EventEmitter` instances, including those created before
			the change is made. However, calling `emitter.setMaxListeners(n)` still has
			precedence over `events.defaultMaxListeners`.
			
			This is not a hard limit. The `EventEmitter` instance will allow
			more listeners to be added but will output a trace warning to stderr indicating
			that a "possible EventEmitter memory leak" has been detected. For any single`EventEmitter`, the `emitter.getMaxListeners()` and `emitter.setMaxListeners()`methods can be used to
			temporarily avoid this warning:
			
			```js
			import { EventEmitter } from 'node:events';
			const emitter = new EventEmitter();
			emitter.setMaxListeners(emitter.getMaxListeners() + 1);
			emitter.once('event', () => {
			   // do stuff
			   emitter.setMaxListeners(Math.max(emitter.getMaxListeners() - 1, 0));
			});
			```
			
			The `--trace-warnings` command-line flag can be used to display the
			stack trace for such warnings.
			
			The emitted warning can be inspected with `process.on('warning')` and will
			have the additional `emitter`, `type`, and `count` properties, referring to
			the event emitter instance, the event's name and the number of attached
			listeners, respectively.
			Its `name` property is set to `'MaxListenersExceededWarning'`.
		**/
		var defaultMaxListeners : Float;
	};
	@:optional
	var Http2ServerRequest : {
		var prototype : Http2ServerRequest;
		/**
			A utility method for creating a `Readable` from a web `ReadableStream`.
		**/
		function fromWeb(readableStream:node.stream.web.ReadableStream<Dynamic>, ?options:{ /** When provided the corresponding `AbortController` can be used to cancel an asynchronous action. **/ @:optional var signal : js.html.AbortSignal; @:optional var encoding : global.nodejs.BufferEncoding; @:optional var highWaterMark : Float; @:optional var objectMode : Bool; }):node.stream.Readable;
		/**
			A utility method for creating a web `ReadableStream` from a `Readable`.
		**/
		function toWeb(streamReadable:node.stream.Readable):node.stream.web.ReadableStream<Dynamic>;
		/**
			A utility method for creating Readable Streams out of iterators.
		**/
		function from(iterable:ts.AnyOf2<Iterable<Dynamic>, js.lib.AsyncIterable<Dynamic>>, ?options:node.stream.ReadableOptions):node.stream.Readable;
		/**
			Returns whether the stream has been read from or cancelled.
		**/
		function isDisturbed(stream:ts.AnyOf2<global.nodejs.ReadableStream, node.stream.Readable>):Bool;
		/**
			A stream to attach a signal to.
			
			Attaches an AbortSignal to a readable or writeable stream. This lets code
			control stream destruction using an `AbortController`.
			
			Calling `abort` on the `AbortController` corresponding to the passed`AbortSignal` will behave the same way as calling `.destroy(new AbortError())`on the stream, and `controller.error(new
			AbortError())` for webstreams.
			
			```js
			const fs = require('node:fs');
			
			const controller = new AbortController();
			const read = addAbortSignal(
			   controller.signal,
			   fs.createReadStream(('object.json')),
			);
			// Later, abort the operation closing the stream
			controller.abort();
			```
			
			Or using an `AbortSignal` with a readable stream as an async iterable:
			
			```js
			const controller = new AbortController();
			setTimeout(() => controller.abort(), 10_000); // set a timeout
			const stream = addAbortSignal(
			   controller.signal,
			   fs.createReadStream(('object.json')),
			);
			(async () => {
			   try {
			     for await (const chunk of stream) {
			       await process(chunk);
			     }
			   } catch (e) {
			     if (e.name === 'AbortError') {
			       // The operation was cancelled
			     } else {
			       throw e;
			     }
			   }
			})();
			```
			
			Or using an `AbortSignal` with a ReadableStream:
			
			```js
			const controller = new AbortController();
			const rs = new ReadableStream({
			   start(controller) {
			     controller.enqueue('hello');
			     controller.enqueue('world');
			     controller.close();
			   },
			});
			
			addAbortSignal(controller.signal, rs);
			
			finished(rs, (err) => {
			   if (err) {
			     if (err.name === 'AbortError') {
			       // The operation was cancelled
			     }
			   }
			});
			
			const reader = rs.getReader();
			
			reader.read().then(({ value, done }) => {
			   console.log(value); // hello
			   console.log(done); // false
			   controller.abort();
			});
			```
		**/
		function addAbortSignal<T>(signal:js.html.AbortSignal, stream:T):T;
		/**
			Returns the default highWaterMark used by streams.
			Defaults to `16384` (16 KiB), or `16` for `objectMode`.
		**/
		function getDefaultHighWaterMark(objectMode:Bool):Float;
		/**
			Sets the default highWaterMark used by streams.
		**/
		function setDefaultHighWaterMark(objectMode:Bool, value:Float):Void;
		/**
			A readable and/or writable stream/webstream.
			
			A function to get notified when a stream is no longer readable, writable
			or has experienced an error or a premature close event.
			
			```js
			const { finished } = require('node:stream');
			const fs = require('node:fs');
			
			const rs = fs.createReadStream('archive.tar');
			
			finished(rs, (err) => {
			   if (err) {
			     console.error('Stream failed.', err);
			   } else {
			     console.log('Stream is done reading.');
			   }
			});
			
			rs.resume(); // Drain the stream.
			```
			
			Especially useful in error handling scenarios where a stream is destroyed
			prematurely (like an aborted HTTP request), and will not emit `'end'`or `'finish'`.
			
			The `finished` API provides `promise version`.
			
			`stream.finished()` leaves dangling event listeners (in particular`'error'`, `'end'`, `'finish'` and `'close'`) after `callback` has been
			invoked. The reason for this is so that unexpected `'error'` events (due to
			incorrect stream implementations) do not cause unexpected crashes.
			If this is unwanted behavior then the returned cleanup function needs to be
			invoked in the callback:
			
			```js
			const cleanup = finished(rs, (err) => {
			   cleanup();
			   // ...
			});
			```
		**/
		@:overload(function(stream:ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>, callback:ts.AnyOf2<() -> Void, (err:global.nodejs.ErrnoException) -> Void>):() -> Void { })
		function finished(stream:ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>, options:node.stream.FinishedOptions, callback:ts.AnyOf2<() -> Void, (err:global.nodejs.ErrnoException) -> Void>):() -> Void;
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
		@:overload(function<A, T1, B>(source:A, transform1:T1, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function<A, T1, T2, B>(source:A, transform1:T1, transform2:T2, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function<A, T1, T2, T3, B>(source:A, transform1:T1, transform2:T2, transform3:T3, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function<A, T1, T2, T3, T4, B>(source:A, transform1:T1, transform2:T2, transform3:T3, transform4:T4, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function(streams:haxe.ds.ReadOnlyArray<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>>, ?callback:(err:Null<global.nodejs.ErrnoException>) -> Void):global.nodejs.WritableStream { })
		@:overload(function(stream1:global.nodejs.ReadableStream, stream2:ts.AnyOf2<global.nodejs.WritableStream, global.nodejs.ReadWriteStream>, streams:haxe.extern.Rest<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadWriteStream, (err:Null<global.nodejs.ErrnoException>) -> Void>>):global.nodejs.WritableStream { })
		function pipeline<A, B>(source:A, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic;
		/**
			Returns whether the stream has encountered an error.
		**/
		function isErrored(stream:ts.AnyOf4<global.nodejs.WritableStream, global.nodejs.ReadableStream, node.stream.Readable, node.stream.Writable>):Bool;
		/**
			Returns whether the stream is readable.
		**/
		function isReadable(stream:ts.AnyOf2<global.nodejs.ReadableStream, node.stream.Readable>):Bool;
		final promises : {
			function finished(stream:ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>, ?options:node.stream.FinishedOptions):js.lib.Promise<ts.Undefined>;
			@:overload(function<A, T1, B>(source:A, transform1:T1, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function<A, T1, T2, B>(source:A, transform1:T1, transform2:T2, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function<A, T1, T2, T3, B>(source:A, transform1:T1, transform2:T2, transform3:T3, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function<A, T1, T2, T3, T4, B>(source:A, transform1:T1, transform2:T2, transform3:T3, transform4:T4, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function(streams:haxe.ds.ReadOnlyArray<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>>, ?options:node.stream.PipelineOptions):js.lib.Promise<ts.Undefined> { })
			@:overload(function(stream1:global.nodejs.ReadableStream, stream2:ts.AnyOf2<global.nodejs.WritableStream, global.nodejs.ReadWriteStream>, streams:haxe.extern.Rest<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadWriteStream, node.stream.PipelineOptions>>):js.lib.Promise<ts.Undefined> { })
			function pipeline<A, B>(source:A, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B>;
		};
		final consumers : {
			function buffer(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<node.buffer.Buffer>;
			function text(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<String>;
			function arrayBuffer(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<js.lib.ArrayBuffer>;
			function blob(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<node.buffer.Blob>;
			function json(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<Any>;
		};
		/**
			Creates a `Promise` that is fulfilled when the `EventEmitter` emits the given
			event or that is rejected if the `EventEmitter` emits `'error'` while waiting.
			The `Promise` will resolve with an array of all the arguments emitted to the
			given event.
			
			This method is intentionally generic and works with the web platform [EventTarget](https://dom.spec.whatwg.org/#interface-eventtarget) interface, which has no special`'error'` event
			semantics and does not listen to the `'error'` event.
			
			```js
			import { once, EventEmitter } from 'node:events';
			import process from 'node:process';
			
			const ee = new EventEmitter();
			
			process.nextTick(() => {
			   ee.emit('myevent', 42);
			});
			
			const [value] = await once(ee, 'myevent');
			console.log(value);
			
			const err = new Error('kaboom');
			process.nextTick(() => {
			   ee.emit('error', err);
			});
			
			try {
			   await once(ee, 'myevent');
			} catch (err) {
			   console.error('error happened', err);
			}
			```
			
			The special handling of the `'error'` event is only used when `events.once()`is used to wait for another event. If `events.once()` is used to wait for the
			'`error'` event itself, then it is treated as any other kind of event without
			special handling:
			
			```js
			import { EventEmitter, once } from 'node:events';
			
			const ee = new EventEmitter();
			
			once(ee, 'error')
			   .then(([err]) => console.log('ok', err.message))
			   .catch((err) => console.error('error', err.message));
			
			ee.emit('error', new Error('boom'));
			
			// Prints: ok boom
			```
			
			An `AbortSignal` can be used to cancel waiting for the event:
			
			```js
			import { EventEmitter, once } from 'node:events';
			
			const ee = new EventEmitter();
			const ac = new AbortController();
			
			async function foo(emitter, event, signal) {
			   try {
			     await once(emitter, event, { signal });
			     console.log('event emitted!');
			   } catch (error) {
			     if (error.name === 'AbortError') {
			       console.error('Waiting for the event was canceled!');
			     } else {
			       console.error('There was an error', error.message);
			     }
			   }
			}
			
			foo(ee, 'foo', ac.signal);
			ac.abort(); // Abort waiting for the event
			ee.emit('foo'); // Prints: Waiting for the event was canceled!
			```
		**/
		@:overload(function(emitter:SecureServerOptions, eventName:String, ?options:SecureServerOptions):js.lib.Promise<Array<Dynamic>> { })
		function once(emitter:SecureServerOptions, eventName:ts.AnyOf2<String, js.lib.Symbol>, ?options:SecureServerOptions):js.lib.Promise<Array<Dynamic>>;
		/**
			```js
			import { on, EventEmitter } from 'node:events';
			import process from 'node:process';
			
			const ee = new EventEmitter();
			
			// Emit later on
			process.nextTick(() => {
			   ee.emit('foo', 'bar');
			   ee.emit('foo', 42);
			});
			
			for await (const event of on(ee, 'foo')) {
			   // The execution of this inner block is synchronous and it
			   // processes one event at a time (even with await). Do not use
			   // if concurrent execution is required.
			   console.log(event); // prints ['bar'] [42]
			}
			// Unreachable here
			```
			
			Returns an `AsyncIterator` that iterates `eventName` events. It will throw
			if the `EventEmitter` emits `'error'`. It removes all listeners when
			exiting the loop. The `value` returned by each iteration is an array
			composed of the emitted event arguments.
			
			An `AbortSignal` can be used to cancel waiting on events:
			
			```js
			import { on, EventEmitter } from 'node:events';
			import process from 'node:process';
			
			const ac = new AbortController();
			
			(async () => {
			   const ee = new EventEmitter();
			
			   // Emit later on
			   process.nextTick(() => {
			     ee.emit('foo', 'bar');
			     ee.emit('foo', 42);
			   });
			
			   for await (const event of on(ee, 'foo', { signal: ac.signal })) {
			     // The execution of this inner block is synchronous and it
			     // processes one event at a time (even with await). Do not use
			     // if concurrent execution is required.
			     console.log(event); // prints ['bar'] [42]
			   }
			   // Unreachable here
			})();
			
			process.nextTick(() => ac.abort());
			```
		**/
		function on(emitter:global.nodejs.EventEmitter, eventName:String, ?options:SecureServerOptions):js.lib.AsyncIterableIterator<Dynamic>;
		/**
			A class method that returns the number of listeners for the given `eventName`registered on the given `emitter`.
			
			```js
			import { EventEmitter, listenerCount } from 'node:events';
			
			const myEmitter = new EventEmitter();
			myEmitter.on('event', () => {});
			myEmitter.on('event', () => {});
			console.log(listenerCount(myEmitter, 'event'));
			// Prints: 2
			```
		**/
		function listenerCount(emitter:global.nodejs.EventEmitter, eventName:ts.AnyOf2<String, js.lib.Symbol>):Float;
		/**
			Returns a copy of the array of listeners for the event named `eventName`.
			
			For `EventEmitter`s this behaves exactly the same as calling `.listeners` on
			the emitter.
			
			For `EventTarget`s this is the only way to get the event listeners for the
			event target. This is useful for debugging and diagnostic purposes.
			
			```js
			import { getEventListeners, EventEmitter } from 'node:events';
			
			{
			   const ee = new EventEmitter();
			   const listener = () => console.log('Events are fun');
			   ee.on('foo', listener);
			   console.log(getEventListeners(ee, 'foo')); // [ [Function: listener] ]
			}
			{
			   const et = new EventTarget();
			   const listener = () => console.log('Events are fun');
			   et.addEventListener('foo', listener);
			   console.log(getEventListeners(et, 'foo')); // [ [Function: listener] ]
			}
			```
		**/
		function getEventListeners(emitter:ts.AnyOf2<global.nodejs.EventEmitter, SecureServerOptions>, name:ts.AnyOf2<String, js.lib.Symbol>):Array<haxe.Constraints.Function>;
		/**
			Returns the currently set max amount of listeners.
			
			For `EventEmitter`s this behaves exactly the same as calling `.getMaxListeners` on
			the emitter.
			
			For `EventTarget`s this is the only way to get the max event listeners for the
			event target. If the number of event handlers on a single EventTarget exceeds
			the max set, the EventTarget will print a warning.
			
			```js
			import { getMaxListeners, setMaxListeners, EventEmitter } from 'node:events';
			
			{
			   const ee = new EventEmitter();
			   console.log(getMaxListeners(ee)); // 10
			   setMaxListeners(11, ee);
			   console.log(getMaxListeners(ee)); // 11
			}
			{
			   const et = new EventTarget();
			   console.log(getMaxListeners(et)); // 10
			   setMaxListeners(11, et);
			   console.log(getMaxListeners(et)); // 11
			}
			```
		**/
		function getMaxListeners(emitter:ts.AnyOf2<global.nodejs.EventEmitter, SecureServerOptions>):Float;
		/**
			```js
			import { setMaxListeners, EventEmitter } from 'node:events';
			
			const target = new EventTarget();
			const emitter = new EventEmitter();
			
			setMaxListeners(5, target, emitter);
			```
		**/
		function setMaxListeners(?n:Float, eventTargets:haxe.extern.Rest<ts.AnyOf2<global.nodejs.EventEmitter, SecureServerOptions>>):Void;
		/**
			Listens once to the `abort` event on the provided `signal`.
			
			Listening to the `abort` event on abort signals is unsafe and may
			lead to resource leaks since another third party with the signal can
			call `e.stopImmediatePropagation()`. Unfortunately Node.js cannot change
			this since it would violate the web standard. Additionally, the original
			API makes it easy to forget to remove listeners.
			
			This API allows safely using `AbortSignal`s in Node.js APIs by solving these
			two issues by listening to the event such that `stopImmediatePropagation` does
			not prevent the listener from running.
			
			Returns a disposable so that it may be unsubscribed from more easily.
			
			```js
			import { addAbortListener } from 'node:events';
			
			function example(signal) {
			   let disposable;
			   try {
			     signal.addEventListener('abort', (e) => e.stopImmediatePropagation());
			     disposable = addAbortListener(signal, (e) => {
			       // Do something when signal is aborted.
			     });
			   } finally {
			     disposable?.[Symbol.dispose]();
			   }
			}
			```
		**/
		function addAbortListener(signal:js.html.AbortSignal, resource:(event:js.html.Event) -> Void):global.Disposable;
		/**
			This symbol shall be used to install a listener for only monitoring `'error'`events. Listeners installed using this symbol are called before the regular`'error'` listeners are called.
			
			Installing a listener using this symbol does not change the behavior once an`'error'` event is emitted. Therefore, the process will still crash if no
			regular `'error'` listener is installed.
		**/
		final errorMonitor : js.lib.Symbol;
		/**
			Value: `Symbol.for('nodejs.rejection')`
			
			See how to write a custom `rejection handler`.
		**/
		final captureRejectionSymbol : js.lib.Symbol;
		/**
			Value: [boolean](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Boolean_type)
			
			Change the default `captureRejections` option on all new `EventEmitter` objects.
		**/
		var captureRejections : Bool;
		/**
			By default, a maximum of `10` listeners can be registered for any single
			event. This limit can be changed for individual `EventEmitter` instances
			using the `emitter.setMaxListeners(n)` method. To change the default
			for _all_`EventEmitter` instances, the `events.defaultMaxListeners`property can be used. If this value is not a positive number, a `RangeError`is thrown.
			
			Take caution when setting the `events.defaultMaxListeners` because the
			change affects _all_`EventEmitter` instances, including those created before
			the change is made. However, calling `emitter.setMaxListeners(n)` still has
			precedence over `events.defaultMaxListeners`.
			
			This is not a hard limit. The `EventEmitter` instance will allow
			more listeners to be added but will output a trace warning to stderr indicating
			that a "possible EventEmitter memory leak" has been detected. For any single`EventEmitter`, the `emitter.getMaxListeners()` and `emitter.setMaxListeners()`methods can be used to
			temporarily avoid this warning:
			
			```js
			import { EventEmitter } from 'node:events';
			const emitter = new EventEmitter();
			emitter.setMaxListeners(emitter.getMaxListeners() + 1);
			emitter.once('event', () => {
			   // do stuff
			   emitter.setMaxListeners(Math.max(emitter.getMaxListeners() - 1, 0));
			});
			```
			
			The `--trace-warnings` command-line flag can be used to display the
			stack trace for such warnings.
			
			The emitted warning can be inspected with `process.on('warning')` and will
			have the additional `emitter`, `type`, and `count` properties, referring to
			the event emitter instance, the event's name and the number of attached
			listeners, respectively.
			Its `name` property is set to `'MaxListenersExceededWarning'`.
		**/
		var defaultMaxListeners : Float;
	};
	@:optional
	var Http2ServerResponse : {
		var prototype : Http2ServerResponse;
		/**
			A utility method for creating a `Writable` from a web `WritableStream`.
		**/
		function fromWeb(writableStream:node.stream.web.WritableStream<Dynamic>, ?options:{ /** When provided the corresponding `AbortController` can be used to cancel an asynchronous action. **/ @:optional var signal : js.html.AbortSignal; @:optional var highWaterMark : Float; @:optional var objectMode : Bool; @:optional var decodeStrings : Bool; }):node.stream.Writable;
		/**
			A utility method for creating a web `WritableStream` from a `Writable`.
		**/
		function toWeb(streamWritable:node.stream.Writable):node.stream.web.WritableStream<Dynamic>;
		/**
			A stream to attach a signal to.
			
			Attaches an AbortSignal to a readable or writeable stream. This lets code
			control stream destruction using an `AbortController`.
			
			Calling `abort` on the `AbortController` corresponding to the passed`AbortSignal` will behave the same way as calling `.destroy(new AbortError())`on the stream, and `controller.error(new
			AbortError())` for webstreams.
			
			```js
			const fs = require('node:fs');
			
			const controller = new AbortController();
			const read = addAbortSignal(
			   controller.signal,
			   fs.createReadStream(('object.json')),
			);
			// Later, abort the operation closing the stream
			controller.abort();
			```
			
			Or using an `AbortSignal` with a readable stream as an async iterable:
			
			```js
			const controller = new AbortController();
			setTimeout(() => controller.abort(), 10_000); // set a timeout
			const stream = addAbortSignal(
			   controller.signal,
			   fs.createReadStream(('object.json')),
			);
			(async () => {
			   try {
			     for await (const chunk of stream) {
			       await process(chunk);
			     }
			   } catch (e) {
			     if (e.name === 'AbortError') {
			       // The operation was cancelled
			     } else {
			       throw e;
			     }
			   }
			})();
			```
			
			Or using an `AbortSignal` with a ReadableStream:
			
			```js
			const controller = new AbortController();
			const rs = new ReadableStream({
			   start(controller) {
			     controller.enqueue('hello');
			     controller.enqueue('world');
			     controller.close();
			   },
			});
			
			addAbortSignal(controller.signal, rs);
			
			finished(rs, (err) => {
			   if (err) {
			     if (err.name === 'AbortError') {
			       // The operation was cancelled
			     }
			   }
			});
			
			const reader = rs.getReader();
			
			reader.read().then(({ value, done }) => {
			   console.log(value); // hello
			   console.log(done); // false
			   controller.abort();
			});
			```
		**/
		function addAbortSignal<T>(signal:js.html.AbortSignal, stream:T):T;
		/**
			Returns the default highWaterMark used by streams.
			Defaults to `16384` (16 KiB), or `16` for `objectMode`.
		**/
		function getDefaultHighWaterMark(objectMode:Bool):Float;
		/**
			Sets the default highWaterMark used by streams.
		**/
		function setDefaultHighWaterMark(objectMode:Bool, value:Float):Void;
		/**
			A readable and/or writable stream/webstream.
			
			A function to get notified when a stream is no longer readable, writable
			or has experienced an error or a premature close event.
			
			```js
			const { finished } = require('node:stream');
			const fs = require('node:fs');
			
			const rs = fs.createReadStream('archive.tar');
			
			finished(rs, (err) => {
			   if (err) {
			     console.error('Stream failed.', err);
			   } else {
			     console.log('Stream is done reading.');
			   }
			});
			
			rs.resume(); // Drain the stream.
			```
			
			Especially useful in error handling scenarios where a stream is destroyed
			prematurely (like an aborted HTTP request), and will not emit `'end'`or `'finish'`.
			
			The `finished` API provides `promise version`.
			
			`stream.finished()` leaves dangling event listeners (in particular`'error'`, `'end'`, `'finish'` and `'close'`) after `callback` has been
			invoked. The reason for this is so that unexpected `'error'` events (due to
			incorrect stream implementations) do not cause unexpected crashes.
			If this is unwanted behavior then the returned cleanup function needs to be
			invoked in the callback:
			
			```js
			const cleanup = finished(rs, (err) => {
			   cleanup();
			   // ...
			});
			```
		**/
		@:overload(function(stream:ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>, callback:ts.AnyOf2<() -> Void, (err:global.nodejs.ErrnoException) -> Void>):() -> Void { })
		function finished(stream:ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>, options:node.stream.FinishedOptions, callback:ts.AnyOf2<() -> Void, (err:global.nodejs.ErrnoException) -> Void>):() -> Void;
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
		@:overload(function<A, T1, B>(source:A, transform1:T1, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function<A, T1, T2, B>(source:A, transform1:T1, transform2:T2, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function<A, T1, T2, T3, B>(source:A, transform1:T1, transform2:T2, transform3:T3, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function<A, T1, T2, T3, T4, B>(source:A, transform1:T1, transform2:T2, transform3:T3, transform4:T4, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic { })
		@:overload(function(streams:haxe.ds.ReadOnlyArray<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>>, ?callback:(err:Null<global.nodejs.ErrnoException>) -> Void):global.nodejs.WritableStream { })
		@:overload(function(stream1:global.nodejs.ReadableStream, stream2:ts.AnyOf2<global.nodejs.WritableStream, global.nodejs.ReadWriteStream>, streams:haxe.extern.Rest<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadWriteStream, (err:Null<global.nodejs.ErrnoException>) -> Void>>):global.nodejs.WritableStream { })
		function pipeline<A, B>(source:A, destination:B, ?callback:node.stream.PipelineCallback<B>):Dynamic;
		/**
			Returns whether the stream has encountered an error.
		**/
		function isErrored(stream:ts.AnyOf4<global.nodejs.WritableStream, global.nodejs.ReadableStream, node.stream.Readable, node.stream.Writable>):Bool;
		/**
			Returns whether the stream is readable.
		**/
		function isReadable(stream:ts.AnyOf2<global.nodejs.ReadableStream, node.stream.Readable>):Bool;
		final promises : {
			function finished(stream:ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>, ?options:node.stream.FinishedOptions):js.lib.Promise<ts.Undefined>;
			@:overload(function<A, T1, B>(source:A, transform1:T1, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function<A, T1, T2, B>(source:A, transform1:T1, transform2:T2, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function<A, T1, T2, T3, B>(source:A, transform1:T1, transform2:T2, transform3:T3, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function<A, T1, T2, T3, T4, B>(source:A, transform1:T1, transform2:T2, transform3:T3, transform4:T4, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B> { })
			@:overload(function(streams:haxe.ds.ReadOnlyArray<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadableStream, global.nodejs.ReadWriteStream>>, ?options:node.stream.PipelineOptions):js.lib.Promise<ts.Undefined> { })
			@:overload(function(stream1:global.nodejs.ReadableStream, stream2:ts.AnyOf2<global.nodejs.WritableStream, global.nodejs.ReadWriteStream>, streams:haxe.extern.Rest<ts.AnyOf3<global.nodejs.WritableStream, global.nodejs.ReadWriteStream, node.stream.PipelineOptions>>):js.lib.Promise<ts.Undefined> { })
			function pipeline<A, B>(source:A, destination:B, ?options:node.stream.PipelineOptions):node.stream.PipelinePromise<B>;
		};
		final consumers : {
			function buffer(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<node.buffer.Buffer>;
			function text(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<String>;
			function arrayBuffer(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<js.lib.ArrayBuffer>;
			function blob(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<node.buffer.Blob>;
			function json(stream:ts.AnyOf3<global.nodejs.ReadableStream, node.stream.Readable, js.lib.AsyncIterator_<Dynamic, Dynamic, Null<Any>>>):js.lib.Promise<Any>;
		};
		/**
			Creates a `Promise` that is fulfilled when the `EventEmitter` emits the given
			event or that is rejected if the `EventEmitter` emits `'error'` while waiting.
			The `Promise` will resolve with an array of all the arguments emitted to the
			given event.
			
			This method is intentionally generic and works with the web platform [EventTarget](https://dom.spec.whatwg.org/#interface-eventtarget) interface, which has no special`'error'` event
			semantics and does not listen to the `'error'` event.
			
			```js
			import { once, EventEmitter } from 'node:events';
			import process from 'node:process';
			
			const ee = new EventEmitter();
			
			process.nextTick(() => {
			   ee.emit('myevent', 42);
			});
			
			const [value] = await once(ee, 'myevent');
			console.log(value);
			
			const err = new Error('kaboom');
			process.nextTick(() => {
			   ee.emit('error', err);
			});
			
			try {
			   await once(ee, 'myevent');
			} catch (err) {
			   console.error('error happened', err);
			}
			```
			
			The special handling of the `'error'` event is only used when `events.once()`is used to wait for another event. If `events.once()` is used to wait for the
			'`error'` event itself, then it is treated as any other kind of event without
			special handling:
			
			```js
			import { EventEmitter, once } from 'node:events';
			
			const ee = new EventEmitter();
			
			once(ee, 'error')
			   .then(([err]) => console.log('ok', err.message))
			   .catch((err) => console.error('error', err.message));
			
			ee.emit('error', new Error('boom'));
			
			// Prints: ok boom
			```
			
			An `AbortSignal` can be used to cancel waiting for the event:
			
			```js
			import { EventEmitter, once } from 'node:events';
			
			const ee = new EventEmitter();
			const ac = new AbortController();
			
			async function foo(emitter, event, signal) {
			   try {
			     await once(emitter, event, { signal });
			     console.log('event emitted!');
			   } catch (error) {
			     if (error.name === 'AbortError') {
			       console.error('Waiting for the event was canceled!');
			     } else {
			       console.error('There was an error', error.message);
			     }
			   }
			}
			
			foo(ee, 'foo', ac.signal);
			ac.abort(); // Abort waiting for the event
			ee.emit('foo'); // Prints: Waiting for the event was canceled!
			```
		**/
		@:overload(function(emitter:SecureServerOptions, eventName:String, ?options:SecureServerOptions):js.lib.Promise<Array<Dynamic>> { })
		function once(emitter:SecureServerOptions, eventName:ts.AnyOf2<String, js.lib.Symbol>, ?options:SecureServerOptions):js.lib.Promise<Array<Dynamic>>;
		/**
			```js
			import { on, EventEmitter } from 'node:events';
			import process from 'node:process';
			
			const ee = new EventEmitter();
			
			// Emit later on
			process.nextTick(() => {
			   ee.emit('foo', 'bar');
			   ee.emit('foo', 42);
			});
			
			for await (const event of on(ee, 'foo')) {
			   // The execution of this inner block is synchronous and it
			   // processes one event at a time (even with await). Do not use
			   // if concurrent execution is required.
			   console.log(event); // prints ['bar'] [42]
			}
			// Unreachable here
			```
			
			Returns an `AsyncIterator` that iterates `eventName` events. It will throw
			if the `EventEmitter` emits `'error'`. It removes all listeners when
			exiting the loop. The `value` returned by each iteration is an array
			composed of the emitted event arguments.
			
			An `AbortSignal` can be used to cancel waiting on events:
			
			```js
			import { on, EventEmitter } from 'node:events';
			import process from 'node:process';
			
			const ac = new AbortController();
			
			(async () => {
			   const ee = new EventEmitter();
			
			   // Emit later on
			   process.nextTick(() => {
			     ee.emit('foo', 'bar');
			     ee.emit('foo', 42);
			   });
			
			   for await (const event of on(ee, 'foo', { signal: ac.signal })) {
			     // The execution of this inner block is synchronous and it
			     // processes one event at a time (even with await). Do not use
			     // if concurrent execution is required.
			     console.log(event); // prints ['bar'] [42]
			   }
			   // Unreachable here
			})();
			
			process.nextTick(() => ac.abort());
			```
		**/
		function on(emitter:global.nodejs.EventEmitter, eventName:String, ?options:SecureServerOptions):js.lib.AsyncIterableIterator<Dynamic>;
		/**
			A class method that returns the number of listeners for the given `eventName`registered on the given `emitter`.
			
			```js
			import { EventEmitter, listenerCount } from 'node:events';
			
			const myEmitter = new EventEmitter();
			myEmitter.on('event', () => {});
			myEmitter.on('event', () => {});
			console.log(listenerCount(myEmitter, 'event'));
			// Prints: 2
			```
		**/
		function listenerCount(emitter:global.nodejs.EventEmitter, eventName:ts.AnyOf2<String, js.lib.Symbol>):Float;
		/**
			Returns a copy of the array of listeners for the event named `eventName`.
			
			For `EventEmitter`s this behaves exactly the same as calling `.listeners` on
			the emitter.
			
			For `EventTarget`s this is the only way to get the event listeners for the
			event target. This is useful for debugging and diagnostic purposes.
			
			```js
			import { getEventListeners, EventEmitter } from 'node:events';
			
			{
			   const ee = new EventEmitter();
			   const listener = () => console.log('Events are fun');
			   ee.on('foo', listener);
			   console.log(getEventListeners(ee, 'foo')); // [ [Function: listener] ]
			}
			{
			   const et = new EventTarget();
			   const listener = () => console.log('Events are fun');
			   et.addEventListener('foo', listener);
			   console.log(getEventListeners(et, 'foo')); // [ [Function: listener] ]
			}
			```
		**/
		function getEventListeners(emitter:ts.AnyOf2<global.nodejs.EventEmitter, SecureServerOptions>, name:ts.AnyOf2<String, js.lib.Symbol>):Array<haxe.Constraints.Function>;
		/**
			Returns the currently set max amount of listeners.
			
			For `EventEmitter`s this behaves exactly the same as calling `.getMaxListeners` on
			the emitter.
			
			For `EventTarget`s this is the only way to get the max event listeners for the
			event target. If the number of event handlers on a single EventTarget exceeds
			the max set, the EventTarget will print a warning.
			
			```js
			import { getMaxListeners, setMaxListeners, EventEmitter } from 'node:events';
			
			{
			   const ee = new EventEmitter();
			   console.log(getMaxListeners(ee)); // 10
			   setMaxListeners(11, ee);
			   console.log(getMaxListeners(ee)); // 11
			}
			{
			   const et = new EventTarget();
			   console.log(getMaxListeners(et)); // 10
			   setMaxListeners(11, et);
			   console.log(getMaxListeners(et)); // 11
			}
			```
		**/
		function getMaxListeners(emitter:ts.AnyOf2<global.nodejs.EventEmitter, SecureServerOptions>):Float;
		/**
			```js
			import { setMaxListeners, EventEmitter } from 'node:events';
			
			const target = new EventTarget();
			const emitter = new EventEmitter();
			
			setMaxListeners(5, target, emitter);
			```
		**/
		function setMaxListeners(?n:Float, eventTargets:haxe.extern.Rest<ts.AnyOf2<global.nodejs.EventEmitter, SecureServerOptions>>):Void;
		/**
			Listens once to the `abort` event on the provided `signal`.
			
			Listening to the `abort` event on abort signals is unsafe and may
			lead to resource leaks since another third party with the signal can
			call `e.stopImmediatePropagation()`. Unfortunately Node.js cannot change
			this since it would violate the web standard. Additionally, the original
			API makes it easy to forget to remove listeners.
			
			This API allows safely using `AbortSignal`s in Node.js APIs by solving these
			two issues by listening to the event such that `stopImmediatePropagation` does
			not prevent the listener from running.
			
			Returns a disposable so that it may be unsubscribed from more easily.
			
			```js
			import { addAbortListener } from 'node:events';
			
			function example(signal) {
			   let disposable;
			   try {
			     signal.addEventListener('abort', (e) => e.stopImmediatePropagation());
			     disposable = addAbortListener(signal, (e) => {
			       // Do something when signal is aborted.
			     });
			   } finally {
			     disposable?.[Symbol.dispose]();
			   }
			}
			```
		**/
		function addAbortListener(signal:js.html.AbortSignal, resource:(event:js.html.Event) -> Void):global.Disposable;
		/**
			This symbol shall be used to install a listener for only monitoring `'error'`events. Listeners installed using this symbol are called before the regular`'error'` listeners are called.
			
			Installing a listener using this symbol does not change the behavior once an`'error'` event is emitted. Therefore, the process will still crash if no
			regular `'error'` listener is installed.
		**/
		final errorMonitor : js.lib.Symbol;
		/**
			Value: `Symbol.for('nodejs.rejection')`
			
			See how to write a custom `rejection handler`.
		**/
		final captureRejectionSymbol : js.lib.Symbol;
		/**
			Value: [boolean](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Boolean_type)
			
			Change the default `captureRejections` option on all new `EventEmitter` objects.
		**/
		var captureRejections : Bool;
		/**
			By default, a maximum of `10` listeners can be registered for any single
			event. This limit can be changed for individual `EventEmitter` instances
			using the `emitter.setMaxListeners(n)` method. To change the default
			for _all_`EventEmitter` instances, the `events.defaultMaxListeners`property can be used. If this value is not a positive number, a `RangeError`is thrown.
			
			Take caution when setting the `events.defaultMaxListeners` because the
			change affects _all_`EventEmitter` instances, including those created before
			the change is made. However, calling `emitter.setMaxListeners(n)` still has
			precedence over `events.defaultMaxListeners`.
			
			This is not a hard limit. The `EventEmitter` instance will allow
			more listeners to be added but will output a trace warning to stderr indicating
			that a "possible EventEmitter memory leak" has been detected. For any single`EventEmitter`, the `emitter.getMaxListeners()` and `emitter.setMaxListeners()`methods can be used to
			temporarily avoid this warning:
			
			```js
			import { EventEmitter } from 'node:events';
			const emitter = new EventEmitter();
			emitter.setMaxListeners(emitter.getMaxListeners() + 1);
			emitter.once('event', () => {
			   // do stuff
			   emitter.setMaxListeners(Math.max(emitter.getMaxListeners() - 1, 0));
			});
			```
			
			The `--trace-warnings` command-line flag can be used to display the
			stack trace for such warnings.
			
			The emitted warning can be inspected with `process.on('warning')` and will
			have the additional `emitter`, `type`, and `count` properties, referring to
			the event emitter instance, the event's name and the number of attached
			listeners, respectively.
			Its `name` property is set to `'MaxListenersExceededWarning'`.
		**/
		var defaultMaxListeners : Float;
	};
	@:optional
	var maxDeflateDynamicTableSize : Float;
	@:optional
	var maxSessionMemory : Float;
	@:optional
	var maxHeaderListPairs : Float;
	@:optional
	var maxOutstandingPings : Float;
	@:optional
	var maxSendHeaderBlockLength : Float;
	@:optional
	var paddingStrategy : Float;
	@:optional
	var peerMaxConcurrentStreams : Float;
	@:optional
	var settings : Settings;
	/**
		Specifies a timeout in milliseconds that
		a server should wait when an [`'unknownProtocol'`][] is emitted. If the
		socket has not been destroyed by that time the server will destroy it.
	**/
	@:optional
	var unknownProtocolTimeout : Float;
	@:optional
	function selectPadding(frameLen:Float, maxFrameLen:Float):Float;
	/**
		Abort the connection if the SSL/TLS handshake does not finish in the
		specified number of milliseconds. A 'tlsClientError' is emitted on
		the tls.Server object whenever a handshake times out. Default:
		120000 (120 seconds).
	**/
	@:optional
	var handshakeTimeout : Float;
	/**
		The number of seconds after which a TLS session created by the
		server will no longer be resumable. See Session Resumption for more
		information. Default: 300.
	**/
	@:optional
	var sessionTimeout : Float;
	/**
		48-bytes of cryptographically strong pseudo-random data.
	**/
	@:optional
	var ticketKeys : node.buffer.Buffer;
	@:optional
	function pskCallback(socket:node.tls.TLSSocket, identity:String):Null<global.nodejs.ArrayBufferView>;
	/**
		hint to send to a client to help
		with selecting the identity during TLS-PSK negotiation. Will be ignored
		in TLS 1.3. Upon failing to set pskIdentityHint `tlsClientError` will be
		emitted with `ERR_TLS_PSK_SET_IDENTIY_HINT_FAILED` code.
	**/
	@:optional
	var pskIdentityHint : String;
	/**
		If set, this will be called when a client opens a connection using the ALPN extension.
		One argument will be passed to the callback: an object containing `servername` and `protocols` fields,
		respectively containing the server name from the SNI extension (if any) and an array of
		ALPN protocol name strings. The callback must return either one of the strings listed in `protocols`,
		which will be returned to the client as the selected ALPN protocol, or `undefined`,
		to reject the connection with a fatal alert. If a string is returned that does not match one of
		the client's ALPN protocols, an error will be thrown.
		This option cannot be used with the `ALPNProtocols` option, and setting both options will throw an error.
	**/
	@:optional
	dynamic function ALPNCallback(arg:{ var servername : String; var protocols : Array<String>; }):Null<String>;
	/**
		Optionally override the trusted CA certificates. Default is to trust
		the well-known CAs curated by Mozilla. Mozilla's CAs are completely
		replaced when CAs are explicitly specified using this option.
	**/
	@:optional
	var ca : ts.AnyOf3<String, node.buffer.Buffer, Array<ts.AnyOf2<String, node.buffer.Buffer>>>;
	/**
		Cert chains in PEM format. One cert chain should be provided per
		private key. Each cert chain should consist of the PEM formatted
		certificate for a provided private key, followed by the PEM
		formatted intermediate certificates (if any), in order, and not
		including the root CA (the root CA must be pre-known to the peer,
		see ca). When providing multiple cert chains, they do not have to
		be in the same order as their private keys in key. If the
		intermediate certificates are not provided, the peer will not be
		able to validate the certificate, and the handshake will fail.
	**/
	@:optional
	var cert : ts.AnyOf3<String, node.buffer.Buffer, Array<ts.AnyOf2<String, node.buffer.Buffer>>>;
	/**
		Colon-separated list of supported signature algorithms. The list
		can contain digest algorithms (SHA256, MD5 etc.), public key
		algorithms (RSA-PSS, ECDSA etc.), combination of both (e.g
		'RSA+SHA384') or TLS v1.3 scheme names (e.g. rsa_pss_pss_sha512).
	**/
	@:optional
	var sigalgs : String;
	/**
		Cipher suite specification, replacing the default. For more
		information, see modifying the default cipher suite. Permitted
		ciphers can be obtained via tls.getCiphers(). Cipher names must be
		uppercased in order for OpenSSL to accept them.
	**/
	@:optional
	var ciphers : String;
	/**
		Name of an OpenSSL engine which can provide the client certificate.
	**/
	@:optional
	var clientCertEngine : String;
	/**
		PEM formatted CRLs (Certificate Revocation Lists).
	**/
	@:optional
	var crl : ts.AnyOf3<String, node.buffer.Buffer, Array<ts.AnyOf2<String, node.buffer.Buffer>>>;
	/**
		`'auto'` or custom Diffie-Hellman parameters, required for non-ECDHE perfect forward secrecy.
		If omitted or invalid, the parameters are silently discarded and DHE ciphers will not be available.
		ECDHE-based perfect forward secrecy will still be available.
	**/
	@:optional
	var dhparam : ts.AnyOf2<String, node.buffer.Buffer>;
	/**
		A string describing a named curve or a colon separated list of curve
		NIDs or names, for example P-521:P-384:P-256, to use for ECDH key
		agreement. Set to auto to select the curve automatically. Use
		crypto.getCurves() to obtain a list of available curve names. On
		recent releases, openssl ecparam -list_curves will also display the
		name and description of each available elliptic curve. Default:
		tls.DEFAULT_ECDH_CURVE.
	**/
	@:optional
	var ecdhCurve : String;
	/**
		Attempt to use the server's cipher suite preferences instead of the
		client's. When true, causes SSL_OP_CIPHER_SERVER_PREFERENCE to be
		set in secureOptions
	**/
	@:optional
	var honorCipherOrder : Bool;
	/**
		Private keys in PEM format. PEM allows the option of private keys
		being encrypted. Encrypted keys will be decrypted with
		options.passphrase. Multiple keys using different algorithms can be
		provided either as an array of unencrypted key strings or buffers,
		or an array of objects in the form {pem: <string|buffer>[,
		passphrase: <string>]}. The object form can only occur in an array.
		object.passphrase is optional. Encrypted keys will be decrypted with
		object.passphrase if provided, or options.passphrase if it is not.
	**/
	@:optional
	var key : ts.AnyOf3<String, node.buffer.Buffer, Array<ts.AnyOf3<String, node.buffer.Buffer, node.tls.KeyObject>>>;
	/**
		Name of an OpenSSL engine to get private key from. Should be used
		together with privateKeyIdentifier.
	**/
	@:optional
	var privateKeyEngine : String;
	/**
		Identifier of a private key managed by an OpenSSL engine. Should be
		used together with privateKeyEngine. Should not be set together with
		key, because both options define a private key in different ways.
	**/
	@:optional
	var privateKeyIdentifier : String;
	/**
		Optionally set the maximum TLS version to allow. One
		of `'TLSv1.3'`, `'TLSv1.2'`, `'TLSv1.1'`, or `'TLSv1'`. Cannot be specified along with the
		`secureProtocol` option, use one or the other.
		**Default:** `'TLSv1.3'`, unless changed using CLI options. Using
		`--tls-max-v1.2` sets the default to `'TLSv1.2'`. Using `--tls-max-v1.3` sets the default to
		`'TLSv1.3'`. If multiple of the options are provided, the highest maximum is used.
	**/
	@:optional
	var maxVersion : node.tls.SecureVersion;
	/**
		Optionally set the minimum TLS version to allow. One
		of `'TLSv1.3'`, `'TLSv1.2'`, `'TLSv1.1'`, or `'TLSv1'`. Cannot be specified along with the
		`secureProtocol` option, use one or the other.  It is not recommended to use
		less than TLSv1.2, but it may be required for interoperability.
		**Default:** `'TLSv1.2'`, unless changed using CLI options. Using
		`--tls-v1.0` sets the default to `'TLSv1'`. Using `--tls-v1.1` sets the default to
		`'TLSv1.1'`. Using `--tls-min-v1.3` sets the default to
		'TLSv1.3'. If multiple of the options are provided, the lowest minimum is used.
	**/
	@:optional
	var minVersion : node.tls.SecureVersion;
	/**
		Shared passphrase used for a single private key and/or a PFX.
	**/
	@:optional
	var passphrase : String;
	/**
		PFX or PKCS12 encoded private key and certificate chain. pfx is an
		alternative to providing key and cert individually. PFX is usually
		encrypted, if it is, passphrase will be used to decrypt it. Multiple
		PFX can be provided either as an array of unencrypted PFX buffers,
		or an array of objects in the form {buf: <string|buffer>[,
		passphrase: <string>]}. The object form can only occur in an array.
		object.passphrase is optional. Encrypted PFX will be decrypted with
		object.passphrase if provided, or options.passphrase if it is not.
	**/
	@:optional
	var pfx : ts.AnyOf3<String, node.buffer.Buffer, Array<ts.AnyOf3<String, node.buffer.Buffer, node.tls.PxfObject>>>;
	/**
		Optionally affect the OpenSSL protocol behavior, which is not
		usually necessary. This should be used carefully if at all! Value is
		a numeric bitmask of the SSL_OP_* options from OpenSSL Options
	**/
	@:optional
	var secureOptions : Float;
	/**
		Legacy mechanism to select the TLS protocol version to use, it does
		not support independent control of the minimum and maximum version,
		and does not support limiting the protocol to TLSv1.3. Use
		minVersion and maxVersion instead. The possible values are listed as
		SSL_METHODS, use the function names as strings. For example, use
		'TLSv1_1_method' to force TLS version 1.1, or 'TLS_method' to allow
		any TLS protocol version up to TLSv1.3. It is not recommended to use
		TLS versions less than 1.2, but it may be required for
		interoperability. Default: none, see minVersion.
	**/
	@:optional
	var secureProtocol : String;
	/**
		Opaque identifier used by servers to ensure session state is not
		shared between applications. Unused by clients.
	**/
	@:optional
	var sessionIdContext : String;
	/**
		An optional TLS context object from tls.createSecureContext()
	**/
	@:optional
	var secureContext : node.tls.SecureContext;
	/**
		When enabled, TLS packet trace information is written to `stderr`. This can be
		used to debug TLS connection problems.
	**/
	@:optional
	var enableTrace : Bool;
	/**
		If true the server will request a certificate from clients that
		connect and attempt to verify that certificate. Defaults to
		false.
	**/
	@:optional
	var requestCert : Bool;
	/**
		An array of strings or a Buffer naming possible ALPN protocols.
		(Protocols should be ordered by their priority.)
	**/
	@:optional
	var ALPNProtocols : ts.AnyOf3<Array<String>, js.lib.Uint8Array, Array<js.lib.Uint8Array>>;
	/**
		SNICallback(servername, cb) <Function> A function that will be
		called if the client supports SNI TLS extension. Two arguments
		will be passed when called: servername and cb. SNICallback should
		invoke cb(null, ctx), where ctx is a SecureContext instance.
		(tls.createSecureContext(...) can be used to get a proper
		SecureContext.) If SNICallback wasn't provided the default callback
		with high-level API will be used (see below).
	**/
	@:optional
	dynamic function SNICallback(servername:String, cb:ts.AnyOf2<(err:Null<js.lib.Error>) -> Void, (err:Null<js.lib.Error>, ctx:node.tls.SecureContext) -> Void>):Void;
	/**
		If true the server will reject any connection which is not
		authorized with the list of supplied CAs. This option only has an
		effect if requestCert is true.
	**/
	@:optional
	var rejectUnauthorized : Bool;
	/**
		Indicates whether half-opened TCP connections are allowed.
	**/
	@:optional
	var allowHalfOpen : Bool;
	/**
		Indicates whether the socket should be paused on incoming connections.
	**/
	@:optional
	var pauseOnConnect : Bool;
	/**
		If set to `true`, it disables the use of Nagle's algorithm immediately after a new incoming connection is received.
	**/
	@:optional
	var noDelay : Bool;
	/**
		If set to `true`, it enables keep-alive functionality on the socket immediately after a new incoming connection is received,
		similarly on what is done in `socket.setKeepAlive([enable][, initialDelay])`.
	**/
	@:optional
	var keepAlive : Bool;
	/**
		If set to a positive number, it sets the initial delay before the first keepalive probe is sent on an idle socket.
	**/
	@:optional
	var keepAliveInitialDelay : Float;
};