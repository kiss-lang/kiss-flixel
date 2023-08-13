package node.http;

typedef ClientRequestArgs = {
	@:optional
	var _defaultAgent : Agent;
	@:optional
	var agent : ts.AnyOf2<Bool, Agent>;
	@:optional
	var auth : String;
	@:optional
	dynamic function createConnection(options:ClientRequestArgs, oncreate:(err:js.lib.Error, socket:node.net.Socket) -> Void):node.net.Socket;
	@:optional
	var defaultPort : ts.AnyOf2<String, Float>;
	@:optional
	var family : Float;
	@:optional
	var headers : OutgoingHttpHeaders;
	@:optional
	var hints : Float;
	@:optional
	var host : String;
	@:optional
	var hostname : String;
	@:optional
	var insecureHTTPParser : Bool;
	@:optional
	var localAddress : String;
	@:optional
	var localPort : Float;
	@:optional
	dynamic function lookup(hostname:String, options:node.dns.LookupAllOptions, callback:(err:Null<global.nodejs.ErrnoException>, addresses:Array<node.dns.LookupAddress>) -> Void):Void;
	@:optional
	var maxHeaderSize : Float;
	@:optional
	var method : String;
	@:optional
	var path : String;
	@:optional
	var port : ts.AnyOf2<String, Float>;
	@:optional
	var protocol : String;
	@:optional
	var setHost : Bool;
	@:optional
	var signal : js.html.AbortSignal;
	@:optional
	var socketPath : String;
	@:optional
	var timeout : Float;
	@:optional
	var uniqueHeaders : Array<ts.AnyOf2<String, Array<String>>>;
	@:optional
	var joinDuplicateHeaders : Bool;
};