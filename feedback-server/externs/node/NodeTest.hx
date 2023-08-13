package node;

/**
	The `node:test` module facilitates the creation of JavaScript tests.
	To access it:
	
	```js
	import test from 'node:test';
	```
	
	This module is only available under the `node:` scheme. The following will not
	work:
	
	```js
	import test from 'test';
	```
	
	Tests created via the `test` module consist of a single function that is
	processed in one of three ways:
	
	1. A synchronous function that is considered failing if it throws an exception,
	and is considered passing otherwise.
	2. A function that returns a `Promise` that is considered failing if the`Promise` rejects, and is considered passing if the `Promise` resolves.
	3. A function that receives a callback function. If the callback receives any
	truthy value as its first argument, the test is considered failing. If a
	falsy value is passed as the first argument to the callback, the test is
	considered passing. If the test function receives a callback function and
	also returns a `Promise`, the test will fail.
	
	The following example illustrates how tests are written using the`test` module.
	
	```js
	test('synchronous passing test', (t) => {
	   // This test passes because it does not throw an exception.
	   assert.strictEqual(1, 1);
	});
	
	test('synchronous failing test', (t) => {
	   // This test fails because it throws an exception.
	   assert.strictEqual(1, 2);
	});
	
	test('asynchronous passing test', async (t) => {
	   // This test passes because the Promise returned by the async
	   // function is not rejected.
	   assert.strictEqual(1, 1);
	});
	
	test('asynchronous failing test', async (t) => {
	   // This test fails because the Promise returned by the async
	   // function is rejected.
	   assert.strictEqual(1, 2);
	});
	
	test('failing test using Promises', (t) => {
	   // Promises can be used directly as well.
	   return new Promise((resolve, reject) => {
	     setImmediate(() => {
	       reject(new Error('this will cause the test to fail'));
	     });
	   });
	});
	
	test('callback passing test', (t, done) => {
	   // done() is the callback function. When the setImmediate() runs, it invokes
	   // done() with no arguments.
	   setImmediate(done);
	});
	
	test('callback failing test', (t, done) => {
	   // When the setImmediate() runs, done() is invoked with an Error object and
	   // the test fails.
	   setImmediate(() => {
	     done(new Error('callback failure'));
	   });
	});
	```
	
	If any tests fail, the process exit code is set to `1`.
**/
@:jsRequire("node:test") @valueModuleOnly extern class NodeTest {
	/**
		The `test()` function is the value imported from the `test` module. Each
		invocation of this function results in reporting the test to the `TestsStream`.
		
		The `TestContext` object passed to the `fn` argument can be used to perform
		actions related to the current test. Examples include skipping the test, adding
		additional diagnostic information, or creating subtests.
		
		`test()` returns a `Promise` that resolves once the test completes.
		if `test()` is called within a `describe()` block, it resolve immediately.
		The return value can usually be discarded for top level tests.
		However, the return value from subtests should be used to prevent the parent
		test from finishing first and cancelling the subtest
		as shown in the following example.
		
		```js
		test('top level test', async (t) => {
		   // The setTimeout() in the following subtest would cause it to outlive its
		   // parent test if 'await' is removed on the next line. Once the parent test
		   // completes, it will cancel any outstanding subtests.
		   await t.test('longer running subtest', async (t) => {
		     return new Promise((resolve, reject) => {
		       setTimeout(resolve, 1000);
		     });
		   });
		});
		```
		
		The `timeout` option can be used to fail the test if it takes longer than`timeout` milliseconds to complete. However, it is not a reliable mechanism for
		canceling tests because a running test might block the application thread and
		thus prevent the scheduled cancellation.
	**/
	@:native("default")
	@:overload(function(?name:String, ?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	static function default_(?name:String, ?fn:NodeTest):js.lib.Promise<ts.Undefined>;
	/**
		```js
		import { tap } from 'node:test/reporters';
		import process from 'node:process';
		
		run({ files: [path.resolve('./tests/test.js')] })
		   .compose(tap)
		   .pipe(process.stdout);
		```
	**/
	static function run(?options:NodeTest):NodeTest;
	/**
		The `test()` function is the value imported from the `test` module. Each
		invocation of this function results in reporting the test to the `TestsStream`.
		
		The `TestContext` object passed to the `fn` argument can be used to perform
		actions related to the current test. Examples include skipping the test, adding
		additional diagnostic information, or creating subtests.
		
		`test()` returns a `Promise` that resolves once the test completes.
		if `test()` is called within a `describe()` block, it resolve immediately.
		The return value can usually be discarded for top level tests.
		However, the return value from subtests should be used to prevent the parent
		test from finishing first and cancelling the subtest
		as shown in the following example.
		
		```js
		test('top level test', async (t) => {
		   // The setTimeout() in the following subtest would cause it to outlive its
		   // parent test if 'await' is removed on the next line. Once the parent test
		   // completes, it will cancel any outstanding subtests.
		   await t.test('longer running subtest', async (t) => {
		     return new Promise((resolve, reject) => {
		       setTimeout(resolve, 1000);
		     });
		   });
		});
		```
		
		The `timeout` option can be used to fail the test if it takes longer than`timeout` milliseconds to complete. However, it is not a reliable mechanism for
		canceling tests because a running test might block the application thread and
		thus prevent the scheduled cancellation.
	**/
	@:overload(function(?name:String, ?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	static function test(?name:String, ?fn:NodeTest):js.lib.Promise<ts.Undefined>;
	/**
		The `describe()` function imported from the `node:test` module. Each
		invocation of this function results in the creation of a Subtest.
		After invocation of top level `describe` functions,
		all top level tests and suites will execute.
	**/
	@:overload(function(?name:String, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	static function describe(?name:String, ?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined>;
	/**
		Shorthand for `test()`.
		
		The `it()` function is imported from the `node:test` module.
	**/
	@:overload(function(?name:String, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	static function it(?name:String, ?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined>;
	/**
		This function is used to create a hook running before running a suite.
		
		```js
		describe('tests', async () => {
		   before(() => console.log('about to run some test'));
		   it('is a subtest', () => {
		     assert.ok('some relevant assertion here');
		   });
		});
		```
	**/
	static function before(?fn:NodeTest, ?options:NodeTest):Void;
	/**
		This function is used to create a hook running after  running a suite.
		
		```js
		describe('tests', async () => {
		   after(() => console.log('finished running tests'));
		   it('is a subtest', () => {
		     assert.ok('some relevant assertion here');
		   });
		});
		```
	**/
	static function after(?fn:NodeTest, ?options:NodeTest):Void;
	/**
		This function is used to create a hook running
		before each subtest of the current suite.
		
		```js
		describe('tests', async () => {
		   beforeEach(() => console.log('about to run a test'));
		   it('is a subtest', () => {
		     assert.ok('some relevant assertion here');
		   });
		});
		```
	**/
	static function beforeEach(?fn:NodeTest, ?options:NodeTest):Void;
	/**
		This function is used to create a hook running
		after each subtest of the current test.
		
		```js
		describe('tests', async () => {
		   afterEach(() => console.log('finished running a test'));
		   it('is a subtest', () => {
		     assert.ok('some relevant assertion here');
		   });
		});
		```
	**/
	static function afterEach(?fn:NodeTest, ?options:NodeTest):Void;
	static final mock : NodeTest;
	/**
		Shorthand for skipping a test, same as `test([name], { skip: true }[, fn])`.
	**/
	@:overload(function(?name:String, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	static function skip(?name:String, ?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined>;
	/**
		Shorthand for marking a test as `only`, same as `test([name], { only: true }[, fn])`.
	**/
	@:overload(function(?name:String, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	static function only(?name:String, ?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined>;
	/**
		Shorthand for marking a test as `TODO`, same as `test([name], { todo: true }[, fn])`.
	**/
	@:overload(function(?name:String, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:NodeTest):js.lib.Promise<ts.Undefined> { })
	static function todo(?name:String, ?options:NodeTest, ?fn:NodeTest):js.lib.Promise<ts.Undefined>;
}