import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'live_rtmp_push_plugin.dart';

class PushView extends StatefulWidget {
  final double height;
  final double width;
  LiveRtmpPushPlugin controller;

  PushView(this.height, this.width) {}

  @override
  State<StatefulWidget> createState() {
    return _PushView();
  }
}

class _PushView extends State<PushView> {
  final viewId = "com.xinlianshiye.live";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Platform.isIOS
          ? UiKitView(
              viewType: viewId,
              creationParams: <String, String>{
                "height": widget.height.toString(),
                "width": widget.width.toString(),
              },
              creationParamsCodec: const StandardMessageCodec(),
            )
          : AndroidView(
              viewType: viewId,
              creationParams: <String, String>{},
              creationParamsCodec: const StandardMessageCodec(),
            ),
    );
  }
}
