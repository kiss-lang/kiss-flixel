package node;

/**
	The type of a function under Suite.
	If the test uses callbacks, the callback function is passed as an argument
**/
typedef SuiteFn = (s:SuiteContext) -> ts.AnyOf2<ts.Undefined, js.lib.Promise<ts.Undefined>>;