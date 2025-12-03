import 'package:sdk/env.dart';
import 'package:sdk/sdk.dart' as sdk;
import 'package:win32_registry/win32_registry.dart';

void main(List<String> arguments) {
  //   var list = EnvManager().list();
  //   list.forEach((key, value) {
  //     print("key: $key, value=$value");
  //   });
  //   print(EnvManager(system: false).get("MAVEN_HOME1"));
  EnvManager(system: false).removeFromPath("D://wakaka");
}
