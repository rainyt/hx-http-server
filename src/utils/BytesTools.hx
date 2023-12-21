package utils;

import haxe.io.Bytes;

/**
 * 字节工具
 */
class BytesTools {
	/**
	 * 获得24字节的Int整数
	 * @param bytes 
	 * @param pos 
	 * @return Int
	 */
	public static function getInt24(bytes:Bytes, pos:Int):Int {
		var b1 = bytes.get(pos);
		var b2 = bytes.get(pos + 1);
		var b3 = bytes.get(pos + 2);
		var ret = 0;
		ret |= b1 << 16;
		ret |= b2 << 8;
		ret |= b3;
		return ret;
	}

	/**
	 * 获得8字节的Int整数
	 * @param bytes 
	 * @param pos 
	 * @return Int
	 */
	public static function getInt8(bytes:Bytes, pos:Int):Int {
		var b1 = bytes.get(pos);
		var ret = 0;
		ret |= b1;
		trace("b1=", pos, b1);
		return ret;
	}
}
