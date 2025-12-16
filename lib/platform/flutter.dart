import 'package:sdk/platform.dart';

class FlutterSdkPlatform extends SdkPlatform {
  @override
  String get name => 'Flutter SDK';

  @override
  String get id => 'flutter';

  @override
  String get envName => 'FLUTTER_HOME';

  @override
  String get configJson => '''
  {
  "name": "Flutter SDK",
  "versions": {
    "3.38.5": {
      "urls": [
        "https://storage.flutter-io.cn/flutter_infra_release/releases/stable/windows/flutter_windows_3.38.5-stable.zip"
      ]
    },
    "3.35.7": {
      "urls": [
        "https://storage.flutter-io.cn/flutter_infra_release/releases/stable/windows/flutter_windows_3.35.7-stable.zip"
      ]
    },
    "3.27.2": {
      "urls": [
        "https://storage.flutter-io.cn/flutter_infra_release/releases/stable/windows/flutter_windows_3.27.2-stable.zip"
      ]
    }
  }
}
  ''';
}
