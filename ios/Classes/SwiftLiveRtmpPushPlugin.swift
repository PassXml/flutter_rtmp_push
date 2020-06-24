import Flutter
import UIKit

public class SwiftLiveRtmpPushPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "live_rtmp_push_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftLiveRtmpPushPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
