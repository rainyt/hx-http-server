package utils;

import sys.thread.Mutex;

/**
 * 带有互斥锁的Map
 */
class MutexMap<T2> {
	private var __maps:Map<String, T2>;
	private var __mutex:Mutex = new Mutex();

	public var data(get, never):Map<String, T2>;

	function get_data():Map<String, T2> {
		return __maps;
	}

	public function new() {
		__maps = new Map();
	}

	public function acquireMutex():Void {
		__mutex.acquire();
	}

	public function relaseMutex():Void {
		__mutex.release();
	}

	public function get(id:String):T2 {
		__mutex.acquire();
		var v = __maps.get(id);
		__mutex.release();
		return v;
	}

	public function set(id:String, v:T2):Void {
		__mutex.acquire();
		__maps.set(id, v);
		__mutex.release();
	}

	public function exists(id:String):Bool {
		return __maps.exists(id);
	}

	public function remove(id:String):Void {
		__mutex.acquire();
		__maps.remove(id);
		__mutex.release();
	}
}
