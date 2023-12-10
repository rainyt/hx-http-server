package http;

import http.route.HTTPReflectRoute;
import http.route.HTTPReflectCustomObject;
import http.route.HTTPRoute;
import http.route.IRoute;

/**
 * 路由管理器
 */
class HTTPRouteManager implements IRuning {
	/**
	 * 路由映射
	 */
	public var routes:Map<String, Array<IRoute>> = [];

	/**
	 * 服务
	 */
	public var server:HTTPServer;

	public function new(server:HTTPServer) {
		this.server = server;
	}

	/**
	 * 添加路由
	 * @param route 一般指的是请求路由，一般为：/api/get2/name3
	 * @param cb 路由发生请求时触发事件，返回`true`则会进入下一个路由，返回`false`则会停止进入下一个路由。
	 */
	public function addRoute(route:String, cb:HTTPRequest->Bool, ?methods:Array<HTTPRequestMethod>):Void {
		var newRoute = new HTTPRoute(route);
		newRoute.onConnectClientCallBack = cb;
		addRouteObject(newRoute, methods);
	}

	public function getRoute(route:String):Dynamic {
		return routes.get(route);
	}

	public function getReflectRouteObject(route:String):Dynamic {
		for (route in routes.get(route)) {
			if (route is HTTPReflectRoute) {
				return cast(route, HTTPReflectRoute).reflectObject;
			}
		}
		return null;
	}

	/**
	 * 添加反射对象路由
	 * @param route 
	 * @param object 
	 */
	public function addReflectRoute(route:String, object:HTTPReflectCustomObject, ?methods:Array<HTTPRequestMethod>):Void {
		this.addRouteObject(new HTTPReflectRoute(route, object), methods);
	}

	/**
	 * 添加路由对象
	 * @param route 
	 */
	public function addRouteObject(route:IRoute, ?methods:Array<HTTPRequestMethod>):Void {
		if (!routes.exists(route.routeId)) {
			routes.set(route.routeId, []);
		}
		route.server = this.server;
		if (methods != null)
			route.methods = methods.copy();
		routes.get(route.routeId).push(route);
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

	public function onRuning() {
		for (array in this.routes) {
			for (route in array) {
				route.onRuning();
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
			var list = routes.get(route);
			for (route in list) {
				if (route.methods == null || route.methods.contains(client.method))
					if (!route.onConnectClient(client))
						return false;
			}
			return true;
		}
		return true;
	}
}
