package global;

typedef TestPlan = {
	/**
		The nesting level of the test.
	**/
	var nesting : Float;
	/**
		The number of subtests that have ran.
	**/
	var count : Float;
	/**
		The path of the test file, undefined if test is not ran through a file.
	**/
	@:optional
	var file : String;
};