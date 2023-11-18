package thread;

import haxe.EntryPoint;

/**
 * 线程池处理
 */
class Threads {
	/**
	 * 创建线程
	 * @param cb 
	 */
	public static function create(cb:Void->Void):Void {
		EntryPoint.addThread(cb);
	}
}
