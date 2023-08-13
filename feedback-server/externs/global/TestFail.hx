package global;

typedef TestFail = {
	/**
		Additional execution metadata.
	**/
	var details : {
		/**
			The duration of the test in milliseconds.
		**/
		var duration_ms : Float;
		/**
			The error thrown by the test.
		**/
		var error : js.lib.Error;
		/**
			The type of the test, used to denote whether this is a suite.
		**/
		@:optional
		var type : String;
	};
	/**
		The test name.
	**/
	var name : String;
	/**
		The nesting level of the test.
	**/
	var nesting : Float;
	/**
		The ordinal number of the test.
	**/
	var testNumber : Float;
	/**
		Present if `context.todo` is called.
	**/
	@:optional
	var todo : ts.AnyOf2<String, Bool>;
	/**
		Present if `context.skip` is called.
	**/
	@:optional
	var skip : ts.AnyOf2<String, Bool>;
	/**
		The path of the test file, undefined if test is not ran through a file.
	**/
	@:optional
	var file : String;
};