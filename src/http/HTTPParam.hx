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
	 * 解析HTTP解析处理
	 * @param client 
	 */
	public function new(client:HTTPRequest) {
		// 这里是处理GET参数
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

	/**
	 * 追加参数数据
	 * @param data 
	 */
	public function pushStringParam(data:String):Void {}
}
