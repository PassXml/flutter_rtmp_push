package com.xinlianshiye.live


import android.R
import android.R.attr.orientation
import android.content.Context
import android.content.res.Configuration
import android.opengl.GLSurfaceView
import android.view.OrientationEventListener
import android.view.Surface
import android.view.View
import android.view.WindowManager
import android.widget.RelativeLayout
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
import java.nio.ByteBuffer


class LivePushView(context: Context, private val messenger: BinaryMessenger, args: HashMap<String, String>) : PlatformView, MethodChannel.MethodCallHandler, OrientationEventListener(context) {
    private val layout: RelativeLayout = RelativeLayout(context)
    private val methodChannel: MethodChannel = MethodChannel(messenger, "com/xinlianshiye/live/action")
    private var mGLSurfaceView: GLSurfaceView = GLSurfaceView(context)
    private var mStreamer: KSYStreamer

    //    final rotation:Int = ((WindowManager) context.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay().getRotation()
    val rotation: Int = (context.getSystemService(Context.WINDOW_SERVICE) as WindowManager).defaultDisplay.rotation


    init {
        layout.addView(mGLSurfaceView)
        methodChannel.setMethodCallHandler(this);
        mStreamer = KSYStreamer(context);
        config()
        mStreamer.setDisplayPreview(mGLSurfaceView)
        startCameraPreviewWithPermCheck()
        this.enable()
    }

    //开启预览,注意相关权限必须开启
    fun startCameraPreviewWithPermCheck() {
        mStreamer.startCameraPreview()
    }


    fun sendMessage(msg: String) {
        messenger.send("com/xinlianshiye/live/return", ByteBuffer.wrap(msg.toByteArray()))
    }

    protected fun config() {
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
        // 设置预览View
        // 设置回调处理函数
//        mStreamer.onInfoListener = KSYStreamer.OnInfoListener { i, i2, i3 ->
//            println("回调参数")
//            println(i)
//            println(i2)
//            println(i3)
//
//        }
//        mStreamer.onErrorListener = KSYStreamer.OnErrorListener { iMediaPlayer, i, i1 ->
//            println("发生错误")
//            println(iMediaPlayer)
//            println(i)
//            println(i1)
//            false
//        }

        // 禁用后台推流时重复最后一帧的逻辑（这里我们选择切后台使用背景图推流的方式）
        mStreamer.enableRepeatLastFrame = false


        // 设置美颜滤镜的错误回调，当前机型不支持该滤镜时禁用美颜

        // 设置美颜滤镜，关于美颜滤镜的具体说明请参见专题说明以及完整版demo
//        mStreamer.imgTexFilterMgt.setFilter(mStreamer.glRender,
//                ImgTexFilterMgt.KSY_FILTER_BEAUTY_PRO3)
    }

    override fun getView(): View = layout

    override fun dispose() {
        mStreamer?.release()
        println("销毁了")
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            /**
             * 设置推流地址
             */
            "setUrl" -> {
                if (mStreamer != null) {
                    mStreamer.url = call.arguments.toString()
                    result.success("TRUE");
                } else {
                    result.error("FALSE", "工具类没有初始化", null)
                }
            }
            /**
             * 开始推流
             */
            "startPush" -> {
                mStreamer?.startStream()
            }
            /**
             * 停止推流
             */
            "stopPush" -> {
                mStreamer?.stopStream()
            }
            /**
             * 开始录像
             */
            "startRecord" -> {
                mStreamer?.startRecord(call.arguments.toString())
            }
            /**
             * 停止录像
             */
            "stopRecord" -> {
                mStreamer?.stopRecord()
            }
            /**
             * 设置滤镜
             */
            "setFilter" -> {
                if (call.arguments == null) {
                    mStreamer?.imgTexFilterMgt?.setFilter(
                            mStreamer.glRender, ImgTexFilterMgt.KSY_FILTER_BEAUTY_DISABLE);
                } else {
                    mStreamer?.imgTexFilterMgt?.setFilter(
                            mStreamer.glRender, call.arguments.toString().toInt());
                }
            }
            "setPreviewResolution" -> {
                /**
                 * 设置预览分辨率
                 */
                call.arguments?.toString()?.toInt()?.let { mStreamer?.setPreviewResolution(it) }
            }
            "setTargetResolution" -> {
                /**
                 * 设置推流分辨率
                 */
                call.arguments?.toString()?.toInt()?.let { mStreamer?.setTargetResolution(it) }
            }
            "setCameraFacing" -> {
                /**
                 * 选择前后摄像头
                 */
                when (call.arguments) {
                    0 -> {
                        mStreamer.cameraFacing = 0
                    }
                    1 -> {
                        mStreamer.cameraFacing = 1
                    }
                }

            }
            /** 设置方向 */
            "setRotateDegrees" -> {
                when (call.arguments) {
                    0 -> {
                        mStreamer.rotateDegrees = 0
                    }
                    1 -> {
                        mStreamer.rotateDegrees = 90
                    }
                    2 -> {
                        mStreamer.rotateDegrees = 180
                    }
                    3 -> {
                        mStreamer.rotateDegrees = 270
                    }
                    4 -> {
                        mStreamer.rotateDegrees = 360
                    }
                }
            }
            "setSyncOrientation" -> {
                when (call.arguments) {
                    true ->
                        this.enable()
                    false ->
                        this.disable()
                }
            }
            else -> {
                println(call.method)
                println(call.arguments)
                result.success("OK")
            }
        }
    }

    override fun onOrientationChanged(orientation: Int) {
        if (orientation > 350 || orientation < 10) { //0度
            mStreamer.rotateDegrees = 0
        } else if (orientation in 81..99) { //90度
            mStreamer.rotateDegrees = 270

        } else if (orientation in 171..189) { //180度
            mStreamer.rotateDegrees = 180

        } else if (orientation in 261..279) { //270度
            mStreamer.rotateDegrees = 90
        } else {
            return;
        }
    }
}

