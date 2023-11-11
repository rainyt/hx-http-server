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
		this.routeId = route;
	}

	/**
	 * 事件访问
	 * @param client 
	 * @return Bool
	 */
	dynamic public function onConnectClientEvent(client:HTTPRequest):Bool {
		return true;
	}

	/**
	 * 路由请求进入时
	 * @param client 
	 * @return Bool 当返回`true`时，会继续向下一个路由进行访问，当返回`false`时，则会自动拦截。
	 */
	public function onConnectClient(client:HTTPRequest):Bool {
		return onConnectClientEvent(client);
	}
}
