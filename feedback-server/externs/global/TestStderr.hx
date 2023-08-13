package global;

typedef TestStderr = {
	/**
		The path of the test file, undefined if test is not ran through a file.
	**/
	@:optional
	var file : String;
	/**
		The message written to `stderr`
	**/
	var message : String;
};