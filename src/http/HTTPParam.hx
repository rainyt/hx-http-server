package http;

/**
 * HTTP参数
 */
class HTTPParam {
	/**
	 * 已缓存的GET参数
	 */
	private var __gets:Map<String, String> = [];

	/**
	 * 已缓存的POST参数
	 */
	private var __posts:Map<String, String> = [];

	/**
	 * 请求对象
	 */
	public var client:HTTPRequest;

	/**
	 * 解析HTTP解析处理
	 * @param client 
	 */
	public function new(client:HTTPRequest) {
		// 这里是处理GET参数
		this.client = client;
		if (client.path.indexOf("?") != -1) {
			var params = client.path.split("?");
			client.path = params.shift();
			var getParam = params.join("");
			for (v in getParam.split("&")) {
				var p = v.split("=");
				__gets.set(p[0], p[1]);
			}
		}
	}

	/**
	 * 获得`GET`参数
	 * @param key 
	 * @return String
	 */
	public function get(key:String):String {
		return __gets.get(key);
	}

	/**
	 * 获得`POST`参数
	 * @param key 
	 * @return String
	 */
	public function post(key:String):String {
		return __posts.get(key);
	}

	private var __paths:Array<String> = null;

	/**
	 * 从`path`中获得参数，例如有一段`/path/url/value`，你需要获得到value，则需要通过：
	 * ```haxe
	 * at(2); // value
	 * ```
	 * @param i 
	 * @return String
	 */
	public function at(i:Int):String {
		if (__paths == null) {
			__paths = client.path.split("/");
			__paths.shift();
		}
		if (i < 0 || i >= __paths.length) {
			return null;
		}
		return __paths[i];
	}

	/**
	 * 追加参数数据
	 * @param data 
	 */
	public function pushStringParam(data:String):Void {}
}
