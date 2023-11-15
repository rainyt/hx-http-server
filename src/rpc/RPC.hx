package rpc;

class RPC {
	public function new() {}

	/**
	 * 调用方法
	 * @param methodName 
	 * @param args 
	 * @return Dynamic
	 */
	public function callMethod(methodName:String, args:Array<Dynamic>):Dynamic {
		var fun = Reflect.getProperty(this, methodName);
		if (fun != null) {
			return Reflect.callMethod(this, fun, args);
		}
		return null;
	}
}
