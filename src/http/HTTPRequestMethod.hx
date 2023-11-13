package http;

/**
 * 请求方法
 */
enum abstract HTTPRequestMethod(String) to String from String {
	/**
	 * POST请求
	 */
	var POST = "POST";

	/**
	 * GET请求
	 */
	var GET = "GET";

	/**
	 * 预检请求
	 */
	var OPTIONS = "OPTIONS";
}
