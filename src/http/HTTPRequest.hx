package http;

import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import utils.Log;
import sys.net.Socket;

/**
 * 网络请求
 */
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
	 * 获得本地文件路径
	 * @return String
	 */
	public function getLocalFilePath():String {
		return Path.join([server.webDir, path]);
	}

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
	 * 发送文本信息或者是二进制数据
	 * @param text 
	 * @param code 
	 */
	public function send(data:Dynamic, code:HTTPRequestCode = OK):Void {
		var response:HTTPResponse = new HTTPResponse(code, mime, data);
		var bytes = response.getData();
		this.client.output.writeBytes(bytes, 0, bytes.length);
	}

	/**
	 * 发生文件内容
	 * @param filePath 
	 * @param code 
	 */
	public function sendFile(filePath:String, code:HTTPRequestCode = OK):Void {
		var path = Path.join([server.webDir, filePath]);
		if (FileSystem.exists(path)) {
			if (server.log)
				Log.info("sendFile", path);
			var response:HTTPResponse = new HTTPResponse(code, mime, File.getBytes(path));
			var bytes = response.getData();
			this.client.output.writeBytes(bytes, 0, bytes.length);
		} else {
			if (server.log)
				Log.info("not found", path);
			var response:HTTPResponse = new HTTPResponse(NOT_FOUND, mime, "Not found " + filePath);
			var bytes = response.getData();
			this.client.output.writeBytes(bytes, 0, bytes.length);
		}
	}
}
