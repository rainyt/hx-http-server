package http;

import http.route.HTTPReflectRoute;
import http.route.HTTPReflectCustomObject;
import http.route.HTTPRoute;
import http.route.IRoute;

/**
 * 路由管理器
 */
class HTTPRouteManager {
	/**
	 * 路由映射
	 */
	public var routes:Map<String, IRoute> = [];

	public var server:HTTPServer;

	public function new(server:HTTPServer) {
		this.server = server;
	}

	/**
	 * 添加路由
	 * @param route 一般指的是请求路由，一般为：/api/get2/name3
	 * @param cb 路由发生请求时触发事件，返回`true`则会进入下一个路由，返回`false`则会停止进入下一个路由。
	 */
	public function addRoute(route:String, cb:HTTPRequest->Bool):Void {
		var newRoute = new HTTPRoute(route);
		newRoute.onConnectClientCallBack = cb;
		addRouteObject(newRoute);
	}

	/**
	 * 添加反射对象路由
	 * @param route 
	 * @param object 
	 */
	public function addReflectRoute(route:String, object:HTTPReflectCustomObject):Void {
		this.addRouteObject(new HTTPReflectRoute(route, object));
	}

	/**
	 * 添加路由对象
	 * @param route 
	 */
	public function addRouteObject(route:IRoute):Void {
		if (routes.exists(route.routeId)) {
			routes.get(route.routeId).server = null;
		}
		route.server = this.server;
		routes.set(route.routeId, route);
		route.onInit();
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
			if (routeList[0] != "")
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
