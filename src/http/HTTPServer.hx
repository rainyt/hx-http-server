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
	 * 是否启动SSL
	 */
	public var ssl:Bool = false;

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
		if (ssl) {
			var sslScoket = new sys.ssl.Socket();
			__server = sslScoket;
			// TODO 这里需要设置证书
			// sslScoket.setCertificate()
		} else
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
	 * 信息数据后处理
	 * @param http 
	 */
	dynamic public function onResponseAfter(http:HTTPRequest):Void {}

	/**
	 * 创建线程管理
	 * @param client 
	 */
	private function onConnectClient(client:Socket):Void {
		var head:String = client.input.readLine();
		if (this.log)
			Log.info("connect head:", head);
		if (head.indexOf("GET") == 0 || head.indexOf("POST") == 0 || head.indexOf("OPTIONS") == 0) {
			Thread.create(() -> {
				var http = new HTTPRequest(client, this, head);
				route.callRoute(http.path, http);
				onConnectRequest(http);
				// 发送路由信息
				onResponseAfter(http);
				@:privateAccess http.__send();
			});
		} else {
			client.close();
		}
	}
}
