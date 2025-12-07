import 'dart:convert';
import 'dart:io';

import 'package:sdk/platform.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

class JavaSdkPlatform extends SdkPlatform {
  Map<String, dynamic> _config = {};
  late final ArgParser _parser;

  JavaSdkPlatform() {
    _loadConfigSync(); // 构造函数中同步加载
    _parser = ArgParser()
      ..addFlag('help', abbr: 'h', help: '显示帮助信息', negatable: false)
      ..addFlag('version', abbr: 'v', help: '显示版本信息', negatable: false)
      ..addOption(
        'use',
        abbr: 'u',
        help: '切换到指定版本',
        valueHelp: 'version',
        callback: (String? version) {
          if (version != null) {
            useVersion(version);
          }
        },
      )
      ..addFlag('current', abbr: 'c', help: '显示当前版本', negatable: false)
      ..addFlag('list', abbr: 'l', help: '列出可用版本', negatable: false);
  }

  // 基础信息
  @override
  String get name => 'Java SDK';

  @override
  String get id => 'java';

  @override
  String get envName => 'JAVA_HOME';

  @override
  dynamic get commandParser => _parser;

  @override
  Future<String?> getCurrentVersion() async {
    print('JavaSdkPlatform.getCurrentVersion()');
    return null;
  }

  @override
  Future<void> useVersion(String version) async {
    print('JavaSdkPlatform.useVersion($version)');
  }

  @override
  Map<String, dynamic> get config => _config;

  // 命令执行
  @override
  Future<void> runCommand(List<String> args) async {
    try {
      final results = _parser.parse(args);

      if (results['help'] == true || args.isEmpty) {
        _printHelp();
        return;
      }

      if (results['version'] == true) {
        print('Java SDK Manager v1.0.0');
        return;
      }

      // 处理各个命令
      if (results['list'] == true) {
        versionsTable();
        return;
      }

      if (results['current'] == true) {
        final version = await getCurrentVersion();
        print('当前Java版本: ${version ?? "未设置"}');
        return;
      }

      if (results['use'] != null) {
        final version = results['use'] as String;
        await useVersion(version);
        return;
      }

      print('错误: 需要指定命令参数\n');
      _printHelp();
    } catch (e) {
      print('错误: $e\n');
      _printHelp();
    }
  }

  void _loadConfigSync() {
    final configFile = File(path.join('lib', 'platform', '$id.json'));
    if (!configFile.existsSync()) {
      print("$id平台配置文件不存在");
    }
    final content = configFile.readAsStringSync();
    _config = json.decode(content);
  }

  void _printHelp() {
    print('Java SDK 管理工具\n');
    print(_parser.usage);
    print('''
使用示例:
  sdk java --list                列出可用Java版本
  sdk java --current             显示当前Java版本  
  sdk java --use 17              切换到Java 17
  sdk java --use=17              同上
  sdk java -u 17                 同上（简写）
''');
  }
}
