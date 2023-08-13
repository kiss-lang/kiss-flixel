package node.crypto.webcrypto;

typedef RsaHashedKeyAlgorithm = {
	var hash : KeyAlgorithm;
	var modulusLength : Float;
	var publicExponent : js.lib.Uint8Array;
	var name : String;
};