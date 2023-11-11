package http;

/**
 * 请求上下文类型
 */
enum abstract HTTPContentType(String) to String from String {
	/**
	 * 这是POST方法的默认类型，也是最常见的一种。它表示表单数据以键值对的形式发送，键和值都经过了URL编码，即将特殊字符转换为%开头的十六进制数。例如，say=Hi&to=Mom。
	 */
	var APPLICATION_X_WWW_FORM_URLENCODED = "application/x-www-form-urlencoded";

	/**
	 * 这是一种用于上传文件或发送二进制数据的类型。它表示表单数据以多个部分发送，每个部分都有自己的内容类型和分隔符。例如，Content-Type: multipart/form-data; boundary=AaB03。
	 */
	var MULTIPART_FORM_DATA = "multipart/form-data";

	/**
	 * 这是一种用于发送JSON格式的数据的类型。它表示表单数据是一个序列化后的JSON字符串，可以支持更复杂的结构化数据。例如，Content-Type: application/json;charset=utf-8 {“title”:“test”,“sub”: [1,2,3]}。
	 */
	var APPLICATION_JSON = "application/json";

	/**
	 * 这是一种用于发送XML格式的数据的类型。它表示表单数据是一个XML文档，可以用标签和属性来表示数据的结构和含义。例如，Content-Type: text/xml <?xml version=“1.0” encoding=“UTF-8”?><greeting say=“Hi” to=“Mom” />。
	 */
	var TEXT_XML = "text/xml";
}
