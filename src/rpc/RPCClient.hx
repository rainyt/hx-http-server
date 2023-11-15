package rpc;

import haxe.Json;
import haxe.io.Bytes;
import sys.net.Host;
import sys.net.Socket;

/**
 * RPC客户端
 */
class RPCClient extends RPCRequest {
	public function new(ip:String, port:Int) {
		var client = new Socket();
		client.connect(new Host(ip), port);
		super(client, null);
	}

	/**
	 * 客户端不需要读取
	 */
	override function onWork() {}

	/**
	 * 方法调用
	 * @param func 
	 * @param ...args 
	 * @return Dynamic
	 */
	public function callMethod(func:String, ...args:Dynamic):Dynamic {
		var output = client.output;
		// 方法名
		this.writeString(func);
		// 参数数量
		var array = args.toArray();
		output.writeInt16(array.length);
		// 参数传递
		for (value in array) {
			if (value is Int) {
				// 整数
				output.writeInt8(RPCType.INT);
				output.writeInt32(value);
			} else if (value is Float) {
				// 浮点
				output.writeInt8(RPCType.FLOAT);
				output.writeFloat(value);
			} else if (value is Bool) {
				// 布尔值
				output.writeInt8(RPCType.BOOL);
				output.writeInt8(value == true ? 1 : 0);
			} else if (value is String) {
				// 字符串
                output.writeInt8(RPCType.STRING);
				writeString(value);
			} else if (value is Bytes) {
				// 字节
                output.writeInt8(RPCType.BYTES);
				writeBytes(value);
			} else {
				// Object
                output.writeInt8(RPCType.OBJECT);
				writeString(Json.stringify(value));
			}
		}
		return null;
	}
}
