/**
 * 自定义反射路由服务
 */
@:keep
@:build(http.macro.ReflectRouteMacro.build())
class ReflectCustomObject {
	public var custom = 0;

	public function new() {}

	public function call1(value1:String, int2:Int):Void {
		trace("访问到call1接口，并且接受到了数据：", value1, int2);
		http.send("Accest value is " + value1 + " and int2 is " + int2);
	}

	public function mathDiv(value1:Int, value2:Float):Void {
		trace("访问到call2接口，并且接受到了数据：", value1, value2);
		http.send('int1/float=${value1 / value2}');
	}
}
