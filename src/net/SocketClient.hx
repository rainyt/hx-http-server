package net;

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
		this.onWork();
	}

	public function onWork():Void {}
}
