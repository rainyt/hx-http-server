package http;

import haxe.io.Input;
import haxe.io.BytesBuffer;
import utils.MimeTools;
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

using utils.BytesTools;

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
	public var httpVersion:HTTPVersion;

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
			path = StringTools.urlDecode(headerMessage[1]);
			httpVersion = headerMessage[2];
			mime = MimeTools.getMimeType(path);
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
			if (server.log)
				Log.info(content);
			if (content == "" || content == null) {
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
			var param = datas.slice(1).join(" ");
			if (param.charAt(0) == " ")
				param = param.substr(1);
			this.param.pushHeader(key, param);
		}
		if (contentLength > 0) {
			postData = Bytes.alloc(contentLength);
			input.readFullBytes(postData, 0, contentLength);
		}
		// TODO HTTP2协议支持
		var connection = this.param.header("Connection");
		if (connection != null) {
			connection = connection.toLowerCase();
			if (connection.indexOf("upgrade") != -1 && connection.indexOf("http2-settings") != -1) {
				Log.warring("Need upgrade to HTTP2");
				this.httpVersion = HTTP2;
				var bytesOutput:BytesOutput = new BytesOutput();
				var code = HTTPRequestCode.SWITCHING_PROTOCOLS;
				bytesOutput.writeString("HTTP/1.1 " + code + " " + HTTPRequestCode.toMessageString(code));
				bytesOutput.writeString("\r\n");
				bytesOutput.writeString("Connection: Upgrade");
				bytesOutput.writeString("\r\n");
				bytesOutput.writeString("Upgrade: h2c");
				bytesOutput.writeString("\r\n");
				bytesOutput.writeString("\r\n");
				var bytes = bytesOutput.getBytes();
				socket.output.writeFullBytes(bytes, 0, bytes.length);
				// header
				var header = "";
				var settings = "";
				var step = 0;
				while (true) {
					switch step {
						case 0:
							// read header
							var char = input.readLine();
							if (char != "") {
								header += char + "\r\n";
							} else {
								step++;
							}
						case 1:
							// read setting
							var char = input.readLine();
							if (char != "") {
								settings += char + "\r\n";
							} else {
								step++;
							}
						case 2:
							break;
					}
				}
				Log.warring("header=", header);
				Log.warring("settings=", settings);

				while (true) {
					__readHttp2(input);
				}
				// __readHttp2(input);
				// var identifier = bytesArray.splice(42, 31);
				// trace("type=", type);
				// var flags =
				// trace("falgs=", flags);
				// var R = input.read(0);
				// trace("R=", R.length);
			}
		}
	}

	private function __readHttp2(input:Input):Void {
		var frameHeader = Bytes.alloc(9);
		input.readFullBytes(frameHeader, 0, 9);
		var length = frameHeader.getInt24(0);
		trace("字节长度：", length);
		var type = frameHeader.getInt8(3);
		trace("类型：", type);
		var flags = frameHeader.getInt8(4);
		trace("flags：", flags);
		var bytesArray = frameHeader.getData();
		var R = bytesArray[40];
		trace("R:", R);

		var contentBytes = Bytes.alloc(length);
		input.readFullBytes(contentBytes, 0, length);
		// trace("contentBytes=", contentBytes.toString(), contentBytes.length);
		// trace("contentBytes222=" + contentBytes.toString() + "----" + contentBytes.length);
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
		if (client == null)
			return;
		var bytes = response.getResponseData();
		if (server.log) {
			Log.info(this.path, "Code:" + response.code, "Send Length:" + bytes.length, "\n" + bytes.toString());
		}
		this.client.output.writeFullBytes(bytes, 0, bytes.length);
	}

	/**
	 * 发生文件内容
	 * @param filePath 
	 * @param code 
	 */
	public function sendFile(filePath:String, code:HTTPRequestCode = OK):Void {
		// URL编码解码处理
		mime = MimeTools.getMimeType(filePath);
		var path = Path.join([cast(server, HTTPServer).webDir, filePath]);
		if (FileSystem.exists(path)) {
			if (server.log)
				Log.info("sendFile", path);
			response.code = code;
			response.mime = mime;
			var read = File.read(path);
			var data = read.readAll();
			// response.data = File.getBytes(path);
			response.data = data;
		} else {
			if (server.log)
				Log.error("not found", path);
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
