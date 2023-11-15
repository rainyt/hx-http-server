package net;

import utils.Log;
import haxe.Exception;
import sys.net.Socket;

/**
 * 链接客户端
 */
class SocketClient {
	/**
	 * 客户端
	 */
	public var client:Socket;

	/**
	 * 当前服务
	 */
	public var server:SocketServer;

	public function new(client:Socket, server:SocketServer) {
		this.client = client;
		this.server = server;
		try {
			this.onWork();
		} catch (e:Exception) {
			Log.exception(e);
		}
	}

	public function onWork():Void {}
}
