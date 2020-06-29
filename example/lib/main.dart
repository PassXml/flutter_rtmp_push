import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_rtmp_push_plugin/live_rtmp_push_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('手机推流插件'),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Stack(
              children: <Widget>[
                SizedBox(
                  height: 500,
                  child: Platform.isIOS
                      ? UiKitView(
                          viewType: "com.xinlianshiye.live",
                        )
                      : AndroidView(
                          viewType: "com.xinlianshiye.live",
                          creationParams: <String, String>{
                            "layout": "livemain",
                            "package":
                                "com.xinlianshiye.live.live_rtmp_push_plugin_example",
                          },
                          creationParamsCodec: const StandardMessageCodec(),
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
                    "rtmp://192.168.3.44/live/rfBd56ti2SMtYvSgD5xAV0YU99zampta7Z7S575KLkIZ9PYk");
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
      ),
    );
  }
}
