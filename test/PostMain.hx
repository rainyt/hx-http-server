import haxe.io.Bytes;
import haxe.Http;

/**
 * 测试POST数据
 */
class PostMain {
	static function main() {
		var http:Http = new Http("http://127.0.0.1:5555");
		http.setPostData("测试的数据");
		http.onData = (data) -> {
			trace("数据：", data);
		}
		http.request(true);

		var http:Http = new Http("http://127.0.0.1:5555");
		http.setPostBytes(Bytes.ofString("TESTEST"));
		http.onData = (data) -> {
			trace("数据：", data);
		}
		http.request(true);
	}
}
