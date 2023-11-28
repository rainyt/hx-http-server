package utils;

import haxe.Exception;

class Log {
	public static function info(...data:String):Void {
		Sys.println('\u001b[32m[INFO] ${data.toArray().join(", ")}');
	}

	public static function debug(...data:String):Void {
		Sys.println('\u001b[34m[DEBUG] ${data.toArray().join(", ")}');
	}

	public static function error(...data:String):Void {
		Sys.println('\u001b[31m[ERROR]${data.toArray().join(", ")}');
	}

	public static function warring(...data:String):Void {
		Sys.println('\u001b[33m[WARRING]${data.toArray().join(", ")}');
	}

	public static function exception(e:Exception):Void {
		Log.error(e.message);
		Log.error(e.stack.toString());
	}
}
