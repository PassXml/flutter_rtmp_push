//
// Created by Passxml on 2020/6/23.
//

import Foundation
import libksygpulive
import Flutter

public class LivePushView: NSObject, FlutterPlatformView {
    var kit: KSYGPUStreamerKit?
    fileprivate var viewId: Int64!;
    fileprivate var channel: FlutterMethodChannel!
    fileprivate var frame: CGRect;
    var layoutName: String?;
    var _currentPinchZoomFactor: CGFloat?     //当前触摸缩放因子
    var _view: UIView;

    func initKit() {
        if kit == nil {
            kit = KSYGPUStreamerKit.init(defaultCfg: ())
        }
        print("版本号:\(String(describing: kit?.getKSYVersion()))")
        if kit != nil {
            addPinchGestureRecognizer()
            kit?.streamerProfile = KSYStreamerProfile(rawValue: 200)!
            kit?.cameraPosition = AVCaptureDevice.Position.front
            kit?.videoOrientation = UIApplication.shared.statusBarOrientation
            kit?.previewDimension = CGSize.init(width: 1080, height: 1920)
            kit?.streamDimension = CGSize.init(width: 720, height: 1280)
            kit?.startPreview(view())
        }
    }

    public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Dictionary<String, String>, binaryMessenger: FlutterBinaryMessenger) {
        self.frame = frame
        self.viewId = viewId
        self.layoutName = args["layout"]
        self.channel = FlutterMethodChannel(name: "com/xinlianshiye/live/action", binaryMessenger: binaryMessenger)
        //
        self._view = UIView(frame: CGRect(x: 0, y: 0, width: (Int.init(args["width"] ?? "200") ?? 200  ), height: (Int.init(args["height"] ?? "200" ) ?? 200)));
        self._view.backgroundColor = UIColor.cyan
        super.init()

        self.channel.setMethodCallHandler({
            [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if let this = self {
                this.onMethodCall(call: call, result: result)
            }
        })
        self.initKit()

    }

    public func view() -> UIView {
        return self._view
    }

    //添加缩放手势，缩放时镜头放大或缩小
    func addPinchGestureRecognizer() {
        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchDetected(rec:)))
        self._view.addGestureRecognizer(pinch)
    }

    @objc func pinchDetected(rec: UIPinchGestureRecognizer) {
        if rec.state == .began {
            _currentPinchZoomFactor = kit?.pinchZoomFactor
        }
        let zoomFactor = _currentPinchZoomFactor! * rec.scale    //当前触摸缩放因子*坐标比例
        kit?.pinchZoomFactor = zoomFactor
    }


    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        switch method {
        case "setUrl":
            if kit == nil {
                result("FALSE")
            } else {
                kit?.streamerBase?.startStream(NSURL.init(string: call.arguments as! String)! as URL)
                result("TRUE")
            }
        case "startPush":
            kit?.streamerBase.stopStream()
        case "stopPush":
            kit?.streamerBase.stopStream()
        case "startRecord":
            kit?.streamerBase.startBypassRecord(NSURL.init(string: call.arguments as! String)! as URL)
        case "stopRecord":
            kit?.streamerBase.stopBypassRecord()
        case "setFilter":
            if call.arguments == nil {
                kit?.setupFilter(nil)
            } else {
                kit?.setupFilter(KSYGPUBeautifyExtFilter()!)
            }
        default:
            result("OK")
            print(call.method)
            print(call.arguments ?? "No Value")
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
