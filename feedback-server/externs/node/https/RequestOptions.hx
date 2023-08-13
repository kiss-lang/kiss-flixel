package node.https;

typedef RequestOptions = node.http.RequestOptions & node.tls.SecureContextOptions & {
	@:optional
	dynamic function checkServerIdentity(hostname:String, cert:node.tls.PeerCertificate):Null<js.lib.Error>;
	@:optional
	var rejectUnauthorized : Bool;
	@:optional
	var servername : String;
};