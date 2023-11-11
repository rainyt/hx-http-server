build:
	haxe build.hxml
	hl ./bin/server.hl

build_cpp:
	haxe build-cpp.hxml
	./bin/cpp/Main