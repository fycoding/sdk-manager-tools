import 'package:sdk/platform.dart';

class AndroidSdkPlatform extends SdkPlatform {
  @override
  String get name => 'Android SDK';

  @override
  String get id => 'android';

  @override
  String get envName => 'ANDROID_HOME';

  @override
  String get configJson => '''
  {
  "name": "Android SDK",
  "versions": {
    "latest": {
      "urls": [
        "https://dl.google.com/android/repository/commandlinetools-win-13114758_latest.zip?hl=zh-cn"
      ]
    }
  }
}
  ''';
}
