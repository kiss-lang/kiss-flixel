package node.fs;

typedef BigIntStatsFs = {
	/**
		Type of file system.
	**/
	var type : js.lib.BigInt;
	/**
		Optimal transfer block size.
	**/
	var bsize : js.lib.BigInt;
	/**
		Total data blocks in file system.
	**/
	var blocks : js.lib.BigInt;
	/**
		Free blocks in file system.
	**/
	var bfree : js.lib.BigInt;
	/**
		Available blocks for unprivileged users
	**/
	var bavail : js.lib.BigInt;
	/**
		Total file nodes in file system.
	**/
	var files : js.lib.BigInt;
	/**
		Free file nodes in file system.
	**/
	var ffree : js.lib.BigInt;
};