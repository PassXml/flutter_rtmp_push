import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PushView extends StatefulWidget {
  final double height;
  final double width;
  Map<String, String> params;

  PushView(this.height, this.width, {HashMap<String, String> params}) {
    this.params = params;
  }

  @override
  State<StatefulWidget> createState() {
    return _PushView();
  }
}

class _PushView extends State<PushView> {
  final viewId = "com.xinlianshiye.live";

  setDefault(Map<String, String> params, String key, defaultValue) {
    if (params[key] == null) {
      params[key] = defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.params == null) {
      widget.params = <String, String>{
        "height": widget.height.toString(),
        "width": widget.width.toString(),
      };
    } else {
      setDefault(widget.params, "height", widget.height);
      setDefault(widget.params, "width", widget.width);
    }
    return OrientationBuilder(
      builder: (context, orientation) {
        return Container(
          width: widget.width,
          height: widget.height,
          child: Platform.isIOS
              ? UiKitView(
                  viewType: viewId,
                  creationParams: widget.params,
                  creationParamsCodec: const StandardMessageCodec(),
                )
              : AndroidView(
                  viewType: viewId,
                  creationParams: widget.params,
                  creationParamsCodec: const StandardMessageCodec(),
                ),
        );
      },
    );
  }
}
