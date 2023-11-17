package utils;

import sys.thread.Mutex;
import sys.thread.Thread;

/**
 * 这是一个线程池
 */
class ThreadPool {
	/**
	 * 休眠时间
	 */
	public static inline var SLEEP_TIME = 0.001;

	/**
	 * 运行时
	 */
	private var __runing:Bool = true;

	/**
	 * 当前线程数量
	 */
	public var threadCounts:Int = 0;

	private var __mutex:Mutex = new Mutex();

	/**
	 * 需要工作的列表
	 */
	private var __works:Array<Void->Void> = [];

	/**
	 * 定义一个线程池
	 * @param maxThread 线程数量，默认为10
	 */
	public function new(maxThread:Int = 10) {
		for (i in 0...maxThread) {
			Thread.create(onWork);
		}
	}

	private function onWork():Void {
		while (__runing) {
			// 多线程执行
			var cb = read();
			if (cb != null)
				cb();
			Sys.sleep(SLEEP_TIME);
		}
	}

	/**
	 * 加入到线程当中，当存在空闲的线程时，就会执行此线程
	 * @param cb 
	 */
	public function create(cb:Void->Void):Void {
		__mutex.acquire();
		__works.push(cb);
		__mutex.release();
	}

	/**
	 * 读取一个线程
	 * @return Void->Void
	 */
	private function read():Void->Void {
		__mutex.acquire();
		if (__works.length > 0) {
			var v = __works.shift();
			__mutex.release();
			return v;
		}
		__mutex.release();
		return null;
	}
}
