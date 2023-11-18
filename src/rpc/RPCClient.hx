package rpc;

import haxe.EntryPoint;
import sys.thread.Mutex;
import sys.thread.Thread;
import utils.Log;
import haxe.Exception;
import haxe.Rest;
import haxe.Json;
import haxe.io.Bytes;
import sys.net.Host;
import sys.net.Socket;

/**
 * RPC客户端
 */
class RPCClient extends RPCRequest {
	private var __runing:Bool = true;

	private var __mutex:Mutex = new Mutex();

	/**
	 * 创建一个RPC链接
	 * @param ip 
	 * @param port 
	 * @return RPCClient
	 */
	public static function connect(ip:String, port):RPCClient {
		return new RPCClient(ip, port);
	}

	public function new(ip:String, port:Int) {
		var client = new Socket();
		client.connect(new Host(ip), port);
		super(client, null);
	}

	private var __call:Array<RPCCall> = [];

	private var __returnType:Null<RPCType> = null;

	private var __returnValue:Dynamic = null;

	/**
	 * 客户端不需要读取
	 */
	override function onWork() {
		EntryPoint.addThread(__onThraedWork);
	}

	private function __onThraedWork():Void {
		var output = client.output;
		var input = client.input;
		while (__runing) {
			var rpcCall = getCall();
			if (rpcCall != null) {
				// 方法名
				this.writeString(rpcCall.methodName);
				// 参数数量
				var array = rpcCall.args;
				output.writeInt16(array.length);
				// 参数传递
				for (value in array) {
					writeArgsValue(value);
				}
				// 读取返回值
				__mutex.acquire();
				__returnType = input.readInt8();
				__returnValue = readArgsValue(__returnType);
				__mutex.release();
			} else {
				Sys.sleep(0.01);
			}
		}
		Log.error("RPC connecting close.");
	}

	private function getCall():RPCCall {
		__mutex.acquire();
		var r = __call.shift();
		__mutex.release();
		return r;
	}

	/**
	 * 方法调用
	 * @param func 
	 * @param ...args 
	 * @return Dynamic
	 */
	public function callMethod(func:String, ...args:Dynamic):Dynamic {
		__mutex.acquire();
		__returnType = null;
		__returnValue = null;
		__call.push({
			methodName: func,
			args: args.toArray()
		});
		trace("调用", func, args.toArray());
		__mutex.release();
		while (true) {
			__mutex.acquire();
			if (__returnType == null) {
				__mutex.release();
				continue;
			}
			Sys.sleep(0.001);
			__mutex.release();
			return __returnValue;
		}
	}

	override function close() {
		this.__runing = false;
		this.writeString("\n");
		super.close();
	}
}

/**
 * 单次方法调用
 */
typedef RPCCall = {
	methodName:String,
	args:Array<Dynamic>
}
