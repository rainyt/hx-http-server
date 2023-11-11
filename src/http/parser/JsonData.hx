package http.parser;

import haxe.Json;

/**
 * JSON数据解析
 */
class JsonData implements IParser {
	public var data:Map<String, String> = [];

	public function new() {}

	public function parser(jsonData:String) {
		var json = Json.parse(jsonData);
		var keys = Reflect.fields(json);
		for (key in keys) {
			data.set(key, Reflect.getProperty(json, key));
		}
	}
}
