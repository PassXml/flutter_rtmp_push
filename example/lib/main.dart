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
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
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
            Text("Hello")
          ],
        ),
      ),
    );
  }
}
