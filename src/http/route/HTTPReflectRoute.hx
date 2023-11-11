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
	public function new(routeId:String, reflectObject:Dynamic) {
		super(routeId);
		this.reflectObject = reflectObject;
	}

	override function onInit() {
		super.onInit();
		var reflectMaps:Map<String, Array<HTTPReflectFunctionParam>> = reflectObject.getProperty("reflectMaps");
		for (key => value in reflectMaps) {
			var fun:Dynamic = reflectObject.getProperty(key);
			if (fun.isFunction()) {
				if (server.log) {
					Log.info("link reflect:", key, Json.stringify(value));
				}
				__methods.set(key, {
					fun: fun,
					args: value,
					method: GET
				});
			}
		}
	}

	override function onConnectClient(client:HTTPRequest):Bool {
		// 请求处理
		var args = client.path.split("/");
		if (args.length > 0) {
			var fun = args[args.length - 1];
			if (client.server.log) {
				Log.info("reflect call:", fun);
			}
			if (__methods.exists(fun)) {
				// TODO GET POST处理
				var fun:HTTPReflectRouteFunction = __methods.get(fun);
				var args:Array<Dynamic> = [client];
				trace(fun.args);
				for (a in fun.args) {
					var v = client.param.get(a.name);
					if (!a.opt && v == null) {
						client.send('Args ${a.name} is null', SERVICE_UNAVAILABLE);
						return false;
					}
					var argValue:Dynamic = switch (a.type) {
						case INT:
							Std.parseInt(v);
						default:
							v;
					}
					trace("a.type", a.type, a.name, argValue);
					args.push(argValue);
				}
				reflectObject.callMethod(fun.fun, args);
				return true;
			} else {
				if (client.server.log)
					Log.error("reflect call fail:", fun);
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
	method:HTTPRequestMethod,
	args:Array<HTTPReflectFunctionParam>
}

/**
 * 反射请求参数
 */
typedef HTTPReflectFunctionParam = {
	var opt:Bool;
	var name:String;
	var type:HTTPRouteParamType;
}
