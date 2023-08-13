package node.net;

typedef LookupFunction = (hostname:String, options:node.dns.LookupAllOptions, callback:(err:Null<global.nodejs.ErrnoException>, addresses:Array<node.dns.LookupAddress>) -> Void) -> Void;