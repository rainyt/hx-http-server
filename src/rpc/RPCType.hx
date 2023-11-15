package rpc;

/**
 * 支持的RPC类型
 */
enum abstract RPCType(Int) to Int from Int {
	/**
	 * Int类型
	 */
	var INT = 1;

	/**
	 * 布尔值类型
	 */
	var BOOL = 3;

	/**
	 * 浮点类型
	 */
	var FLOAT = 2;

	/**
	 * String类型
	 */
	var STRING = 4;

	/**
	 * 二进制
	 */
	var BYTES = 5;

	/**
	 * 动态类型
	 */
	var OBJECT = 6;
}
