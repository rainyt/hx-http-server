package http.route;

import utils.Log;

using Reflect;

/**
 * 反射路由，会将一个对象中的所有方法变成可访问的路由接口，例如：
 * ```haxe
 * routeId = "/api"
 * obj = {
 *  function1:function(value1,value2){
 *      trace("function1", value1, value2);
 *  }
 * }
 * ```
 * 那么这时候，访问function1，只需要通过路由：
 * ```haxe
 * // GET访问
 * /api/function1?value1=123123&value2=123
 * // POST访问，数据通过表单发送
 * /api/function1
 * ```
 * 当不存在相关的方法时，该接口则会跳过，将寻找下一个路由。
 */
class HTTPReflectRoute extends HTTPRoute {
	/**
	 * 反射的路由对象
	 */
	public var reflectObject:Dynamic;

	/**
	 * 已反射好的方法列表
	 */
	private var __methods:Map<String, Dynamic> = [];

	/**
	 * 构造一个反射路由
	 * @param routeId 路由
	 * @param reflectObject 路由反射对象
	 */
	public function new(routeId:String, reflectObject:Dynamic) {
		super(routeId);
		this.reflectObject = reflectObject;
	}

	override function onInit() {
		super.onInit();
		for (key in reflectObject.fields()) {
			var value:Dynamic = reflectObject.getProperty(key);
			if (server.log)
				Log.warring("check", key, Std.string(value));
			if (value.isFunction()) {
				if (server.log) {
					Log.info("reflect function:", key);
				}
			}
		}
	}

	override function onConnectClient(client:HTTPRequest):Bool {
		return true;
	}
}
