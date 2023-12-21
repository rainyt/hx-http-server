package http;

import sys.io.File;
import haxe.Json;
import thread.Threads;
import net.SocketServer;
import utils.Log;
import haxe.Exception;
import sys.thread.Thread;
import sys.net.Socket;

/**
 * HTTP服务器支持
 */
class HTTPServer extends SocketServer {
	/**
	 * 服务器目录
	 */
	public var webDir:String = "./";

	/**
	 * 路由管理器
	 */
	public var route:HTTPRouteManager;

	/**
	 * 构造一个HTTP服务器
	 * @param ip 
	 * @param port 
	 * @param log 
	 */
	public function new(ip:String, port:Int, log:Bool = false) {
		super(ip, port, log);
		this.route = new HTTPRouteManager(this);
	}

	/**
	 * 侦听链接的对象
	 * @param http 
	 */
	dynamic public function onConnectRequest(http:HTTPRequest):Void {}

	/**
	 * 信息数据后处理
	 * @param http 
	 */
	dynamic public function onResponseAfter(http:HTTPRequest):Void {}

	dynamic public function onHeaderRoute(header:String):String {
		return header;
	}

	/**
	 * 创建线程管理
	 * @param client 
	 */
	override public function onConnectClient(client:Socket):Void {
		Threads.create(() -> {
			var client:Socket = Thread.readMessage(true);
			try {
				var head = onHeaderRoute(client.input.readLine());
				if (head.indexOf("GET") == 0 || head.indexOf("POST") == 0 || head.indexOf("OPTIONS") == 0) {
					var http = new HTTPRequest(client, this, head);
					route.callRoute(http.path, http);
					onConnectRequest(http);
					// 发送路由信息
					onResponseAfter(http);
					@:privateAccess http.__send();
					http.close();
				} else {
					client.close();
				}
			} catch (e:Exception) {
				Log.exception("HTTPServer.exception", e);
			}
		}).sendMessage(client);
	}

	override function onRuning() {
		super.onRuning();
		this.route.onRuning();
	}
}
