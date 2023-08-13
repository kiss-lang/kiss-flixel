package node.net;

typedef TcpNetConnectOpts = {
	@:optional
	var timeout : Float;
	var port : Float;
	@:optional
	var host : String;
	@:optional
	var localAddress : String;
	@:optional
	var localPort : Float;
	@:optional
	var hints : Float;
	@:optional
	var family : Float;
	@:optional
	dynamic function lookup(hostname:String, options:node.dns.LookupAllOptions, callback:(err:Null<global.nodejs.ErrnoException>, addresses:Array<node.dns.LookupAddress>) -> Void):Void;
	@:optional
	var noDelay : Bool;
	@:optional
	var keepAlive : Bool;
	@:optional
	var keepAliveInitialDelay : Float;
	@:optional
	var autoSelectFamily : Bool;
	@:optional
	var autoSelectFamilyAttemptTimeout : Float;
	/**
		If specified, incoming data is stored in a single buffer and passed to the supplied callback when data arrives on the socket.
		Note: this will cause the streaming functionality to not provide any data, however events like 'error', 'end', and 'close' will
		still be emitted as normal and methods like pause() and resume() will also behave as expected.
	**/
	@:optional
	var onread : OnReadOpts;
	@:optional
	var fd : Float;
	@:optional
	var allowHalfOpen : Bool;
	@:optional
	var readable : Bool;
	@:optional
	var writable : Bool;
	@:optional
	var signal : js.html.AbortSignal;
};