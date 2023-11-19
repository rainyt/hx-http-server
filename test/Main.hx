package;

import utils.Log;
import sys.FileSystem;
import http.HTTPServer;

class Main {
	static function main() {
		// 启动一个服务器
		Log.info("Server start.");
		var ip:String = "0.0.0.0";
		var port = 5555;
		var http = new HTTPServer(ip, port, true);
		// 启动SSL
		// http.ssl = true;
		http.start();
		http.onConnectRequest = (http) -> {
			var path = http.getLocalFilePath();
			if (FileSystem.exists(path)) {
				http.sendFile(http.path);
			} else
				http.send("Hello world! File is not found: " + http.path);
		}
		// 路由功能测试
		http.route.addRoute("/", (http) -> {
			Log.warring("Hi, '/' route", http.path);
			return true;
		});
		http.route.addRoute("/index.html", (http) -> {
			Log.warring("Hi, '/index.html' route", http.path);
			return true;
		});
		// 自定义路由功能
		http.route.addRouteObject(new CustomRoute("/api"));
		// 自定义反射对象路由
		http.route.addReflectRoute("/reflect", new ReflectCustomObject());
	}
}
