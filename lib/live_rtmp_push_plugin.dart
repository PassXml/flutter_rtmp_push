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

  static Future setFilter(int id) async {
    _channel.invokeMethod("setFilter", id);
  }

  static Future setPreviewResolution(Resolution label) async {
    _channel.invokeMethod("setPreviewResolution", ResolutionValue[label]);
  }

  static Future setTargetResolution(Resolution label) async {
    _channel.invokeMethod("setTargetResolution", ResolutionValue[label]);
  }

  static Future setRotateDegrees(RotateDegrees label) async {
    _channel.invokeMethod("setRotateDegrees", RotateDegreesValue[label]);
  }

  static Future setSyncOrientation() async {
    _channel.invokeMethod("setSyncOrientation");
  }

  static Future<String> get platformVersion async {
    final String version = await _channel2.invokeMethod('getPlatformVersion');
    return version;
  }
}

enum Resolution { P360, P480, P540, P720, P1080 }

const ResolutionValue = {
  Resolution.P360: 0,
  Resolution.P480: 1,
  Resolution.P540: 2,
  Resolution.P720: 3,
  Resolution.P1080: 4,
};
enum RotateDegrees {
  portrait,
  landscapeLeft,
  portraitUpsideDown,
  landscapeRight,
  unknown
}

const RotateDegreesValue = {
  RotateDegrees.portrait: 0,
  RotateDegrees.landscapeLeft: 1,
  RotateDegrees.portraitUpsideDown: 2,
  RotateDegrees.landscapeRight: 3,
  RotateDegrees.unknown: 4,
};
