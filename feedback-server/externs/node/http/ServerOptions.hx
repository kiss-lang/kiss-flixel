package node.http;

typedef ServerOptions<Request, Response> = {
	/**
		Specifies the `IncomingMessage` class to be used. Useful for extending the original `IncomingMessage`.
	**/
	@:optional
	var IncomingMessage : Request;
	/**
		Specifies the `ServerResponse` class to be used. Useful for extending the original `ServerResponse`.
	**/
	@:optional
	var ServerResponse : Response;
	/**
		Sets the timeout value in milliseconds for receiving the entire request from the client.
	**/
	@:optional
	var requestTimeout : Float;
	/**
		It joins the field line values of multiple headers in a request with `, ` instead of discarding the duplicates.
	**/
	@:optional
	var joinDuplicateHeaders : Bool;
	/**
		The number of milliseconds of inactivity a server needs to wait for additional incoming data,
		after it has finished writing the last response, before a socket will be destroyed.
	**/
	@:optional
	var keepAliveTimeout : Float;
	/**
		Sets the interval value in milliseconds to check for request and headers timeout in incomplete requests.
	**/
	@:optional
	var connectionsCheckingInterval : Float;
	/**
		Optionally overrides all `socket`s' `readableHighWaterMark` and `writableHighWaterMark`.
		This affects `highWaterMark` property of both `IncomingMessage` and `ServerResponse`.
		Default: @see stream.getDefaultHighWaterMark().
	**/
	@:optional
	var highWaterMark : Float;
	/**
		Use an insecure HTTP parser that accepts invalid HTTP headers when `true`.
		Using the insecure parser should be avoided.
		See --insecure-http-parser for more information.
	**/
	@:optional
	var insecureHTTPParser : Bool;
	/**
		Optionally overrides the value of
		`--max-http-header-size` for requests received by this server, i.e.
		the maximum length of request headers in bytes.
	**/
	@:optional
	var maxHeaderSize : Float;
	/**
		If set to `true`, it disables the use of Nagle's algorithm immediately after a new incoming connection is received.
	**/
	@:optional
	var noDelay : Bool;
	/**
		If set to `true`, it enables keep-alive functionality on the socket immediately after a new incoming connection is received,
		similarly on what is done in `socket.setKeepAlive([enable][, initialDelay])`.
	**/
	@:optional
	var keepAlive : Bool;
	/**
		If set to a positive number, it sets the initial delay before the first keepalive probe is sent on an idle socket.
	**/
	@:optional
	var keepAliveInitialDelay : Float;
	/**
		A list of response headers that should be sent only once.
		If the header's value is an array, the items will be joined using `; `.
	**/
	@:optional
	var uniqueHeaders : Array<ts.AnyOf2<String, Array<String>>>;
};