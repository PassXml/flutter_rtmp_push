import 'dart:async';

import 'package:flutter/services.dart';

class LiveRtmpPushPlugin {
  static const MethodChannel _channel =
      const MethodChannel('live_rtmp_push_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
