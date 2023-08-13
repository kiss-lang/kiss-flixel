package node.buffer;

typedef FileOptions = {
	/**
		One of either `'transparent'` or `'native'`. When set to `'native'`, line endings in string source parts will be
		converted to the platform native line-ending as specified by `require('node:os').EOL`.
	**/
	@:optional
	var endings : String;
	/**
		The File content-type.
	**/
	@:optional
	var type : String;
	/**
		The last modified date of the file. `Default`: Date.now().
	**/
	@:optional
	var lastModified : Float;
};