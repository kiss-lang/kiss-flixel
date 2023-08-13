package node.nodecolontest.reporters;

typedef TestEvent = ts.AnyOf10<{
	var type : String;
	var data : global.DiagnosticData;
}, {
	var type : String;
	var data : global.TestFail;
}, {
	var type : String;
	var data : global.TestPass;
}, {
	var type : String;
	var data : global.TestPlan;
}, {
	var type : String;
	var data : global.TestStart;
}, {
	var type : String;
	var data : global.TestStderr;
}, {
	var type : String;
	var data : global.TestStdout;
}, {
	var type : String;
	var data : global.TestEnqueue;
}, {
	var type : String;
	var data : global.TestDequeue;
}, {
	var type : String;
}>;