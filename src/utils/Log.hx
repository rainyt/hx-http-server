package utils;

class Log {
	public static function info(...data:String):Void {
		trace("INFO:", data.toArray());
	}
}
