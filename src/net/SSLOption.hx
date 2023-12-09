package net;

import sys.ssl.Key;
import sys.ssl.Certificate;

class SSLOption {
	public var certificate:Certificate;

	public var key:Key;

	public function new(certificatePath:String, keyPath:String) {
		certificate = Certificate.loadFile(certificatePath);
		key = Key.loadFile(keyPath);
	}
}
