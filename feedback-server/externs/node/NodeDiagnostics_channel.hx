package node;

@:jsRequire("node:diagnostics_channel") @valueModuleOnly extern class NodeDiagnostics_channel {
	/**
		Check if there are active subscribers to the named channel. This is helpful if
		the message you want to send might be expensive to prepare.
		
		This API is optional but helpful when trying to publish messages from very
		performance-sensitive code.
		
		```js
		import diagnostics_channel from 'node:diagnostics_channel';
		
		if (diagnostics_channel.hasSubscribers('my-channel')) {
		   // There are subscribers, prepare and publish message
		}
		```
	**/
	static function hasSubscribers(name:ts.AnyOf2<String, js.lib.Symbol>):Bool;
	/**
		This is the primary entry-point for anyone wanting to publish to a named
		channel. It produces a channel object which is optimized to reduce overhead at
		publish time as much as possible.
		
		```js
		import diagnostics_channel from 'node:diagnostics_channel';
		
		const channel = diagnostics_channel.channel('my-channel');
		```
	**/
	static function channel(name:ts.AnyOf2<String, js.lib.Symbol>):node.diagnostics_channel.Channel;
	/**
		Register a message handler to subscribe to this channel. This message handler
		will be run synchronously whenever a message is published to the channel. Any
		errors thrown in the message handler will trigger an `'uncaughtException'`.
		
		```js
		import diagnostics_channel from 'node:diagnostics_channel';
		
		diagnostics_channel.subscribe('my-channel', (message, name) => {
		   // Received data
		});
		```
	**/
	static function subscribe(name:ts.AnyOf2<String, js.lib.Symbol>, onMessage:node.diagnostics_channel.ChannelListener):Void;
	/**
		Remove a message handler previously registered to this channel with {@link subscribe}.
		
		```js
		import diagnostics_channel from 'node:diagnostics_channel';
		
		function onMessage(message, name) {
		   // Received data
		}
		
		diagnostics_channel.subscribe('my-channel', onMessage);
		
		diagnostics_channel.unsubscribe('my-channel', onMessage);
		```
	**/
	static function unsubscribe(name:ts.AnyOf2<String, js.lib.Symbol>, onMessage:node.diagnostics_channel.ChannelListener):Bool;
}