package rpc;

import thread.Threads;
import utils.Log;
import haxe.Exception;
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

	override function onConnectClient(client:Socket) {
		super.onConnectClient(client);
		Threads.create(() -> {
			try {
				new RPCRequest(client, this);
			} catch (e:Exception) {
				Log.error("RPCServer error.");
				Log.exception(e);
			}
		});
	}
}
