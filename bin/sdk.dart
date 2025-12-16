#!/usr/bin/env dart

import 'package:sdk/platform.dart';
import 'package:sdk/platform/android.dart';
import 'package:sdk/platform/dart.dart';
import 'package:sdk/platform/flutter.dart';
import 'package:sdk/platform/java.dart';
import 'package:args/args.dart';

void main(List<String> arguments) async {
  final platforms = <String, SdkPlatform>{
    'android': AndroidSdkPlatform(),
    'dart': DartSdkPlatform(),
    'flutter': FlutterSdkPlatform(),
    'java': JavaSdkPlatform(),
  };

  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', help: '显示帮助信息', negatable: false)
    ..addFlag('version', abbr: 'v', help: '显示版本信息', negatable: false);

  // 为每个平台添加子命令
  for (final entry in platforms.entries) {
    parser.addCommand(
      entry.key,
      entry.value.commandParser as ArgParser? ?? ArgParser(),
    );
  }

  try {
    final results = parser.parse(arguments);
    // 子命令
    final command = results.command;

    if (results['version'] == true) {
      print('SDK Manager v1.0.0');
      return;
    }

    // 放在其他命令的后边
    if (results['help'] == true || command == null) {
      print("示例：sdk java use <version>\n");
      print("当前支持的平台:${platforms.keys.toList()}");
      print(parser.usage);
      return;
    }

    // 处理平台子命令
    final platformId = command.name;
    final platform = platforms[platformId];
    if (platform != null) {
      // 移除平台名，传递剩余参数
      final platformArgs = command.arguments;
      await platform.runCommand(platformArgs);
      return;
    }

    // 如果没有匹配的命令，显示帮助
    print('错误: 需要指定平台和命令\n');
    print(parser.usage);
  } catch (e) {
    print('错误: $e\n');
    print(parser.usage);
  }

  void _printHelp() {
    print("示例：sdk java use 8");
    print(parser.usage);
  }
}
