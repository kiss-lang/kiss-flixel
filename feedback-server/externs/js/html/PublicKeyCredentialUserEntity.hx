package js.html;

typedef PublicKeyCredentialUserEntity = {
	var displayName : String;
	var id : node.crypto.webcrypto.BufferSource;
	@:optional
	var icon : String;
	var name : String;
};