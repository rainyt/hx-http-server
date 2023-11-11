package http.parser;

/**
 * 解析基础类
 */
@:using(utils.IParserTools)
interface IParser {
	/**
	 * 解析成功后的，OBJECT数据结构体
	 */
	public var data:Map<String, String>;

	/**
	 * 如果解析出现错误，应该抛出错误
	 * @param data 
	 */
	public function parser(data:String):Void;
}
