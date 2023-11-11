package http.route;

enum abstract HTTPRouteParamType(String) to String from String {
	var INT = "Int";
	var STRING = "String";
	var FLOAT = "Float";
}
