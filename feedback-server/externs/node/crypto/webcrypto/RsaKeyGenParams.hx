package node.crypto.webcrypto;

typedef RsaKeyGenParams = {
	var modulusLength : Float;
	var publicExponent : js.lib.Uint8Array;
	var name : String;
};