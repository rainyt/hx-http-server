package http;

import haxe.EntryPoint;
import utils.Log;
import haxe.Exception;
import sys.thread.Thread;
import sys.net.Host;
import sys.net.Socket;

/**
 * HTTP服务器支持
 */
class HTTPServer {
	private var __runing:Bool = true;

	private var __server:Socket;

	private var __ip:String;

	private var __port:Int = 0;

	public var log:Bool = false;

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
		__ip = ip;
		__port = port;
		this.log = log;
		this.route = new HTTPRouteManager(this);
	}

	/**
	 * 开始启动HTTP服务器
	 */
	public function start():Void {
		__server = new Socket();
		var host = new Host(__ip);
		try {
			__server.bind(host, __port);
			__server.listen(1024);
		} catch (e:Exception) {
			throw e;
		}
		Log.info("excPath", Sys.getCwd());
		Log.info("listener", __ip + ":" + __port);
		EntryPoint.addThread(onServerRuning);
	}

	public function onServerRuning():Void {
		while (__runing) {
			var socket = __server.accept();
			if (socket != null) {
				try {
					onConnectClient(socket);
				} catch (e:Exception) {
					if (this.log)
						Log.error(e.message);
				}
			}
		}
	}

	/**
	 * 侦听链接的对象
	 * @param http 
	 */
	dynamic public function onConnectRequest(http:HTTPRequest):Void {}

	/**
	 * 创建线程管理
	 * @param client 
	 */
	private function onConnectClient(client:Socket):Void {
		var head:String = client.input.readLine();
		if (head.indexOf("GET") == 0 || head.indexOf("POST") == 0) {
			Thread.create(() -> {
				var http = new HTTPRequest(client, this, head);
				route.callRoute(http.path, http);
				onConnectRequest(http);
			});
		} else {
			client.close();
		}
	}
}
