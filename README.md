# HTTP Server
通过Haxe编写的HTTP服务器，基本功能已经准备好，正进入生产阶段。

## 支持
### RPC支持
带有常用的RPC接口，可参考`test/RPCMain.hx`
### 基础的HTTP服务功能
```haxe
// 创建基础的HTTP侦听服务
var ip:String = "0.0.0.0";
var port = 5555;
var http = new HTTPServer(ip, port, true);
http.start();
http.onConnectRequest = (client) -> {
   client.send("hello world.");
};
```
### 基础路由功能
```haxe
// 使用`addRoute`API可以轻松为请求添加路由
http.route.addRoute("/", (http) -> {
	trace("访问到了/路由", http.path);
	return true;
});
```
### 自定义路由服务
可参考`test/CustomRoute.hx`类的实现。
### 对象反射路由
通过一个对象，由`http.macro.ReflectRouteMacro`自动生成反射对象类，使它每个公开的方法都能够自动转换成路由方法，并遵循参数的可选不可选、参数名等。
同时，可以直接继承`http.route.HTTPReflectCustomObject`直接实现公开方法，请参考`ReflectCustomObject`。
### HTTPS（未完成）
它需要一个证书测试，我还没有进行这项测试。
### GET数据
通过`client.param.get`方法获得`?`后面的参数。
### POST数据
已支持`application/json`以及`application/x-www-form-urlencoded`支持，可通过`client.param.post`获得。
### HEADER头信息数据
通过`client.param.header`方法获得头信息参数。
### 数据后处理
通过`httpServer.onResponseAfter`接口处理最终输出的结果，可以在这里修改`client.response.data`参数处理最终输出结果。