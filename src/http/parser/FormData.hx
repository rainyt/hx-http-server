package http.parser;

/**
 * 解析表单的支持
 */
class FormData implements IParser {
	public var data:Map<String, String> = [];

	public function new() {}

	public function parser(param:String) {
		for (v in param.split("&")) {
			var p = v.split("=");
			data.set(p[0], p[1]);
		}
	}
}
