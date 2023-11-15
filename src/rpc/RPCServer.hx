package rpc;

import utils.Log;
import haxe.Exception;
import sys.thread.Thread;
import sys.net.Socket;
import net.SocketServer;

/**
 * RPC协议服务器
 */
class RPCServer extends SocketServer {
	override function onConnectClient(client:Socket) {
		super.onConnectClient(client);
		Thread.create(() -> {
			try {
				new RPCRequest(client, this);
			} catch (e:Exception) {
				Log.exception(e);
			}
		});
	}
}
