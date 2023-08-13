package node.crypto.webcrypto;

typedef EcdhKeyDeriveParams = {
	@:native("public")
	var public_ : CryptoKey;
	var name : String;
};