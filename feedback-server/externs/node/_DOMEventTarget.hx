package node;

typedef _DOMEventTarget = {
	function addEventListener(eventName:String, listener:(args:haxe.extern.Rest<Dynamic>) -> Void, ?opts:{ var once : Bool; }):Dynamic;
};