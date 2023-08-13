package node.worker_threads;

typedef TransferListItem = ts.AnyOf5<MessagePort, js.lib.ArrayBuffer, node.fs.promises.FileHandle, node.crypto.X509Certificate, node.buffer.Blob>;