package rpc;

import haxe.Json;
import haxe.io.Bytes;
import net.SocketClient;

/**
 * RPC请求支持
 * 该RPC为自定义协议，仅适用于当前RPC的互相调用
 * 方法名|参数长度|参数类型|参数值|参数类型|参数值|...
 */
class RPCRequest extends SocketClient {
	/**
	 * 当前方法名
	 */
	public var methodName:String;

	/**
	 * 参数列表
	 */
	public var args:Array<Dynamic> = [];

	/**
	 * 参数数量
	 */
	public var counts:Int = 0;

	/**
	 * 当前参数的类型
	 */
	public var type:RPCType;

	override function onWork() {
		super.onWork();
		var input = this.client.input;
		var state:RPCParserState = 0;
		while (true) {
			switch state {
				case METHOD:
					methodName = null;
					args = [];
					counts = 0;
					methodName = readString();
					state = ARGS_COUNTS;
				case ARGS_COUNTS:
					counts = input.readInt16();
					state = ARGS_TYPE;
				case ARGS_TYPE:
					type = input.readInt8();
					state = ARGS_VALUE;
				case ARGS_VALUE:
					counts--;
					switch type {
						case INT:
							// Int类型
							args.push(input.readInt32());
						case BOOL:
							// 布尔值
							args.push(input.readInt8() == 1);
						case FLOAT:
							// 浮点类型
							args.push(input.readFloat());
						case STRING:
							// 字符
							args.push(readString());
						case BYTES:
							// 字节
							var length = input.readInt32();
							var bytes = Bytes.alloc(length);
							input.readFullBytes(bytes, 0, length);
							args.push(bytes);
						case OBJECT:
							args.push(Json.stringify(readString()));
					}
					if (counts > 0) {
						state = ARGS_TYPE;
					} else {
						state = METHOD;
						// 这个时候就要调用方法了
						trace("调用方法", methodName, args);
					}
			}
		}
	}

	/**
	 * 读取一个字符串
	 * @return String
	 */
	private function readString():String {
		var len = client.input.readInt32();
		return client.input.readString(len);
	}
}

enum abstract RPCParserState(Int) to Int from Int {
	/**
	 * 获得方法名
	 */
	var METHOD = 0;

	/**
	 * 获得参数个数
	 */
	var ARGS_COUNTS = 1;

	/**
	 * 获得参数类型
	 */
	var ARGS_TYPE = 2;

	/**
	 * 获得参数值
	 */
	var ARGS_VALUE = 3;
}
