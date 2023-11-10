package;

import sys.FileSystem;
import http.HTTPServer;

class Main {
	static function main() {
		// 启动一个服务器
		trace("启动服务器");
		var ip:String = "0.0.0.0";
		var port = 5555;
		var http = new HTTPServer(ip, port, true);
		http.onConnectRequest = (http) -> {
			trace("请求路径：", http.path);
			trace("请求方法：", http.method);
			if (StringTools.endsWith(http.path, ".hl")) {
				http.sendFile(http.path);
			} else
				http.send("hello world!");
		}
		http.start();
	}
}
