import 'dart:io';

import 'package:cli_table/cli_table.dart';
import 'package:sdk/download.dart';
import 'package:sdk/env.dart';
import 'package:sdk/extract.dart';
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
  // link
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
    print(_currentVersion);
    print(linkPath);
    // 版本相同，直接返回
    if (_currentVersion != null && _currentVersion == v) {
      return true;
    }
    // 找到对应版本下载地址
    List<String> urls = List.from(versions[v]?['urls'] ?? []);
    if (urls.isEmpty) {
      print("版本不匹配");
      return false;
    }
    // 下载
    var file = await downloadFile(urls, sdkPath);
    if (file == null) {
      print("所有地址均下载失败");
      return false;
    }
    String currPath = path.join(sdkPath, v);
    // 解压
    extractFileSimple(file.path, currPath);
    await file.delete();
    // 创建链接
    await deleteLink(linkPath);
    await createSymbolicLink(targetPath: currPath, linkPath: linkPath);
    // 设置环境变量
    if (_currentVersion == null) {
      EnvManager(system: false).set(platform.envName, linkPath);
      EnvManager(system: false).addToPath("%${platform.envName}%/bin");
    }
    return true;
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
