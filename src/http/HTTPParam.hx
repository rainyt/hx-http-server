package http;

import utils.Log;
import haxe.Exception;
import haxe.macro.Expr;
import http.parser.JsonData;
import http.parser.FormData;

/**
 * HTTP参数
 */
class HTTPParam {
	/**
	 * 已缓存的GET参数
	 */
	private var __gets:Map<String, String> = [];

	public function getFields():Map<String, String> {
		return __gets;
	}

	/**
	 * 已缓存的POST参数
	 */
	private var __posts:Map<String, String> = [];

	public function postFields():Map<String, String> {
		return __posts;
	}

	/**
	 * 已缓存的头信息
	 */
	private var __header:Map<String, String> = [];

	public function headerFields():Map<String, String> {
		return __header;
	}

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
	}

	/**
	 * 解析数据
	 */
	public function parserData():Void {
		if (client.path.indexOf("?") != -1) {
			var params = client.path.split("?");
			client.path = params.shift();
			var getParam = params.join("");
			var mapParam = new FormData();
			mapParam.parser(getParam);
			mapParam.copyTo(__gets);
		}
		try {
			if (client.postData != null) {
				// 这里是处理POST数据
				switch client.contentType {
					case APPLICATION_X_WWW_FORM_URLENCODED:
						// 表单数据
						var mapParam = new FormData();
						mapParam.parser(client.postData.toString());
						mapParam.copyTo(__posts);
					case MULTIPART_FORM_DATA:
					// TODO
					case APPLICATION_JSON:
						// JSON数据
						var mapParam = new JsonData();
						mapParam.parser(client.postData.toString());
						mapParam.copyTo(__posts);
					case TEXT_XML:
						// 默认不处理
				}
			}
		} catch (e:Exception) {
			Log.exception("HTTPParam", e);
		}
	}

	/**
	 * 获得`头信息`中的信息，通过键值
	 * @param key 
	 * @return String
	 */
	public function header(key:String):String {
		return __header.get(key.toLowerCase());
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
	public function pushHeader(key:String, value:String):Void {
		__header.set(key.toLowerCase(), value);
	}
}
