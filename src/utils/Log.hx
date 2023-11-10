package utils;

class Log {
	public static function info(...data:Dynamic):Void {
		trace("INFO:", data.toArray());
	}
}
