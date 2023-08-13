package node.crypto.webcrypto;

typedef RsaKeyAlgorithm = {
	var modulusLength : Float;
	var publicExponent : js.lib.Uint8Array;
	var name : String;
};