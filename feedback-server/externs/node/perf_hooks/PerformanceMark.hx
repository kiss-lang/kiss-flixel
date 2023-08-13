package node.perf_hooks;

/**
	Exposes marks created via the `Performance.mark()` method.
**/
@:jsRequire("perf_hooks", "PerformanceMark") extern class PerformanceMark extends PerformanceEntry {
	static var prototype : PerformanceMark;
}