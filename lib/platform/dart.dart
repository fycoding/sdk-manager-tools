import 'package:sdk/platform.dart';

class DartSdkPlatform extends SdkPlatform {
  @override
  String get name => 'Dart SDK';

  @override
  String get id => 'dart';

  @override
  String get envName => 'DART_HOME';

  @override
  String get configJson => '''
  {
  "name": "Dart SDK",
  "versions": {
    "3.10.4": {
      "urls": [
        "https://storage.flutter-io.cn/dart-archive/channels/stable/release/3.10.4/sdk/dartsdk-windows-x64-release.zip"
      ]
    },
    "3.9.4": {
      "urls": [
        "https://storage.flutter-io.cn/dart-archive/channels/stable/release/3.9.4/sdk/dartsdk-windows-x64-release.zip"
      ]
    },
    "3.8.3": {
      "urls": [
        "https://storage.flutter-io.cn/dart-archive/channels/stable/release/3.8.3/sdk/dartsdk-windows-x64-release.zip"
      ]
    }
  }
}
  ''';
}
