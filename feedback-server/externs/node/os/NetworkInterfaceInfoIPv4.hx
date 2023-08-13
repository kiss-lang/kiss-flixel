package node.os;

typedef NetworkInterfaceInfoIPv4 = {
	var family : String;
	@:optional
	var scopeid : Any;
	var address : String;
	var netmask : String;
	var mac : String;
	var internal : Bool;
	var cidr : Null<String>;
};