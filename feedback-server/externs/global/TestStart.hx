package global;

typedef TestStart = {
	/**
		The test name.
	**/
	var name : String;
	/**
		The nesting level of the test.
	**/
	var nesting : Float;
	/**
		The path of the test file, undefined if test is not ran through a file.
	**/
	@:optional
	var file : String;
};