package http;

import haxe.io.BytesOutput;
import haxe.io.Bytes;

class HTTPResponse {
	private var __code:HTTPRequestCode;

	private var __data:Bytes;

	private var __mime:String;

	public function new(code:HTTPRequestCode, mime:String, data:Dynamic) {
		this.__code = code;
		this.__mime = mime;
		if (data is String) {
			this.__data = Bytes.ofString(data);
		} else if (data is Bytes)
			this.__data = data;
	}

	public function getData():Bytes {
		var bytesOutput:BytesOutput = new BytesOutput();
		bytesOutput.writeString("HTTP/1.1 " + __code + " " + HTTPRequestCode.toMessageString(__code));
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("Content-Length: " + __data.length);
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("Content-Type: " + __mime);
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("Access-Control-Allow-Origin: *"); // js fetch is stupid
		bytesOutput.writeString("\r\n");
		bytesOutput.writeString("\r\n");
		bytesOutput.writeBytes(__data, 0, __data.length);
		bytesOutput.writeString("\r\n");
		return bytesOutput.getBytes();
	}
}
