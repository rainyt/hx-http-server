package http.base;

interface IRoute {
	/**
	 * 当前的路由ID
	 */
	public var routeId:String;

	/**
	 * 路由请求进入时
	 * @param client 
	 * @return Bool 当返回`true`时，会继续向下一个路由进行访问，当返回`false`时，则会自动拦截。
	 */
	public function onConnectClient(client:HTTPRequest):Bool;
}
