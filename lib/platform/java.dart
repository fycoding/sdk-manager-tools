import 'package:sdk/platform.dart';

class JavaSdkPlatform extends SdkPlatform {
  @override
  String get name => 'Java SDK';

  @override
  String get id => 'java';

  @override
  String get envName => 'JAVA_HOME';
}
