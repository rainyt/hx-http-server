package http;

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

	/**
	 * 创建线程管理
	 * @param client 
	 */
	override public function onConnectClient(client:Socket):Void {
		Threads.create(() -> {
			try {
				var head:String = client.input.readLine();
				if (this.log) {
					Log.info("connect head:", head);
				}
				if (head.indexOf("GET") == 0 || head.indexOf("POST") == 0 || head.indexOf("OPTIONS") == 0) {
					var http = new HTTPRequest(client, this, head);
					try {
						route.callRoute(http.path, http);
						onConnectRequest(http);
						// 发送路由信息
						onResponseAfter(http);
						@:privateAccess http.__send();
					} catch (e:Exception) {
						if (http != null)
							Log.error(http.toMessageString());
						Log.exception(e);
						http.send(e.message, SERVICE_UNAVAILABLE);
						onResponseAfter(http);
						@:privateAccess http.__send();
					}
					http.close();
				} else {
					client.close();
				}
			} catch (e:Exception) {
				Log.error("HTTPServer", e.message);
				client.close();
			}
		});
	}
}
