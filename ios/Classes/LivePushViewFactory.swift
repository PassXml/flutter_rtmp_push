//
// Created by Passxml on 2020/6/22.
//

import Foundation
import Flutter

public class LivePushViewFactory: NSObject, FlutterPlatformViewFactory {
    var messenger: FlutterBinaryMessenger!

    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        var argsTemp = Dictionary<String, String>()
        if args != nil {
            argsTemp = args as! Dictionary<String, String>
        }
        return LivePushView(withFrame: frame, viewIdentifier: 10, arguments: argsTemp, binaryMessenger: messenger)
    }

    @objc public init(messenger: (NSObject & FlutterBinaryMessenger)?) {
        super.init()
        self.messenger = messenger
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }


}
