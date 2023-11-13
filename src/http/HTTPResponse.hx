package http;

import haxe.io.BytesOutput;
import haxe.io.Bytes;

/**
 * 信息包装
 */
class HTTPResponse {
	public var code:HTTPRequestCode;

	private var __data:Bytes;

	public var data(never, set):Dynamic;

	private function set_data(v:Dynamic):Dynamic {
		if (v is String) {
			this.__data = Bytes.ofString(v);
		} else if (v is Bytes)
			this.__data = v;
		else {
			this.__data = null;
		}
		return v;
	}

	/**
	 * 获得当前文本的内容
	 * @return Bytes
	 */
	public function getDataBytes():Bytes {
		return __data;
	}

	public var mime:String;

	/**
	 * 构造信息包装一般需要提供二进制数据或者是文本数据
	 * @param code 
	 * @param mime 
	 * @param data 
	 */
	public function new(code:HTTPRequestCode = OK, ?mime:String, ?data:Dynamic) {
		this.code = code;
		this.mime = mime;
		this.data = data;
	}

	/**
	 * 获得二进制数据
	 * @return Bytes
	 */
	public function getResponseData():Bytes {
		var bytesOutput:BytesOutput = new BytesOutput();
		bytesOutput.writeString("HTTP/1.1 " + code + " " + HTTPRequestCode.toMessageString(code));
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("Content-Length: " + (__data == null ? 0 : __data.length));
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("Content-Type: " + mime);
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("Access-Control-Allow-Origin: *");
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("Access-Control-Allow-Headers: *");
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("\r\n");
		if (__data != null) {
			bytesOutput.writeBytes(__data, 0, __data.length);
		}
		bytesOutput.writeString("\r\n");
		return bytesOutput.getBytes();
	}
}
