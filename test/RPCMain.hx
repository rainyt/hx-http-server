import rpc.RPCClient;

/**
 * RPC测试
 */
class RPCMain {
	static function main() {
		var client = new RPCClient("127.0.0.1", 3556);
		var data = client.callMethod("call", 1, 1.2, "字符串", true, false, {
			key: "hello world"
		}, ["Goods RPC"]);
		trace("返回值：", data);
	}
}
