package rpc;

import utils.ThreadPool;
import utils.Log;
import haxe.Exception;
import sys.thread.Thread;
import sys.net.Socket;
import net.SocketServer;

/**
 * RPC协议服务器
 */
class RPCServer extends SocketServer implements IRPCProtocol {
	/**
	 * 协议
	 */
	public var protocol:RPC;

	public var threadPool:ThreadPool = new ThreadPool();

	override function onConnectClient(client:Socket) {
		super.onConnectClient(client);
		threadPool.create(() -> {
			try {
				var rpc = new RPCRequest(client, this);
				rpc.close();
				trace("rpc线程结束了");
			} catch (e:Exception) {
				Log.exception(e);
			}
		});
	}
}
