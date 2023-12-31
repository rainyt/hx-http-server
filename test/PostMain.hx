import utils.Log;
import haxe.Json;
import haxe.io.Bytes;
import haxe.Http;

/**
 * 测试POST数据
 */
class PostMain {
	static function main() {
		// 这是GET数据请求测试
		var http:Http = new Http("http://127.0.0.1:5555");
		http.setPostData("测试的数据");
		http.onData = (data) -> {
			Log.warring("GET数据：", data);
		}
		http.request(false);

		// 这是POST数据请求测试
		var http:Http = new Http("http://127.0.0.1:5555/reflect/postData");
		http.setHeader("Content-Type", "application/json");
		http.setPostBytes(Bytes.ofString(Json.stringify({
			value: 1,
			value2: 2
		})));
		http.onStatus = (status) -> {
			Log.warring("状态：", Std.string(status));
		}
		http.onData = (data) -> {
			Log.warring("POST数据：", data);
		}
		http.request(true);
	}
}
