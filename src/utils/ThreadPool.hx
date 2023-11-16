package utils;

import sys.thread.Mutex;
import sys.thread.Thread;

/**
 * 这是一个线程池
 */
class ThreadPool {
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
	 * @param maxThread 
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
		}
	}

	/**
	 * 创建线程
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
	public function read():Void->Void {
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
