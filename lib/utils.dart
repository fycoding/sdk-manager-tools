import 'dart:io';

/// 创建链接符号
Future<bool> createSymbolicLink({
  required String targetPath,
  required String linkPath,
}) async {
  // 检查目标是否存在
  final target = Directory(targetPath);
  if (!await target.exists()) {
    throw Exception("目标目录不存在");
  }
  // 创建符号链接
  final link = Link(linkPath);
  if (await link.exists()) {
    // 已经存在
    throw Exception("链接已存在");
  }
  await Link(linkPath).create(targetPath);
  return true;
}

/// 获取符号链接的真实目标地址
String? getLinkTarget(String linkPath) {
  try {
    final link = Link(linkPath);
    return link.existsSync() ? link.targetSync() : null;
  } catch (_) {
    return null;
  }
}

/// 删除符号链接
Future<bool> deleteLink(String linkPath) async {
  try {
    final link = Link(linkPath);
    if (await link.exists()) {
      await link.delete();
      return true;
    }
    return false;
  } catch (_) {
    return false;
  }
}
