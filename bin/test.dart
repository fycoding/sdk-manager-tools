import 'package:sdk/env.dart';
import 'package:sdk/utils.dart';

void main(List<String> args) async {
  // createSymbolicLink(
  //   targetPath: r"D:\sdk\test\java",
  //   linkPath: r"D:\sdk\test\javalink",
  // );

  // print(await getLinkTarget(r"D:\sdk\test\javalink"));
  // deleteLink(r"D:\sdk\test\javalink");
  // print(EnvManager(system: true).get("Path"));
  // print(EnvManager(system: true).addToPath("%NVM_HOME%/aaa"));
  EnvManager(system: true).set("aaa", "wakaka");
}
