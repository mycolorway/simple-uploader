simple-uploader
===============

一个不带UI的HTML5上传组件，为实现各种上传交互提供最大的灵活度。

依赖项：
* jQuery 2.0+
* [simple-module](https://github.com/mycolorway/simple-module)（组件抽象类）

浏览器支持：IE10+、Chrome、Safari、Firefox。

###使用方法

首先在页面里引用相关脚本：

```html
<script type="text/javascript" src="path/to/jquery.min.js"></script>
<script type="text/javascript" src="path/to/module.js"></script>
<script type="text/javascript" src="path/to/uploader.js"></script>

```

初始化uploader实例：

```js
var uploader = simple.uploader({
    url: '/upload'
});

```

获取文件对象，然后通过uploader上传：

```
$('#select-file').on('change', function(e) {
    uploader.upload(this.files);
});
```

###API文档

####初始化选项

__url__

上传接口地址，必选。

__params__

hash对象，上传请求附带的参数，可选

__fileKey__

服务器端获取上传文件的key，可选，默认是'upload_file'

__connectionCount__

允许同时上传的文件数量，可选，默认值是3

####方法

uploader实例会暴露一些公共方法：

__upload__ ([File Object]/[Input Element]/[File Array])

开始上传的接口，可以接受的参数有：File对象（通过input:file选择或者通过拖拽接口获取）、input:file元素或者File对象的数组。

__cancel__ (file/fileId)

取消上传某个文件，可以接受事件传出来的file对象或者file的id。

__destroy__

摧毁uploader实例

__readImageFile__ ([File Object], callback)

通过图片的File对象获取图片的base64预览图，在上传图片之前需要预览的时候非常有用。

####事件

uploader实例可以绑定一些自定义事件，例如：

```js
uploader.on('beforeupload', function(e, file) {
  // do something before upload
});
```

__beforeupload__ (e, file)

上传开始之前触发，`return false`可以取消上传

__uploadprogress__ (e, file, loaded, total)

上传的过程中会触发多次，`loaded`是已经上传的大小，`total`是文件的总大小，但是是byte。

__uploadsuccess__ (e, file, result)

上传成功的时候触发，`result`是服务器端返回的json响应。

__uploaderror__ (e, file, xhr, status)

上传失败的时候触发，`xhr`是上传接口的XMLHttpRequest对象，`status`是报错信息。

__uploadcomplete__ (e, file, responseText)

无论上传成功还是失败都会触发这个事件，responseText是响应的文本字符串。

__uploadcancel__ (e, file)

调用uploader.cancel()方法取消上传的时候会触发这个事件


