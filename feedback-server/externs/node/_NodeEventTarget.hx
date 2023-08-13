package node;

typedef _NodeEventTarget = {
	function once(eventName:ts.AnyOf2<String, js.lib.Symbol>, listener:(args:haxe.extern.Rest<Dynamic>) -> Void):_NodeEventTarget;
};