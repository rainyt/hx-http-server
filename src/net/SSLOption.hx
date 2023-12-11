package net;

import sys.io.File;
import sys.FileSystem;
import sys.ssl.Key;
import sys.ssl.Certificate;

/**
 * 当使用`SSLOption`配置启动LTS时，网站端口一般为`443`，如果希望浏览器可以直接访问，则启用`443`端口。
 */
class SSLOption {
	/**
	 * Certificate证书
	 */
	public var certificate:Certificate;

	/**
	 * Key证书
	 */
	public var key:Key;

	/**
	 * TODO 是否仍然需要HTTP支持，默认为`false`，当设置为`true`时，则会支持`80`端口的访问。
	 */
	@:noCompletion public var embedHttpSupport:Bool = false;

	public function new(certificatePath:String, keyPath:String) {
		if (FileSystem.exists(certificatePath)) {
			certificate = Certificate.loadFile(certificatePath);
		} else
			throw "certificatePath is not exists!";
		if (FileSystem.exists(keyPath)) {
			key = Key.loadFile(keyPath);
		} else
			throw "keyPath is not exists!";
	}
}
