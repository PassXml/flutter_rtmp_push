package com.xinlianshiye.live


import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.opengl.GLSurfaceView
import android.os.Build
import android.view.View
import android.widget.Toast
import androidx.core.app.ActivityCompat
import com.ksyun.media.streamer.encoder.VideoEncodeFormat
import com.ksyun.media.streamer.filter.imgtex.ImgTexFilterMgt
import com.ksyun.media.streamer.framework.AVConst
import com.ksyun.media.streamer.kit.KSYStreamer
import com.ksyun.media.streamer.kit.StreamerConstants
import com.ksyun.media.streamer.publisher.RtmpPublisher
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


class LivePushView(context: Context, messenger: BinaryMessenger, args: HashMap<String, String>) : PlatformView, MethodChannel.MethodCallHandler {
    private val layoutRes = context.resources.getIdentifier(args["layout"], "layout", args["package"])
    private val frameLayout: View = View.inflate(context, layoutRes, null) as View
    private val methodChannel: MethodChannel = MethodChannel(messenger, "com/xinlianshiye/live/action")
    private var mGLSurfaceView: GLSurfaceView = frameLayout.findViewById(context.resources.getIdentifier("gl_surface_view", "id", args["package"]))
    private var mStreamer: KSYStreamer


    init {
        methodChannel.setMethodCallHandler(this);
        mStreamer = KSYStreamer(context);
        config()
        mStreamer.setDisplayPreview(mGLSurfaceView)
        startCameraPreviewWithPermCheck()
    }

    //开启预览,注意相关权限必须开启
    fun startCameraPreviewWithPermCheck() {
        mStreamer.startCameraPreview()
    }

    protected fun config() {
        // 设置推流URL地址
//        if (!TextUtils.isEmpty(mConfig.mUrl)) {
//            mUrlTextView.setText(mConfig.mUrl)
        mStreamer.url = "http://devinfo.ks-live.com:8420/info?model=Android%20SDK%20built%20for%20x86&osver=8.0.0"
//        }

        // 设置推流分辨率
        mStreamer.setPreviewResolution(StreamerConstants.VIDEO_RESOLUTION_720P)
        mStreamer.setTargetResolution(StreamerConstants.VIDEO_RESOLUTION_720P)

        // 设置编码方式（硬编、软编）
        mStreamer.setEncodeMethod(StreamerConstants.ENCODE_METHOD_HARDWARE)
        // 硬编模式下默认使用高性能模式(high profile)
        mStreamer.videoEncodeProfile = VideoEncodeFormat.ENCODE_PROFILE_HIGH_PERFORMANCE
        mStreamer.bwEstStrategy = RtmpPublisher.BW_EST_STRATEGY_NORMAL

        // 设置推流帧率
//        if (mConfig.mFrameRate > 0) {
//            mStreamer.previewFps = mConfig.mFrameRate
//            mStreamer.targetFps = mConfig.mFrameRate
//        }

        // 设置推流视频码率，三个参数分别为初始码率、最高码率、最低码率
//        val videoBitrate: Int = mConfig.mVideoKBitrate
//        if (videoBitrate > 0) {
//            mStreamer.setVideoKBitrate(videoBitrate * 3 / 4, videoBitrate, videoBitrate / 4)
//        }

        // 设置音频码率
//        if (mConfig.mAudioKBitrate > 0) {
        mStreamer.setAudioKBitrate(AVConst.PROFILE_AAC_HE)
//        }

        // 设置视频方向（横屏、竖屏）
//        if (mConfig.mOrientation == ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE) {
//            mIsLandscape = true
//            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE)
//            mStreamer.rotateDegrees = 90
//        } else if (mConfig.mOrientation == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT) {
//            mIsLandscape = false
//            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)
        mStreamer.rotateDegrees = 0
//        }

        // 选择前后摄像头
//        mStreamer.cameraFacing = mConfig.mCameraFacing

        // 设置预览View
        // 设置回调处理函数
        mStreamer.onInfoListener = KSYStreamer.OnInfoListener { i, i2, i3 ->

            println(i)
            println(i2)
            println(i3)

        }
        mStreamer.onErrorListener = KSYStreamer.OnErrorListener { iMediaPlayer, i, i1 ->
            println("发生错误")
            println(iMediaPlayer)
            println(i)
            println(i1)
            false
        }

        // 禁用后台推流时重复最后一帧的逻辑（这里我们选择切后台使用背景图推流的方式）
        mStreamer.enableRepeatLastFrame = false


        // 设置美颜滤镜的错误回调，当前机型不支持该滤镜时禁用美颜

        // 设置美颜滤镜，关于美颜滤镜的具体说明请参见专题说明以及完整版demo
//        mStreamer.imgTexFilterMgt.setFilter(mStreamer.glRender,
//                ImgTexFilterMgt.KSY_FILTER_BEAUTY_PRO3)
        mStreamer.imgTexFilterMgt.setFilter(
                mStreamer.glRender, ImgTexFilterMgt.KSY_FILTER_BEAUTY_SMOOTH);

    }

    override fun getView(): View = frameLayout

    override fun dispose() {
        TODO("Not yet implemented")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            else -> {
                println(call.method)
                println(call.arguments)
                result.success("OK")
            }
        }
    }
}

