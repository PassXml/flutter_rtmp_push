import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_rtmp_push_plugin/live_rtmp_push_plugin.dart';

class Page2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Page2();
  }
}

class _Page2 extends State<Page2> {
  final viewId = "com.xinlianshiye.live";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('推流'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                height: 300,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Platform.isIOS
                      ? UiKitView(
                          viewType: viewId,
                          creationParams: {
                            "height": MediaQuery.of(context).size.height,
                            "width": MediaQuery.of(context).size.width
                          },
                          creationParamsCodec: const StandardMessageCodec(),
                        )
                      : AndroidView(
                          viewType: viewId,
                          creationParams: {
                            "height": MediaQuery.of(context).size.height,
                            "width": MediaQuery.of(context).size.width
                          },
                          creationParamsCodec: const StandardMessageCodec(),
                        ),
                ),
              ),
              Positioned(
                child: Text("遮挡物"),
              )
            ],
          ),
          TextField(
            decoration: InputDecoration(labelText: "推流地址"),
            onSubmitted: (str) {
              LiveRtmpPushPlugin.setUrl(
                  "rtmp://192.168.3.92/live/rfBd56ti2SMtYvSgD5xAV0YU99zampta7Z7S575KLkIZ9PYk");
            },
          ),
          FlatButton(
            child: Text("美颜"),
            onPressed: () {
              LiveRtmpPushPlugin.setFilter(20);
            },
          ),
          FlatButton(
            child: Text("关闭美颜"),
            onPressed: () {
              LiveRtmpPushPlugin.setFilter(0);
            },
          ),
          FlatButton(
            child: Text("开始推流"),
            onPressed: () {
              LiveRtmpPushPlugin.startPush();
            },
          ),
          FlatButton(
            child: Text("关闭推流"),
            onPressed: () {
              LiveRtmpPushPlugin.stopPush();
            },
          )
        ],
      ),
    );
  }
}
