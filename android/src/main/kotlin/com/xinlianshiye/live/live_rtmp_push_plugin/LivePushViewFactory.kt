package com.xinlianshiye.live

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class LivePushViewFactory : PlatformViewFactory {
    var messenger: BinaryMessenger;

    constructor(messenger: BinaryMessenger) : super(StandardMessageCodec.INSTANCE) {
        this.messenger = messenger
    }

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        return LivePushView(context!!, messenger, args as HashMap<String, String>);
    }
}