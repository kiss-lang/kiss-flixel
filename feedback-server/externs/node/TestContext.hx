package node;

/**
	An instance of `TestContext` is passed to each test function in order to
	interact with the test runner. However, the `TestContext` constructor is not
	exposed as part of the API.
**/
@jsInaccessible extern class TestContext {
	function new();
	/**
		This function is used to create a hook running before subtest of the current test.
	**/
	dynamic function before(?fn:HookFn, ?options:HookOptions):Void;
	/**
		This function is used to create a hook running before each subtest of the current test.
	**/
	dynamic function beforeEach(?fn:HookFn, ?options:HookOptions):Void;
	/**
		This function is used to create a hook that runs after the current test finishes.
	**/
	dynamic function after(?fn:HookFn, ?options:HookOptions):Void;
	/**
		This function is used to create a hook running after each subtest of the current test.
	**/
	dynamic function afterEach(?fn:HookFn, ?options:HookOptions):Void;
	/**
		This function is used to write diagnostics to the output. Any diagnostic
		information is included at the end of the test's results. This function does
		not return a value.
		
		```js
		test('top level test', (t) => {
		   t.diagnostic('A diagnostic message');
		});
		```
	**/
	function diagnostic(message:String):Void;
	/**
		The name of the test.
	**/
	final name : String;
	/**
		If `shouldRunOnlyTests` is truthy, the test context will only run tests that
		have the `only` option set. Otherwise, all tests are run. If Node.js was not
		started with the `--test-only` command-line option, this function is a
		no-op.
		
		```js
		test('top level test', (t) => {
		   // The test context can be set to run subtests with the 'only' option.
		   t.runOnly(true);
		   return Promise.all([
		     t.test('this subtest is now skipped'),
		     t.test('this subtest is run', { only: true }),
		   ]);
		});
		```
	**/
	function runOnly(shouldRunOnlyTests:Bool):Void;
	/**
		```js
		test('top level test', async (t) => {
		   await fetch('some/uri', { signal: t.signal });
		});
		```
	**/
	final signal : js.html.AbortSignal;
	/**
		This function causes the test's output to indicate the test as skipped. If`message` is provided, it is included in the output. Calling `skip()` does
		not terminate execution of the test function. This function does not return a
		value.
		
		```js
		test('top level test', (t) => {
		   // Make sure to return here as well if the test contains additional logic.
		   t.skip('this is skipped');
		});
		```
	**/
	function skip(?message:String):Void;
	/**
		This function adds a `TODO` directive to the test's output. If `message` is
		provided, it is included in the output. Calling `todo()` does not terminate
		execution of the test function. This function does not return a value.
		
		```js
		test('top level test', (t) => {
		   // This test is marked as `TODO`
		   t.todo('this is a todo');
		});
		```
	**/
	function todo(?message:String):Void;
	/**
		This function is used to create subtests under the current test. This function behaves in
		the same fashion as the top level {@link test} function.
	**/
	@:overload(function(?name:String, ?options:TestOptions, ?fn:TestFn):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?options:TestOptions, ?fn:TestFn):js.lib.Promise<ts.Undefined> { })
	@:overload(function(?fn:TestFn):js.lib.Promise<ts.Undefined> { })
	dynamic function test(?name:String, ?fn:TestFn):js.lib.Promise<ts.Undefined>;
	/**
		Each test provides its own MockTracker instance.
	**/
	final mock : MockTracker;
	static var prototype : TestContext;
}