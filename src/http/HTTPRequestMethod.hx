package http;

/**
 * 请求方法
 */
enum abstract HTTPRequestMethod(String) to String from String {
	var POST = "POST";
	var GET = "GET";
}
