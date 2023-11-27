package http;

import net.SocketClient;
import haxe.Exception;
import haxe.Json;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import utils.Log;
import sys.net.Socket;

/**
 * 网络请求
 */
class HTTPRequest extends SocketClient {
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
	 * 参数数据
	 */
	public var param:HTTPParam;

	/**
	 * 来源数据
	 */
	private var __bytesOutput:BytesOutput;

	/**
	 * POST数据
	 */
	public var postData:Bytes;

	/**
	 * HOST
	 */
	public var host:String;

	/**
	 * 文本长度
	 */
	public var contentLength:Int;

	/**
	 * 上下文类型
	 */
	public var contentType:HTTPContentType;

	/**
	 * 获得本地文件路径
	 * @return String
	 */
	public function getLocalFilePath():String {
		return Path.join([cast(server, HTTPServer).webDir, path]);
	}

	/**
	 * 网络请求
	 * @param socket 网络socket
	 * @param server 服务
	 * @param head 头信息
	 */
	public function new(socket:Socket, server:HTTPServer, head:String) {
		if (server.log)
			Log.info("header message:", head);
		if (head != null) {
			var headerMessage = head.split(" ");
			method = headerMessage[0];
			path = headerMessage[1];
			httpVersion = headerMessage[2];
		}
		super(socket, server);
	}

	override function onWork() {
		super.onWork();
		__bytesOutput = new BytesOutput();
		// 解析头数据
		this.param = new HTTPParam(this);
		this.handleBytes(this.client);
		// 解析参数
		this.param.parserData();
	}

	// 解析头数据
	private function handleBytes(socket:Socket) {
		var input = socket.input;
		while (true) {
			var content:String = null;
			content = input.readLine();
			// if (server.log)
			// Log.info(content);
			if (content == "") {
				break;
			}
			var datas = content.split(" ");
			switch datas[0].toLowerCase() {
				case "host:":
					host = datas[1];
				case "content-length:":
					contentLength = Std.parseInt(datas[1]);
				case "content-type:":
					contentType = datas[1];
			}
			var key = datas[0];
			key = key.substr(0, key.length - 1);
			this.param.pushHeader(key, datas[1]);
		}
		if (contentLength > 0) {
			postData = Bytes.alloc(contentLength);
			input.readBytes(postData, 0, contentLength);
			Log.error("读取到的长度：", "" + postData.length, "实际所需：", "" + contentLength);
		}
	}

	/**
	 * 即将发送的上下文内容
	 */
	public var response:HTTPResponse = new HTTPResponse();

	/**
	 * 发送文本信息或者是二进制数据
	 * @param text 
	 * @param code 
	 */
	public function send(data:Dynamic, code:HTTPRequestCode = OK):Void {
		response.code = code;
		response.data = data;
		response.mime = mime;
	}

	/**
	 * 最终结算并发送
	 */
	@:noCompletion private function __send():Void {
		var bytes = response.getResponseData();
		if (server.log) {
			Log.warring(bytes.toString());
		}
		this.client.output.writeBytes(bytes, 0, bytes.length);
	}

	/**
	 * 发生文件内容
	 * @param filePath 
	 * @param code 
	 */
	public function sendFile(filePath:String, code:HTTPRequestCode = OK):Void {
		var path = Path.join([cast(server, HTTPServer).webDir, filePath]);
		if (FileSystem.exists(path)) {
			if (server.log)
				Log.info("sendFile", path);
			response.code = code;
			response.mime = mime;
			response.data = File.getBytes(path);
		} else {
			if (server.log)
				Log.info("not found", path);
			response.code = NOT_FOUND;
			response.mime = mime;
			response.data = "Not found " + filePath;
		}
	}

	/**
	 * 返回整体内容
	 * @return String
	 */
	public function toMessageString():String {
		var obj = {
			path: path,
			method: method,
			_get: @:privateAccess param.__gets,
			_post: @:privateAccess param.__posts,
			_header: @:privateAccess param.__header
		};
		return Json.stringify(obj);
	}
}
