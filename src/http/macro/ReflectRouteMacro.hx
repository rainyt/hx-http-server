package http.macro;

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
		var reflectMaps:Map<String, Array<Dynamic>> = [];
		for (item in fileds) {
			if (item.name == "new")
				continue;
			if (item.access.contains(APublic) && !item.access.contains(AStatic)) {
				// 公开的定义进行解析
				switch item.kind {
					case FFun(f):
						// 仅解析方法，这里得到所有参数变量名和类型
						var args:Array<Dynamic> = [];
						for (index => a in f.args) {
							var params:DynamicAccess<Dynamic> = {};
							params["name"] = a.name;
							params["opt"] = a.opt;
							switch a.type {
								case TPath(p):
									var paths = p.pack.copy();
									paths.push(p.name);
									params["type"] = paths.join(".");
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
						trace("fun:", item.name);
					default:
				}
			}
		}
		// 然后添加`reflectMaps`映射关系
		fileds.push({
			name: "reflectMaps",
			pos: Context.currentPos(),
			kind: FVar(macro :Map<String, Array<Dynamic>>, macro $v{reflectMaps})
		});
		return fileds;
	}
}
#end
