# HTTP Server
通过Haxe编写的HTTP服务器，基本功能已经准备好，正进入生产阶段。

## 支持
- [x] 基础的HTTP服务功能
> 创建基础的HTTP侦听服务：
> ```haxe
> var ip:String = "0.0.0.0";
> var port = 5555;
> var http = new HTTPServer(ip, port, true);
> http.start();
> http.onConnectRequest = (client) -> {
>    client.send("hello world.");
> };
> ```
- [x] 基础路由功能
> 使用`addRoute`API可以轻松为请求添加路由：
> ```haxe
> http.route.addRoute("/", (http) -> {
>	trace("访问到了/路由", http.path);
>	return true;
> });
> ```
- [x] 自定义路由服务
> 可参考`test/CustomRoute.hx`类的实现。
- [x] 对象反射路由
> 通过一个对象，由`http.macro.ReflectRouteMacro`自动生成反射对象类，使它每个公开的方法都能够自动转换成路由方法，并遵循参数的可选不可选、参数名等。
> 同时，可以直接继承`http.route.HTTPReflectCustomObject`直接实现公开方法，请参考`ReflectCustomObject`。
- [ ] HTTPS
> 它需要一个证书测试，我还没有进行这项测试。
- [x] GET数据
> 通过`client.param.get`方法获得`?`后面的参数。
- [x] POST数据
> 已支持`application/json`以及`application/x-www-form-urlencoded`支持。