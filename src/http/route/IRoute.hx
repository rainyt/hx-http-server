package http.route;

interface IRoute extends IRuning{
	/**
	 * 当前的路由ID
	 */
	public var routeId:String;

	/**
	 * 服务
	 */
	public var server:HTTPServer;

	/**
	 * 路由方法，如果没有提供，则`GET`、`POST`都允许访问，如果提供了对应的方法，则需要指定的方法才能访问
	 */
	public var methods:Array<HTTPRequestMethod>;

	/**
	 * 初始化处理，这个时候已经存在server了
	 */
	public function onInit():Void;

	/**
	 * 路由请求进入时
	 * @param client 
	 * @return Bool 当返回`true`时，会继续向下一个路由进行访问，当返回`false`时，则会自动拦截。
	 */
	public function onConnectClient(client:HTTPRequest):Bool;
}
