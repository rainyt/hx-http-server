package utils;

class Log {
	public static function info(...data:String):Void {
		Sys.println('\u001b[34m${data.toArray().join(", ")}');
	}

	public static function error(...data:String):Void {
		Sys.println('\u001b[31m${data.toArray().join(", ")}');
	}

	public static function warring(...data:String):Void {
		Sys.println('\u001b[33m${data.toArray().join(", ")}');
	}
}
