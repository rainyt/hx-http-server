package rpc;

import haxe.Serializer;
import haxe.Unserializer;
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
					if (counts == 0) {
						state = CALL;
					} else {
						state = ARGS_TYPE;
					}
				case ARGS_TYPE:
					type = input.readInt8();
					state = ARGS_VALUE;
				case ARGS_VALUE:
					if (counts > 0) {
						counts--;
						args.push(readArgsValue(type));
						if (counts == 0) {
							state = CALL;
						} else {
							state = ARGS_TYPE;
						}
					} else {
						state = CALL;
					}
				case CALL:
					// 这个时候就要调用方法了
					var returnValue = cast(this.server, RPCServer).protocol?.callMethod(methodName, args);
					if (returnValue != null) {
						this.writeArgsValue(returnValue);
					} else {
						client.output.writeInt8(RPCType.VIOD);
					}
					client.close();
					break;
			}
		}
	}

	/**
	 * 写入一个参数
	 * @param value 
	 */
	private function writeArgsValue(value:Dynamic) {
		var output = client.output;
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
			writeString(Serializer.run(value));
		}
	}

	/**
	 * 读取一个参数
	 * @param type 
	 * @return Dynamic
	 */
	private function readArgsValue(type:RPCType):Dynamic {
		var input = client.input;
		switch type {
			case VIOD:
				return null;
			case INT:
				// Int类型
				return (input.readInt32());
			case BOOL:
				// 布尔值
				return (input.readInt8() == 1);
			case FLOAT:
				// 浮点类型
				return (input.readFloat());
			case STRING:
				// 字符
				return (readString());
			case BYTES:
				// 字节
				return (readBytes());
			case OBJECT:
				return (Unserializer.run(readString()));
		}
		return null;
	}

	private function writeBytes(bytes:Bytes):Void {
		client.output.writeInt32(bytes.length);
		client.output.writeFullBytes(bytes, 0, bytes.length);
	}

	private function readBytes():Bytes {
		var length = client.input.readInt32();
		var bytes = Bytes.alloc(length);
		client.input.readFullBytes(bytes, 0, length);
		return bytes;
	}

	/**
	 * 写入字符串
	 * @param v 
	 */
	private function writeString(v:String):Void {
		client.output.writeInt32(Bytes.ofString(v).length);
		client.output.writeString(v);
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

	/**
	 * 调用
	 */
	var CALL = 4;
}
