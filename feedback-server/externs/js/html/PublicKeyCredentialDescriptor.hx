package js.html;

typedef PublicKeyCredentialDescriptor = {
	var id : node.crypto.webcrypto.BufferSource;
	@:optional
	var transports : Array<AuthenticatorTransport>;
	var type : String;
};