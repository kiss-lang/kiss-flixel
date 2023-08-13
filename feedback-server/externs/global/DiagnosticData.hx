package global;

typedef DiagnosticData = {
	/**
		The diagnostic message.
	**/
	var message : String;
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