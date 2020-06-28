import 'dart:async';

import 'package:flutter/services.dart';

class LiveRtmpPushPlugin {
  static const MethodChannel _channel =
      const MethodChannel('com/xinlianshiye/live/action');
   static const MethodChannel _channel2 =
      const MethodChannel('live_rtmp_push_plugin');

  static Future<bool> setUrl(String url) async {
    final String result = await _channel.invokeMethod("setUrl", url);
    return "TRUE" == result;
  }

  static Future startRecord(String path) async {
    _channel.invokeMethod("startRecord", path);
  }

  static Future startPush() async {
    _channel.invokeMethod("startPush");
  }

  static Future stopPush() async {
    _channel.invokeMethod("stopPush");
  }

  static Future stopRecord() async {
    _channel.invokeMethod("stopRecord");
  }

  static Future<String> get platformVersion async {
    final String version = await _channel2.invokeMethod('getPlatformVersion');
    return version;
  }
}
