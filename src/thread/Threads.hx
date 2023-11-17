package thread;

import sys.thread.FixedThreadPool;

/**
 * 线程池处理
 */
class Threads {
	/**
	 * 默认的最大线程，请在一开始就定义好最大的线程，以便程序创建时使用适当的线程数量。
	 */
	public static var maxThreads = 100;

	/**
	 * 固定的线程池
	 */
	private static var __pool:FixedThreadPool;

	/**
	 * 创建线程
	 * @param cb 
	 */
	public static function create(cb:Void->Void):Void {
		if (__pool == null) {
			__pool = new FixedThreadPool(maxThreads);
		}
		__pool.run(cb);
	}
}
