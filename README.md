# HTTP Server
通过Haxe编写的HTTP服务器，开发中

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
> 
- [x] 自定义路由服务
- [x] 对象反射路由
- [ ] HTTPS
- [x] GET数据
- [ ] POST数据