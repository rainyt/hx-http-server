package thread;

import utils.Log;
import sys.thread.Thread;
import haxe.EntryPoint;

/**
 * 线程池处理
 */
class Threads {
	/**
	 * 创建线程
	 * @param cb 
	 */
	public static function create(cb:Void->Void):Thread {
		return Thread.create(cb);
	}
}
