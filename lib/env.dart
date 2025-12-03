import 'package:win32_registry/win32_registry.dart';

/// Windows 环境变量管理器 (使用 win32_registry)
class EnvManager {
  // 系统环境变量
  static const systemPath =
      r"SYSTEM\CurrentControlSet\Control\Session Manager\Environment";
  // 用户环境变量
  static const userPath = r"Environment";

  final bool system;
  final RegistryKey registryKey;
  EnvManager({this.system = true}) : registryKey = _getEnvKeys(system: system);

  /// 列出所有环境变量
  Map<String, String> list({bool system = false}) {
    final env = <String, String>{};
    for (var registryValue in registryKey.values) {
      final RegistryValue(:name) = registryValue;
      switch (registryValue) {
        case StringValue(:final value) || UnexpandedStringValue(:final value):
          env[name] = value;
        case _:
      }
    }
    registryKey.close();
    return env;
  }

  /// 获取环境变量
  String? get(String name) {
    var ret = registryKey.getStringValue(name);
    registryKey.close();
    return ret;
  }

  /// 设置环境变量
  bool set(String name, String value) {
    registryKey
      ..createValue(RegistryValue.string(name, value))
      ..close();
    return true;
  }

  /// 删除环境变量
  bool delete(String name) {
    var value = registryKey.getStringValue(name);
    if (value != null) {
      registryKey
        ..deleteValue(name)
        ..close();
      return true;
    }
    return false;
  }

  /// 添加到 PATH
  bool addToPath(String directory) {
    var paths = _getPath();
    if (!paths.contains(directory)) {
      paths.insert(0, directory);
      _savePath(paths);
    }
    registryKey.close();
    return true;
  }

  /// 从 PATH 移除
  bool removeFromPath(String directory) {
    var paths = _getPath();
    if (paths.contains(directory)) {
      paths.remove(directory);
      _savePath(paths);
    }
    registryKey.close();
    return true;
  }

  List<String> _getPath() {
    List<String> list = [];
    var path = registryKey.getStringValue("Path");
    if (path != null) {
      list = path.split(";");
    }
    return list;
  }

  void _savePath(List<String> paths) {
    set("Path", paths.join(";"));
  }

  /// 获取所有的key
  static RegistryKey _getEnvKeys({required bool system}) {
    RegistryKey registryKey;
    if (system) {
      registryKey = Registry.openPath(
        RegistryHive.localMachine,
        path: systemPath,
      );
    } else {
      registryKey = Registry.openPath(
        RegistryHive.currentUser,
        path: userPath,
        desiredAccessRights: AccessRights.allAccess,
      );
    }
    return registryKey;
  }
}
