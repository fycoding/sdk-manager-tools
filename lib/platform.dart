import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:sdk/version.dart';

abstract class SdkPlatform {
  // 基础信息 - 抽象属性，子类必须实现
  String get name;
  String get id;
  String get envName;
  String get configJson;

  // sdk目录
  late final String sdkPath;

  // 配置
  Map<String, dynamic> get config => _config;
  Map<String, dynamic> _config = {};

  // 命令解析器
  ArgParser get commandParser => _parser;
  late final ArgParser _parser;

  // 构造函数
  SdkPlatform() {
    _loadConfigSync();
    _parser = _createCommandParser();
    sdkPath = _getSdkPath();
  }

  // 核心功能
  void listVersions() {
    Version v = Version(this);
    v.printVersionByTable();
  }

  List<String> getVersions() {
    final versions = config['versions'] as Map<String, dynamic>?;
    return versions?.keys.toList() ?? [];
  }

  Future<String?> getCurrentVersion() async {
    Version v = Version(this);
    return v.getCurrentVersion();
  }

  Future<void> useVersion(String version) async {
    Version v = Version(this);
    v.switchVersion(version);
    print("切换版本$version");
  }

  Future<void> runCommand(List<String> args) async {
    try {
      final results = commandParser.parse(args);

      if (results['help'] == true || args.isEmpty) {
        _printHelp();
        return;
      }

      if (results['version'] == true) {
        print('$name Manager v1.0.0');
        return;
      }

      if (results['list'] == true) {
        listVersions();
        return;
      }

      if (results['current'] == true) {
        final version = await getCurrentVersion();
        print('当前$name版本: ${version ?? "未设置"}');
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

  List<String> getDownloadUrls(String version) {
    final versionConfig = config['versions']?[version];
    if (versionConfig != null && versionConfig['urls'] is List) {
      return List<String>.from(versionConfig['urls']);
    }
    return [];
  }

  // 配置和解析器

  ArgParser _createCommandParser() {
    return ArgParser()
      ..addFlag('help', abbr: 'h', help: '显示帮助信息', negatable: false)
      ..addFlag('version', abbr: 'v', help: '显示版本信息', negatable: false)
      ..addOption('use', abbr: 'u', help: '切换到指定版本', valueHelp: 'version')
      ..addFlag('current', abbr: 'c', help: '显示当前版本', negatable: false)
      ..addFlag('list', abbr: 'l', help: '列出可用版本', negatable: false);
  }

  void _loadConfigSync() {
    _config = json.decode(configJson);
  }

  String _getSdkPath() {
    final currentDirectory = Directory.current;
    return "$currentDirectory/$id";
  }

  // 私有方法
  void _printHelp() {
    print('$name 管理工具\n');
    print(commandParser.usage);
    print('''
使用示例:
  sdk $id --list                列出可用版本
  sdk $id --current             显示当前版本  
  sdk $id --use <版本>          切换到指定版本
  sdk $id --use=<版本>          同上
  sdk $id -u <版本>             同上（简写）

默认版本: ${config['default_version'] ?? '无'}
''');
  }
}
