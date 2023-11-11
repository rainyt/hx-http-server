package http.route;

import haxe.Json;
import http.route.HTTPRouteParamType;
import http.HTTPRequestMethod;
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
	private var __methods:Map<String, HTTPReflectRouteFunction> = [];

	/**
	 * 构造一个反射路由
	 * @param routeId 路由
	 * @param reflectObject 路由反射对象
	 */
	public function new(routeId:String, reflectObject:HTTPReflectCustomObject) {
		super(routeId);
		this.reflectObject = reflectObject;
	}

	override function onInit() {
		super.onInit();
		var reflectMaps:Map<String, Array<HTTPReflectFunctionParam>> = reflectObject.getProperty("reflectMaps");
		var reflectMethodMaps:Map<String, Array<HTTPRequestMethod>> = reflectObject.getProperty("reflectMethodMaps");
		for (key => value in reflectMaps) {
			var fun:Dynamic = reflectObject.getProperty(key);
			if (fun.isFunction()) {
				if (server.log) {
					Log.info("link reflect:", key, Json.stringify(value));
				}
				__methods.set(key, {
					fun: fun,
					args: value,
					method: reflectMethodMaps.get(key)
				});
				trace(key, reflectMethodMaps.get(key));
			}
		}
	}

	override function onConnectClient(client:HTTPRequest):Bool {
		// 请求处理
		var args = client.path.split("/");
		args.shift();
		if (args.length > 0) {
			args.remove(routeId.substr(1));
			var fun = args[0];
			if (client.server.log) {
				Log.info("route reflect call:", fun);
			}
			if (__methods.exists(fun)) {
				// TODO GET POST处理
				var fun:HTTPReflectRouteFunction = __methods.get(fun);
				var args:Array<Dynamic> = [client];
				for (a in fun.args) {
					var v:Dynamic = null;
					// 这是GET参数
					if (fun.method.contains(GET))
						v = client.param.get(a.name);
					// 这是POST参数
					if (fun.method.contains(POST)) {
						var v2 = client.param.post(a.name);
						if (v2 != null) {
							v = v2;
						}
					}
					// 这是可选判断，如果不可选时提供了`null`值，那么就会被服务器拒绝
					if (!a.opt && v == null) {
						if (server.log)
							Log.error("args error:", '${a.name} is null');
						client.send('Args ${a.name} is null', SERVICE_UNAVAILABLE);
						return false;
					}
					// 参数进行转义
					var argValue:Dynamic = switch (a.type) {
						case INT:
							Std.parseInt(v);
						case FLOAT:
							Std.parseFloat(v);
						default:
							v;
					}
					args.push(argValue);
				}
				reflectObject.callMethod(fun.fun, args);
				return true;
			} else {
				if (client.server.log)
					Log.error("reflect call fail:", fun, " by path " + client.path);
			}
		} else {
			// 方法不存在
			client.send("Not found " + client.path, NOT_FOUND);
		}
		return true;
	}
}

/**
 * 反射结构体
 */
typedef HTTPReflectRouteFunction = {
	fun:Dynamic,
	method:Array<HTTPRequestMethod>,
	args:Array<HTTPReflectFunctionParam>
}

/**
 * 反射请求参数
 */
typedef HTTPReflectFunctionParam = {
	var ?opt:Bool;
	var ?name:String;
	var ?type:HTTPRouteParamType;
}
