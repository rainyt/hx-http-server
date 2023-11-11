package utils;

import http.parser.IParser;

class IParserTools {
	public static function copyTo(data:IParser, map:Map<String, String>):Void {
		for (key => value in data.data) {
			map.set(key, value);
		}
	}
}
