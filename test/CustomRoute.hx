import sys.io.File;
import http.HTTPRequest;
import http.HTTPRoute;

/**
 * 自定义路由
 */
class CustomRoute extends HTTPRoute {
	override function onConnectClient(client:HTTPRequest):Bool {
		var content = File.getContent("./index.html");
		content = StringTools.replace(content, "Hello World", "Custom Route");
		client.send(content);
		return true;
	}
}
