package http.macro;

import http.route.HTTPReflectRoute.HTTPReflectFunctionParam;
import haxe.DynamicAccess;
import haxe.macro.Context;
import haxe.macro.Expr.Field;

/**
 * 反射路由宏，为每个符合条件的方法，进行API变量分析并反射处理，以便可以访问`HTTPRequest`对象。
 * 第一步：
 * 将会产生一个`reflectMaps`的方法反射映射字典对象，以便反射的时候，可以直接读取到方法。
 */
#if macro
class ReflectRouteMacro {
	public static function build():Array<Field> {
		var fileds = Context.getBuildFields();
		// 这是方法属性定义
		var reflectMaps:Map<String, Array<HTTPReflectFunctionParam>> = [];
		// 这是方法访问定义 GET POST
		var reflectMethodMaps:Map<String, Array<HTTPRequestMethod>> = [];
		for (item in fileds) {
			if (item.name == "new")
				continue;
			if (item.access.contains(APublic) && !item.access.contains(AStatic)) {
				// 公开的定义进行解析
				switch item.kind {
					case FFun(f):
						var methods:Array<HTTPRequestMethod> = [];
						var array = item.meta.map((f) -> f.name == ":post");
						if (array.length > 0) {
							// POST请求
							methods.push(POST);
						}
						var array = item.meta.map((f) -> f.name == ":get");
						if (array.length > 0) {
							// GET请求
							methods.push(GET);
						}
						// 默认支持GET
						if (methods.length == 0) {
							methods.push(GET);
						}
						reflectMethodMaps.set(item.name, methods);
						// 仅解析方法，这里得到所有参数变量名和类型
						var args:Array<HTTPReflectFunctionParam> = [];
						for (index => a in f.args) {
							var params:HTTPReflectFunctionParam = {};
							params.name = a.name;
							params.opt = a.opt;
							switch a.type {
								case TPath(p):
									var paths = p.pack.copy();
									paths.push(p.name);
									params.type = paths.join(".");
								default:
									throw "Not support " + a.type.getName() + " args";
							}
							args.push(params);
						}
						reflectMaps.set(item.name, args);
						// 为所有方法的第一位，添加一个http的变量传参，它是`HTTPRequest`类型。
						f.args.insert(0, {
							name: "http",
							type: macro :http.HTTPRequest
						});
					default:
				}
			}
		}
		// 然后添加`reflectMaps`映射关系
		fileds.push({
			name: "reflectMaps",
			pos: Context.currentPos(),
			kind: FVar(macro :Map<String, Array<http.route.HTTPReflectRoute.HTTPReflectFunctionParam>>, macro $v{reflectMaps})
		});
		// 添加`reflectMethodMaps`方法关系
		fileds.push({
			name: "reflectMethodMaps",
			pos: Context.currentPos(),
			kind: FVar(macro :Map<String, Array<http.HTTPRequestMethod>>, macro $v{reflectMethodMaps})
		});
		return fileds;
	}
}
#end
