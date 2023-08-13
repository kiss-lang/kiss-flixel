package body_parser;

typedef BodyParser = {
	@:selfCall
	function call(?options:Dynamic):connect.NextHandleFunction;
	/**
		Returns middleware that only parses json and only looks at requests
		where the Content-Type header matches the type option.
	**/
	function json(?options:OptionsJson):connect.NextHandleFunction;
	/**
		Returns middleware that parses all bodies as a Buffer and only looks at requests
		where the Content-Type header matches the type option.
	**/
	function raw(?options:Options):connect.NextHandleFunction;
	/**
		Returns middleware that parses all bodies as a string and only looks at requests
		where the Content-Type header matches the type option.
	**/
	function text(?options:OptionsText):connect.NextHandleFunction;
	/**
		Returns middleware that only parses urlencoded bodies and only looks at requests
		where the Content-Type header matches the type option
	**/
	function urlencoded(?options:OptionsUrlencoded):connect.NextHandleFunction;
};