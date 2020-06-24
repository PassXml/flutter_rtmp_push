import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_rtmp_push_plugin/live_rtmp_push_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('live_rtmp_push_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await LiveRtmpPushPlugin.platformVersion, '42');
  });
}
