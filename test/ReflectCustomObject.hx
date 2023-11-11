import http.route.HTTPReflectCustomObject;

/**
 * 自定义反射路由服务，每个方法会因为`ReflectRouteMacro`宏，获得一个`http`的对象，通过它进行发送消息。
 */
class ReflectCustomObject extends HTTPReflectCustomObject {
	/**
	 * 一个方法调用
	 * @param value1 
	 * @param int2 
	 */
	public function call1(value1:String, int2:Int):Void {
		http.send("Accest value is " + value1 + " and int2 is " + int2);
	}

	/**
	 * 一个计算除法的简单例子
	 * @param value1 
	 * @param value2 
	 */
	public function mathDiv(value1:Int, value2:Float):Void {
		http.send('int1/float=${value1 / value2}\npaths[1]=${http.param.at(1)}');
	}

	/**
	 * 通过POST数据处理
	 * @param value 
	 * @param value2 
	 */
	@:post
	public function postData(value:Int, value2:Int):Void {
		http.send("接受到POST数据：value=" + value + "&value2=" + value2);
	}
}
