# live_rtmp_push_plugin

一个Flutter Rtmp推送插件,Ios Android 采用金山SDK推流

采用的Flutter platformview

如果黑屏请检查权限,是否开启(模拟器会黑屏,真机却不会)


[TOC]


#TODO List

Android/Ios 方法一致性(现在可能存在一点不一致的情况)




## Android

```
AndroidView(
   viewType: "com.xinlianshiye.live",
   creationParams: <String, String>{
  },
  creationParamsCodec: const StandardMessageCodec(),
)
```

参数解释

* viewType
  **com.xinlianshiye.live**,必须这个跟注册的Id必须一致
* creationParams
  Map<String,String> 类型
* creationParamsCodec
  消息转化机制,按默认的cosnt StandardMessageCodec()即可
 

 
## IOS

```
UiKitView(
  viewType: "com.xinlianshiye.live",
  creationParams: <String, String>{
   "height":"200",
   "width":"200"
  }
)
```

- height 不传的情况下默认值为200
- width 不传的情况下默认值为200


#Flutter 方法

## setUrl
设置推流地址

## startPush
开始推流

## stopPush
停止推流

## startRecord
开始录像

## stopRecord
停止录像

## setFilter 
设置滤镜
## setCameraFacing
设置摄像头
## setTargetResolution
推流分辨率
## setPreviewResolution
预览分辨率



#问题列表


## Trying to embed a platform view but the PrerollContext does not support embedding

在Info.plist


```
key=io.flutter.embedded_views_preview 
value=YES
```