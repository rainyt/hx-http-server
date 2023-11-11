package http;

import http.HTTPRoute;
import http.base.IRoute;

/**
 * 路由管理器
 */
class HTTPRouteManager {
	/**
	 * 路由映射
	 */
	public var routes:Map<String, IRoute> = [];

	public function new() {}

	/**
	 * 添加路由
	 * @param route 一般指的是请求路由，一般为：/api/get2/name3
	 * @param cb 路由发生请求时触发事件，返回`true`则会进入下一个路由，返回`false`则会停止进入下一个路由。
	 */
	public function addRoute(route:String, cb:HTTPRequest->Bool):Void {
		if (route.charAt(0) != "/") {
			route = "/" + route;
		}
		if (route.length > 1 && route.charAt(route.length - 1) == "/") {
			route = route.substr(0, route.length - 1);
		}
		var newRoute = new HTTPRoute(route);
		newRoute.onConnectClientEvent = cb;
		routes.set(route, newRoute);
	}

	/**
	 * 尝试调用路由
	 * @param route 
	 */
	public function callRoute(route:String, client:HTTPRequest):Void {
		route = route.substr(1);
		var routeList = route.split("/");
		var currentRoute = "/";
		if (__route(currentRoute, client)) {
			for (route in routeList) {
				currentRoute += route;
				if (__route(currentRoute, client)) {
					currentRoute += "/";
				}
			}
		}
	}

	/**
	 * 访问路由
	 * @param route 
	 * @param client 
	 * @return Bool
	 */
	private function __route(route:String, client:HTTPRequest):Bool {
		if (routes.exists(route)) {
			return routes.get(route).onConnectClient(client);
		}
		return true;
	}
}
