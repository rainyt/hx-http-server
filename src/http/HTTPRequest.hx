package http;

import utils.Log;
import sys.net.Socket;

class HTTPRequest {
	/**
	 * 当前服务
	 */
	public var server:HTTPServer;

	/**
	 * 客户端
	 */
	public var client:Socket;

	/**
	 * 请求文件
	 */
	public var mime:String;

	/**
	 * 请求头信息
	 */
	public var method:HTTPRequestMethod;

	/**
	 * 请求路径
	 */
	public var path:String;

	/**
	 * HTTP版本
	 */
	public var httpVersion:String;

	/**
	 * 网络请求
	 * @param socket 网络socket
	 * @param server 服务
	 * @param head 头信息
	 */
	public function new(socket:Socket, server:HTTPServer, head:String) {
		this.server = server;
		this.client = socket;
		if (server.log)
			Log.info("header message:", head);
		if (head != null) {
			var headerMessage = head.split(" ");
			method = headerMessage[0];
			path = headerMessage[1];
			httpVersion = headerMessage[2];
		}
	}

	/**
	 * 发送文本信息
	 * @param text 
	 * @param code 
	 */
	public function send(text:String, code:HTTPRequestCode):Void {
		var response:HTTPResponse = new HTTPResponse(code, mime, text);
		var bytes = response.getData();
		this.client.output.writeBytes(bytes, 0, bytes.length);
	}
}
