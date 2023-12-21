package http;

enum abstract HTTPVersion(String) to String from String {
	/**
	 * HTTP1协议
	 */
	var HTTP1 = "HTTP/1";

	/**
	 * HTTP1.1协议
	 */
	var HTTP1_1 = "HTTP/1.1";

	/**
	 * HTTP2协议
	 */
	var HTTP2 = "HTTP/2";
}
