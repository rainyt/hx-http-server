package;

import utils.Log;
import sys.FileSystem;
import haxe.io.Path;
import http.HTTPServer;

class Main {
	static function main() {
		// 启动一个服务器
		Log.info("启动服务器");
		var ip:String = "0.0.0.0";
		var port = 5555;
		var http = new HTTPServer(ip, port, true);
		http.start();
		http.onConnectRequest = (http) -> {
			Log.info("请求路径：", http.path);
			Log.info("请求方法：", http.method);
			var path = http.getLocalFilePath();
			if (FileSystem.exists(path)) {
				http.sendFile(http.path);
			} else
				http.send("hello world! File is not found: " + http.path);
		}
	}
}
