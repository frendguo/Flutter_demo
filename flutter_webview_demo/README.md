# flutter_webview_demo

一个简单的 WebView Demo

# 从头开始

- 引用 WebView 的包：在 `pubspec.yaml` 中的 `dependencies` 中添加 `webview_flutter: ^0.1.1`
- 【可选】使用 `flutter pub get` 命令安装包
- 在 dart 文件中导入 WebView 的包 `import 'package:webview_flutter/webview_flutter.dart';`
- 然后就可以写代码了，具体参看：`main.dart`
- 要想在 iOS 中运行，需要在 `./ios/Runner/Info.plist` 中添加：
    ```
    <!--fultter 提供-->
    <key>io.flutter.embedded_views_preview</key><string>yes</string>

    <!--配置http连接策略的-->
    <key>NSAppTransportSecurity</key>
    <dict>
        <!--允许关闭app传输安全限制-->
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <!--允许应用关闭从webview的传输安全限制-->
        <key>NSAllowsArbitraryLoadsInWebContent</key>
        <true/>
    </dict>
    ```
  
 - 然后就可以在 iOS 的模拟器中运行了
 
 - 如果你想在真机上运行，还需要在 Xcode 中生成证书：
    1. 在 Android Studio 中，选择 `ios` 文件夹，右击，选择 `Flutter -> Open iOS module in Xcode`
    2. 在 XCode 中选择最上层的 `Runner` 单击，右侧菜单选择 `TARGETS -> Runner -> Signing & Capabilities`
    3. 然后在 Team 中选择对应的开发者账号（如果你登录了的话，如果没有登录，请先登录。如果需要通过 App Store 来进行分发，则需要有开发者账号，否则普通 AppleID 即可）
 
