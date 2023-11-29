package thread;

import utils.Log;
import sys.thread.Thread;
import haxe.EntryPoint;

/**
 * 线程池处理
 */
class Threads {
	/**
	 * 线程数量
	 */
	private static var threadCounts:Int = 0;

	/**
	 * 创建线程
	 * @param cb 
	 */
	public static function create(cb:Void->Void):Void {
		// EntryPoint.addThread(cb);
		threadCounts++;
		Log.info("Thread Counts:" + threadCounts);
		Thread.create(() -> {
			cb();
			threadCounts--;
		});
	}
}
