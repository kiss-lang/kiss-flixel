package node;

/**
	An instance of `SuiteContext` is passed to each suite function in order to
	interact with the test runner. However, the `SuiteContext` constructor is not
	exposed as part of the API.
**/
@jsInaccessible extern class SuiteContext {
	function new();
	/**
		The name of the suite.
	**/
	final name : String;
	/**
		Can be used to abort test subtasks when the test has been aborted.
	**/
	final signal : js.html.AbortSignal;
	static var prototype : SuiteContext;
}