import rpc.RPCClient;

/**
 * RPC测试
 */
class RPCMain {
	static function main() {
		trace(1.1 is Int, 1.1 is Float);
		var client = new RPCClient("127.0.0.1", 3556);
		trace("准备调用");
		var data = client.callMethod("queryUserDataByUid", "testid");
		var data = client.callMethod("queryUserDataByUid", "testid");
		var data = client.callMethod("queryUserDataByUid", "testid");
		var data = client.callMethod("queryUserDataByUid", "testid");
		var data = client.callMethod("updateV3Server", "testid", {});
		client.close();
		// var data = client.callMethod("call", 1, 10.2123123, "字符串", true, false, {
		// 	key: "hello world"
		// }, ["Goods RPC"]);
		trace("返回值：", data);
	}
}
