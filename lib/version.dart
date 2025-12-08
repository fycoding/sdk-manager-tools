import 'dart:io';

import 'package:cli_table/cli_table.dart';
import 'package:sdk/platform.dart';
import 'package:path/path.dart' as path;
import 'package:sdk/utils.dart';

class Version {
  // 平台
  SdkPlatform platform;
  // 当前版本
  String? _currentVersion;
  // 软连接目录名
  final String _linkName = "current";
  // 版本信息
  late Map<String, dynamic> versions;
  // sdk路径
  late String sdkPath;
  // 链接
  late String linkPath;

  Version(this.platform) {
    versions = platform.config['versions'];
    sdkPath = path.join(Directory.current.path, platform.id);
    linkPath = path.join(sdkPath, _linkName);
    _currentVersion = _getCurrentVersion();
  }

  /// 切换版本
  Future<bool> switchVersion(String v) async {
    print(sdkPath);
    print(linkPath);
    print(_currentVersion);
    // 版本相同，直接返回
    if (_currentVersion != null && _currentVersion == v) {
      return true;
    }
    // 找到对应版本下载地址
    // 下载
    // 创建链接
    if (_currentVersion == null) {
      // 第一次
    }
    return false;
  }

  /// 打印版本信息
  void printVersionByTable() {
    final table = Table(header: ['版本', '下载地址']);
    versions.forEach((version, versionConfig) {
      final urls = versionConfig['urls'] as List<dynamic>;
      if (urls.isNotEmpty) {
        final urlList = urls.map((url) => url.toString()).toList();
        table.add([version, urlList.join('\n')]);
      }
    });
    print(table.toString());
  }

  // 获取当前version
  String? _getCurrentVersion() {
    String? path = getLinkTarget(linkPath);
    if (path != null) {
      return path.split(r'\').last;
    }
    return null;
  }
}
