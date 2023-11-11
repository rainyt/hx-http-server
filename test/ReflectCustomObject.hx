@:keep
class ReflectCustomObject {

	public var custom = 0;

	public function new() {}

	public function call1(value1:String, int2:Int):Void {
		trace("访问到call1接口，并且接受到了数据：", value1, int2);
	}

	public function call2(int1:Int, float:Float):Void {
		trace("访问到call2接口，并且接受到了数据：", int1, float);
	}
}
