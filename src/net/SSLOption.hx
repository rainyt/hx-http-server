package net;

import sys.io.File;
import sys.FileSystem;
import sys.ssl.Key;
import sys.ssl.Certificate;

class SSLOption {
	public var certificateContent:String = null;

	public var keyContent:String = null;

	public var certificate:Certificate;

	public var key:Key;

	public function new(certificatePath:String, keyPath:String) {
		if (FileSystem.exists(certificatePath)) {
			certificateContent = File.getContent(certificatePath);
			certificate = Certificate.loadFile(certificatePath);
		} else
			throw "certificatePath is not exists!";
		if (FileSystem.exists(keyPath)) {
			keyContent = File.getContent(keyPath);
			key = Key.loadFile(keyPath);
		} else
			throw "keyPath is not exists!";

		trace("certificate", certificate);
		trace("key", key);
	}
}
