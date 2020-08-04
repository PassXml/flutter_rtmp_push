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
    var curFilter: KSYGPUFilter?;

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
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        if (args["width"]! = null) {
            width = Int.init(args["width"])
        }
        if (args["height"]! = null) {
            width = Int.init(args["height"])
        }
        self._view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height));
        super.init()

        self.channel.setMethodCallHandler({
            [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if let this = self {
                this.onMethodCall(call: call, result: result)
            }
        })
        self.initKit()
        self.addOrientationDidChangeNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        case "setTargetResolution":
            switch (call.arguments as! Int) {
            case 0:
                kit?.streamDimension = CGSize(width: 360, height: 640)
                break
            case 1:
                kit?.streamDimension = CGSize(width: 480, height: 640)
                break
            case 2:
                kit?.streamDimension = CGSize(width: 540, height: 960)
                break
            case 4:
                kit?.streamDimension = CGSize(width: 1080, height: 1920)
                break
            default:
                kit?.streamDimension = CGSize(width: 720, height: 1280)
                break
            }
        case "setPreviewResolution":
            switch (call.arguments as! Int) {
            case 0:
                kit?.streamDimension = CGSize(width: 360, height: 640)
                break
            case 1:
                kit?.streamDimension = CGSize(width: 480, height: 640)
                break
            case 2:
                kit?.streamDimension = CGSize(width: 540, height: 960)
                break
            case 4:
                kit?.streamDimension = CGSize(width: 1080, height: 1920)
                break
            case 3:
                kit?.streamDimension = CGSize(width: 720, height: 1280)
                break
            default:
                break
            }
        case "setFilter":
            if call.arguments == nil {
                curFilter = nil
                kit?.setupFilter(nil)
            } else {
                curFilter = KSYGPUBeautifyExtFilter()
                kit?.setupFilter(curFilter)
            }
        case "setCameraFacing":
            switch (call.arguments as! Int) {
            case 0:kit?.cameraPosition = AVCaptureDevice.Position.back
                break
            default:
                kit?.cameraPosition = AVCaptureDevice.Position.front
                break
            }
        case "setRotateDegrees":
            switch (call.arguments as! Int) {
            case 1:
                setRotate(value: UIInterfaceOrientation.landscapeLeft)
                break
            case 2:
                setRotate(value: UIInterfaceOrientation.portraitUpsideDown)
                break
            case 3:
                setRotate(value: UIInterfaceOrientation.landscapeRight)
                break
            case 4:
                setRotate(value: UIInterfaceOrientation.unknown)
                break
            default:
                setRotate(value: UIInterfaceOrientation.portrait)
                break
            }
        case "setSyncOrientation":
            switch (call.arguments as! Bool) {
            case true:
                addOrientationDidChangeNotification()
                break
            default:
                NotificationCenter.default.removeObserver(self)
                break
            }
        case "pause":
            mStreamer?.stopCameraPreview()
            mStreamer?.setUseDummyAudioCapture(true)
            break
        case "resume":
            mStreamer?.startCameraPreview()
            mStreamer?.setUseDummyAudioCapture(false);
            break
        default:
            result("OK")
            print(call.method)
            print(call.arguments ?? "No Value")
        }
    }

    func setRotate(value: UIInterfaceOrientation) {
        kit?.rotatePreview(to: value)
        kit?.rotateStream(to: value)
    }

    func addOrientationDidChangeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.willOritate(noti:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc func willOritate(noti: NSNotification) {
        switch (UIDevice.current.orientation.rawValue) {
        case 2:
            setRotate(value: UIInterfaceOrientation.portraitUpsideDown)
            break
        case 3:
            setRotate(value: UIInterfaceOrientation.landscapeRight)
            break
        case 4:
            setRotate(value: UIInterfaceOrientation.landscapeLeft)
            break
        default:
            setRotate(value: UIInterfaceOrientation.portrait)
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
