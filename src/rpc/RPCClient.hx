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
			writeArgsValue(value);
		}
		// 读取返回值
		var input = client.input;
		while (true) {
			var type:RPCType = input.readInt8();
			return readArgsValue(type);
		}
	}
}
