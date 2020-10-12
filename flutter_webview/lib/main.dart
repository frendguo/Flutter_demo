import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebViewDemo(),
    );
  }
}

class WebViewDemo extends StatefulWidget {
  @override
  _WebViewDemoState createState() => _WebViewDemoState();
}

class _WebViewDemoState extends State<WebViewDemo> {
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return InAppWebView(
          // initialFile: "assets/index.html",
          initialUrl: "http://0.0.0.0:1234/",
          // initialUrl: "http://enow.test.seewo.com/view?version=1&from=remote#/enbx/6e1bcce8-de99-4563-bee1-a8b8a3c87ba8",
          initialHeaders: {},
          onWebViewCreated: (InAppWebViewController controller) {
            webView = controller;
          },
        );
      },),
    );
  }
}
