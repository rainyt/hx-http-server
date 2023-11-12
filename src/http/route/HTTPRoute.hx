package http.route;

import http.route.IRoute;

/**
 * 请求路由功能
 */
class HTTPRoute implements IRoute {
	/**
	 * 当前的路由ID
	 */
	public var routeId:String;

	/**
	 * 路由方法，如果没有提供，则`GET`、`POST`都允许访问，如果提供了对应的方法，则需要指定的方法才能访问
	 */
	public var methods:Array<HTTPRequestMethod>;

	/**
	 * 服务
	 */
	public var server:HTTPServer;

	/**
	 * 初始化处理，这个时候已经存在server了
	 */
	public function onInit():Void {}

	/**
	 * 构造一个路由
	 * @param route 
	 */
	public function new(route:String) {
		if (route.charAt(0) != "/") {
			route = "/" + route;
		}
		if (route.length > 1 && route.charAt(route.length - 1) == "/") {
			route = route.substr(0, route.length - 1);
		}
		this.routeId = route;
	}

	/**
	 * 事件访问
	 * @param client 
	 * @return Bool
	 */
	dynamic public function onConnectClientCallBack(client:HTTPRequest):Bool {
		return true;
	}

	/**
	 * 路由请求进入时
	 * @param client 
	 * @return Bool 当返回`true`时，会继续向下一个路由进行访问，当返回`false`时，则会自动拦截。
	 */
	public function onConnectClient(client:HTTPRequest):Bool {
		return onConnectClientCallBack(client);
	}
}
