package js.html;

/**
	This Channel Messaging API interface allows us to create a new message channel and send data through it via its two MessagePort properties.
	
	`MessageChannel` class is a global reference for `require('worker_threads').MessageChannel`
	https://nodejs.org/api/globals.html#messagechannel
**/
typedef IMessageChannel = {
	/**
		Returns the first MessagePort object.
	**/
	final port1 : js.html.MessagePort;
	/**
		Returns the second MessagePort object.
	**/
	final port2 : js.html.MessagePort;
};