//
// Created by Passxml on 2020/6/23.
//

import Foundation
import libksygpulive

public class LivePushView: NSObject, FlutterPlatformView {
    var kit: KSYGPUStreamerKit?
    fileprivate var viewId: Int64!;
    fileprivate var channel: FlutterMethodChannel!
    fileprivate var frame: CGRect;

    public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger: FlutterBinaryMessenger) {
        self.frame = frame
        self.viewId = viewId
        self.channel = FlutterMethodChannel(name: "com/xinlianshiye/live/action", binaryMessenger: binaryMessenger)
        super.init()

        //
        self.channel.setMethodCallHandler({
            [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if let this = self {
                this.onMethodCall(call: call, result: result)
            }
        })
        //工具类初始化
        if kit == nil {
            kit = KSYGPUStreamerKit.init(defaultCfg: ())
        }
        print("版本号:\(kit?.getKSYVersion)")
        if kit != nil {
            kit?.streamerProfile = KSYStreamerProfile(rawValue: 200)!
            kit?.cameraPosition = AVCaptureDevice.Position.front
            kit?.videoOrientation = UIApplication.shared.statusBarOrientation
            let filter = KSYBeautifyFaceFilter()
            kit?.setupFilter(filter as! GPUImageOutput & GPUImageInput)
            kit?.previewDimension = CGSize.init(width: 1080, height: 1920)
            kit?.streamDimension = CGSize.init(width: 720, height: 1280)
            kit?.startPreview(view())
        }
    }

    public func view() -> UIView {
        let uiView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(400), height: CGFloat(600)))
        uiView.layoutMargins = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(0), right: CGFloat(0))
        let nibObjects = Bundle.main.loadNibNamed("Test", owner: nil, options: nil)
        let view2 = nibObjects!.first as! UIView
        uiView.addSubview(view2)
        return uiView
    }

    func onMethodCall(call: FlutterMethodCall, result: @escaping FluterResult) {
        let method = call.method
        switch method {
        case "setUrl":
            if kit == nil {
                result("FALSE")
            } else {
                kit?.streamerBase?.startStream(NSURL.init(string: call.arguments as! String) as! URL)
                result("TRUE")
            }
        case "startPush":
            kit?.streamerBase.stopStream()
        case "stopPush":
            kit?.streamerBase.stopStream()
        case "startRecord":
            kit?.streamerBase.startBypassRecord(NSURL.init(string: call.arguments as! String) as! URL)
        case "stopRecord":
            kit?.streamerBase.stopBypassRecord()
        default:
            print("未实现")
            print(call.method)
            print(call.arguments)
        }
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat) {
        let v = hex.map {
            String($0)
        } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}