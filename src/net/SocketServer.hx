package net;

import haxe.Exception;
import sys.net.Host;
import sys.net.Socket;
import utils.Log;
import haxe.EntryPoint;

/**
 * TCP服务器
 */
class SocketServer {
	/**
	 * 运行状态
	 */
	private var __runing:Bool = true;

	/**
	 * 是否显示日志
	 */
	public var log:Bool;

	/**
	 * 服务器IP
	 */
	public var ip:String;

	/**
	 * 服务器端口
	 */
	public var port:Int;

	/**
	 * 是否启动SSL
	 */
	public var ssl:Bool = false;

	private var __server:Socket;

	public function new(ip:String, port:Int, log:Bool = false) {
		this.log = log;
		this.ip = ip;
		this.port = port;
	}

	public function start():Void {
		if (ssl) {
			var sslScoket = new sys.ssl.Socket();
			__server = sslScoket;
			// TODO 这里需要设置证书
			// sslScoket.setCertificate()
		} else
			__server = new Socket();
		var host = new Host(ip);
		try {
			__server.bind(host, port);
			__server.listen(1024);
		} catch (e:Exception) {
			throw e;
		}
		Log.info("excPath", Sys.getCwd());
		Log.info("listener", ip + ":" + port);
		EntryPoint.addThread(onServerRuning);
	}

	public function onConnectClient(client:Socket):Void {}

	public function onServerRuning():Void {
		while (__runing) {
			try {
				var socket = __server.accept();
				if (socket != null) {
					onConnectClient(socket);
				}
			} catch (e:Exception) {
				Log.exception(e);
			}
		}
	}

	/**
	 * 停止当前服务器
	 */
	public function stop():Void {
		__runing = false;
	}
}
