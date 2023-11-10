package http;

/**
 * HTTP请求码
 */
enum abstract HTTPRequestCode(Int) to Int from Int {
	var CONTINUE = 100;
	var SWITCHING_PROTOCOLS = 101;
	var PROCESSING = 102;
	var OK = 200;
	var CREATED = 201;
	var ACCEPTED = 202;
	var NON_AUTHORITATIVE_INFORMATION = 203;
	var NO_CONTENT = 204;
	var REQUEST_CONTENT = 205;
	var PARTIAL_CONTENT = 206;
	var MULTIPLE_CHOICES = 300;
	var MOVED_PERMANENTLY = 301;
	var FOUND = 302;
	var SEE_OTHER = 303;
	var NOT_MODIFIED = 304;
	var TEMPORARY_REDIRECT = 307;
	var PERMANENT_REDIRECT = 308;
	var BAD_REQUEST = 400;
	var UNAUTHORIZED = 401;
	var FORBIDDEN = 403;
	var NOT_FOUND = 404;
	var METHOD_NOT_ALLOWED = 405;
	var NOT_ACCEPTABLE = 406;
	var PROXY_AUTHENTICATION_REQUIRED = 407;
	var REQUEST_TIMEOUT = 408;
	var CONFLICT = 409;
	var GONE = 410;
	var LENGTH_REQUIRED = 411;
	var PRECONDITION_FAILED = 412;
	var PAYLOAD_TOO_LARGE = 413;
	var URI_TOO_LONG = 414;
	var UNSUPPORTED_MEDIA_TYPE = 415;
	var RANGE_NOT_SATISFIABLE = 416;
	var EXPECTATION_FAILED = 417;
	var IM_A_TEAPOT = 418;
	var MISDIRECTED_REQUEST = 419;
	var UPGRADE_REQUIRED = 426;
	var PRECONDITION_REQUIRED = 428;
	var TOO_MANY_REQUESTS = 429;
	var REQUEST_HEADER_FIELDS_TOO_LARGE = 431;
	var UNAVAILABLE_FOR_LEGAL_REASONS = 451;
	var INTERNAL_SERVER_ERROR = 500;
	var NOT_IMPLEMENTED = 501;
	var BAD_GATEWAY = 502;
	var SERVICE_UNAVAILABLE = 503;
	var GATEWAY_TIMEOUT = 504;
	var HTTP_VERSION_NOT_SUPPORTED = 505;
	var VARIANT_ALSO_NEGOTIATES = 506;
	var NOT_EXTENDED = 510;
	var NETWORK_AUTHENTICATION_REQUIRED = 511;

	public static function toMessageString(code:HTTPRequestCode):String {
		var message:String = "";
		switch (code) {
			case 100:
				message = "Continue";
			case 101:
				message = "Switching Protocols";
			case 102:
				message = "Processing";
			case 103:
				message = "Early Hints";
			case 200:
				message = "OK";
			case 201:
				message = "Created";
			case 202:
				message = "Accepted";
			case 203:
				message = "Non-authoritative Information";
			case 204:
				message = "No Content";
			case 205:
				message = "Reset Content";
			case 206:
				message = "Partial Content";
			case 207:
				message = "Multi-Status";
			case 208:
				message = "Already Reported";
			case 226:
				message = "IM Used";
			case 300:
				message = "Multiple Choices";
			case 301:
				message = "Moved Permanently";
			case 302:
				message = "Found";
			case 303:
				message = "See Other";
			case 304:
				message = "Not Modified";
			case 305:
				message = "Use Proxy";
			case 306:
				message = "unused";
			case 307:
				message = "Temporary Redirect";
			case 308:
				message = "Permanent Redirect";
			case 400:
				message = "Bad Request";
			case 401:
				message = "Unauthorized";
			case 402:
				message = "Payment Required";
			case 403:
				message = "Forbidden";
			case 404:
				message = "Not Found";
			case 405:
				message = "Method Not Allowed";
			case 406:
				message = "Not Acceptable";
			case 407:
				message = "Proxy Authentication Required";
			case 408:
				message = "Request Timeout";
			case 409:
				message = "Conflict";
			case 410:
				message = "Gone";
			case 411:
				message = "Length Required";
			case 412:
				message = "Precondition Failed";
			case 413:
				message = "Payload Too Large";
			case 414:
				message = "URI Too Long";
			case 415:
				message = "Unsupported Media Type";
			case 416:
				message = "Range Not Satisfiable";
			case 417:
				message = "Expectation Failed";
			case 418:
				message = "I'm a teapot";
			case 421:
				message = "Misdirected Request";
			case 422:
				message = "Unprocessable Content";
			case 423:
				message = "Locked";
			case 424:
				message = "Failed Dependency";
			case 425:
				message = "Too Early";
			case 426:
				message = "Upgrade Required";
			case 428:
				message = "Precondition Required";
			case 429:
				message = "Too Many Requests";
			case 431:
				message = "Request Header Fields Too Large";
			case 451:
				message = "Unavailable For Legal Reasons";
			case 500:
				message = "Internal Server Error";
			case 501:
				message = "Not Implemented";
			case 502:
				message = "Bad Gateway";
			case 503:
				message = "Service Unavailable";
			case 504:
				message = "Gateway Timeout";
			case 505:
				message = "HTTP Version Not Supported";
			case 506:
				message = "Variant Also Negotiates";
			case 507:
				message = "Insufficient Storage";
			case 508:
				message = "Loop Detected";
			case 510:
				message = "Not Extended";
			case 511:
				message = "Network Authentication Required";
			default:
		}
		return message;
	}
}
