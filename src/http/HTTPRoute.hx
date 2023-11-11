package http;

import http.base.IRoute;

/**
 * 请求路由功能
 */
class HTTPRoute implements IRoute {
	/**
	 * 当前的路由ID
	 */
	public var routeId:String;

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
