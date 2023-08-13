package node.crypto.webcrypto;

typedef RsaHashedKeyGenParams = {
	var hash : AlgorithmIdentifier;
	var modulusLength : Float;
	var publicExponent : js.lib.Uint8Array;
	var name : String;
};