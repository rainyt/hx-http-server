/**
 * 自定义反射路由服务，每个方法会因为`ReflectRouteMacro`宏，获得一个`http`的对象，通过它进行发送消息。
 */
@:keep
@:build(http.macro.ReflectRouteMacro.build())
class ReflectCustomObject {
	public var custom = 0;

	public function new() {}

	/**
	 * 一个方法调用
	 * @param value1 
	 * @param int2 
	 */
	public function call1(value1:String, int2:Int):Void {
		trace("访问到call1接口，并且接受到了数据：", value1, int2);
		http.send("Accest value is " + value1 + " and int2 is " + int2);
	}

	/**
	 * 一个计算除法的简单例子
	 * @param value1 
	 * @param value2 
	 */
	public function mathDiv(value1:Int, value2:Float):Void {
		trace("访问到call2接口，并且接受到了数据：", value1, value2);
		http.send('int1/float=${value1 / value2}\npaths[1]=${http.param.at(1)}');
	}

	/**
	 * POST数据获得
	 * @param value 
	 * @param value2 
	 */
	@:post
	public function postData(value:Int, value2:Int):Void {
		trace("将获得post数据：", value, value2);
		http.send("接受到POST数据：value=" + value + "&value2=" + value2);
	}
}
