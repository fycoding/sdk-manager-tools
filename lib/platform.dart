import 'package:cli_table/cli_table.dart';

abstract class SdkPlatform {
  // 基础信息
  String get name; // 显示名称，如 "Java SDK"
  String get id; // 平台标识，如 "java"
  String get envName; // 环境变量名，如 "JAVA_HOME"

  // 配置相关
  Map<String, dynamic> get config;

  // 三个核心功能接口
  Future<String?> getCurrentVersion(); // current命令
  Future<void> useVersion(String version); // use命令

  // 命令执行（使用第三方库解析命令行）
  Future<void> runCommand(List<String> args);

  // 获取命令解析器
  dynamic get commandParser;

  void versionsTable() {
    var versions = config['versions'];
    final table = Table(header: ['版本', '下载地址（多个源）']);

    versions.forEach((version, versionConfig) {
      final urls = versionConfig['urls'] as List<dynamic>?;

      if (urls != null && urls.isNotEmpty) {
        // 将所有下载地址合并为字符串，用换行分隔
        final urlList = urls.map((url) => url.toString()).toList();
        table.add([version, urlList.join('\n')]);
      }
    });
    print(table.toString());
  }

  List<String> getVersions() {
    return config['versions'].keys.toList();
  }
}
