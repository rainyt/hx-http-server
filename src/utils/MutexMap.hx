package utils;

import sys.thread.Mutex;

/**
 * 带有互斥锁的Map
 */
class MutexMap<T2> {
	private var __maps:Map<String, T2>;
	private var __mutex:Mutex = new Mutex();

	public function new() {
		__maps = new Map();
	}

	public function get(id:String):T2 {
		return __maps.get(id);
	}

	public function set(id:String, v:T2):Void {
		__mutex.acquire();
		__maps.set(id, v);
		__mutex.release();
	}
}