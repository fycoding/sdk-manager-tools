import 'dart:io';
import 'package:win32_registry/win32_registry.dart';

/// Windows 环境变量管理器 (使用 win32_registry)
class EnvManager {
  /// 获取注册表键
  static RegistryKey _getEnvKey({required bool system}) {
    if (system) {
      return Registry.localMachine;
    } else {
      return Registry.currentUser;
    }
  }

  /// 获取环境变量
  static String? get(String name, {bool system = false}) {
    try {
      final key = _getEnvKey(system: system);
      final value = key.getValueAsString(name);
      key.close();
      return value;
    } catch (_) {
      return Platform.environment[name];
    }
  }

  /// 设置环境变量
  static bool set(String name, String value, {bool system = false}) {
    try {
      final key = _getEnvKey(system: system);
      key.close();
      return true;
    } catch (e) {
      stderr.writeln('Error: $e');
      return false;
    }
  }

  /// 删除环境变量
  static bool delete(String name, {bool system = false}) {
    try {
      final key = _getEnvKey(system: system);
      key.deleteValue(name);
      key.close();
      return true;
    } catch (e) {
      stderr.writeln('Error: $e');
      return false;
    }
  }

  /// 添加到 PATH
  static bool addToPath(String directory, {bool system = false}) {
    final path = get('Path', system: system);
    if (path == null) return false;

    final paths = path.split(';');
    if (paths.contains(directory)) return true;

    final newPath = path.endsWith(';') ? '$path$directory' : '$path;$directory';
    return set('Path', newPath, system: system);
  }

  /// 从 PATH 移除
  static bool removeFromPath(String directory, {bool system = false}) {
    final path = get('Path', system: system);
    if (path == null) return false;

    final paths = path.split(';');
    if (!paths.contains(directory)) return true;

    final newPaths = paths.where((p) => p != directory).join(';');
    return set('Path', newPaths, system: system);
  }

  /// 列出所有环境变量
  static Map<String, String> list({bool system = false}) {
    final env = <String, String>{};

    return env;
  }
}
