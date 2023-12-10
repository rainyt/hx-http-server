package net;

import http.IRuning;
import haxe.Exception;
import sys.net.Host;
import sys.net.Socket;
import utils.Log;
import haxe.EntryPoint;

/**
 * TCP服务器
 */
class SocketServer implements IRuning {
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
	 * SSL配置，如果需要SSL时，则需要提供对应的参数
	 */
	public var ssl:SSLOption;

	/**
	 * 最大链接数
	 */
	public var maxThreadCounts = 10;

	private var __server:Socket;

	public function new(ip:String, port:Int, log:Bool = false) {
		this.log = log;
		this.ip = ip;
		this.port = port;
		this.onInit();
	}

	/**
	 * 初始化处理
	 */
	public function onInit():Void {}

	public function start():Void {
		if (ssl != null) {
			var sslScoket = new sys.ssl.Socket();
			__server = sslScoket;
			// 这里需要设置证书
			sslScoket.setCertificate(ssl.certificate, ssl.key);
		} else
			__server = new Socket();
		var host = new Host(ip);
		try {
			__server.setBlocking(false);
			__server.bind(host, port);
			__server.listen(maxThreadCounts);
		} catch (e:Exception) {
			throw e;
		}
		Log.info("[START]excPath", Sys.getCwd());
		Log.info("[START]listener", ip + ":" + port);
		EntryPoint.addThread(onServerRuning);
		// Thread.create(onServerRuning);
	}

	public function onConnectClient(client:Socket):Void {}

	public function onServerRuning():Void {
		while (__runing) {
			try {
				this.onRuning();
				var socket = __server.accept();
				if (socket != null) {
					try {
						Log.info("onConnectClient...");
						onConnectClient(socket);
					} catch (e:Exception) {
						Log.error("onConnectClient Excepition.");
						Log.exception(e);
					}
				}
			} catch (e:Exception) {
				if (e.message != "Blocking")
					Log.exception(e);
			}
		}
		throw("Server closed by " + this.ip + ":" + this.port);
	}

	public function onRuning() {}

	/**
	 * 停止当前服务器
	 */
	public function stop():Void {
		__runing = false;
	}
}
