package node;

typedef RunOptions = {
	/**
		If a number is provided, then that many files would run in parallel.
		If truthy, it would run (number of cpu cores - 1) files in parallel.
		If falsy, it would only run one file at a time.
		If unspecified, subtests inherit this value from their parent.
	**/
	@:optional
	var concurrency : ts.AnyOf2<Float, Bool>;
	/**
		An array containing the list of files to run.
		If unspecified, the test runner execution model will be used.
	**/
	@:optional
	var files : haxe.ds.ReadOnlyArray<String>;
	/**
		Allows aborting an in-progress test execution.
	**/
	@:optional
	var signal : js.html.AbortSignal;
	/**
		A number of milliseconds the test will fail after.
		If unspecified, subtests inherit this value from their parent.
	**/
	@:optional
	var timeout : Float;
	/**
		Sets inspector port of test child process.
		If a nullish value is provided, each process gets its own port,
		incremented from the primary's `process.debugPort`.
	**/
	@:optional
	var inspectPort : ts.AnyOf2<Float, () -> Float>;
	/**
		That can be used to only run tests whose name matches the provided pattern.
		Test name patterns are interpreted as JavaScript regular expressions.
		For each test that is executed, any corresponding test hooks, such as `beforeEach()`, are also run.
	**/
	@:optional
	var testNamePatterns : ts.AnyOf4<String, js.lib.RegExp, Array<String>, Array<js.lib.RegExp>>;
	/**
		A function that accepts the TestsStream instance and can be used to setup listeners before any tests are run.
	**/
	@:optional
	dynamic function setup(root:Any):ts.AnyOf2<ts.Undefined, js.lib.Promise<ts.Undefined>>;
	/**
		Whether to run in watch mode or not.
	**/
	@:optional
	var watch : Bool;
	/**
		Running tests in a specific shard.
	**/
	@:optional
	var shard : TestShard;
};