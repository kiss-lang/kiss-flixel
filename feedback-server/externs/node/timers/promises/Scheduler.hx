package node.timers.promises;

typedef Scheduler = {
	/**
		```js
		import { scheduler } from 'node:timers/promises';
		
		await scheduler.wait(1000); // Wait one second before continuing
		```
		An experimental API defined by the Scheduling APIs draft specification being developed as a standard Web Platform API.
		Calling timersPromises.scheduler.wait(delay, options) is roughly equivalent to calling timersPromises.setTimeout(delay, undefined, options) except that the ref option is not supported.
	**/
	dynamic function wait(?delay:Float, ?options:node.timers.TimerOptions):js.lib.Promise<ts.Undefined>;
	/**
		An experimental API defined by the Scheduling APIs draft specification being developed as a standard Web Platform API.
		Calling timersPromises.scheduler.yield() is equivalent to calling timersPromises.setImmediate() with no arguments.
	**/
	dynamic function yield():js.lib.Promise<ts.Undefined>;
};