import 'dart:io';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;

/// 根据扩展名选择解压方式
void extractFileSimple(String archivePath, String extractTo) {
  final ext = path.extension(archivePath).toLowerCase();

  switch (ext) {
    case '.zip':
      _extractZipSimple(archivePath, extractTo);
      break;
    case '.tar':
      _extractTarSimple(archivePath, extractTo);
      break;
    default:
      print('不支持的文件格式: $ext');
  }
}

/// 解压 ZIP - 去除顶层目录
void _extractZipSimple(String zipPath, String extractTo) {
  try {
    final bytes = File(zipPath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    _saveFilesWithoutTopDir(archive.files, extractTo, 'ZIP');
  } catch (e) {
    print('ZIP解压失败: $e');
  }
}

/// 解压 TAR - 去除顶层目录
void _extractTarSimple(String tarPath, String extractTo) {
  try {
    final inputStream = InputFileStream(tarPath);
    final archive = TarDecoder().decodeStream(inputStream);
    _saveFilesWithoutTopDir(archive.files, extractTo, 'TAR');
    inputStream.close();
  } catch (e) {
    print('TAR解压失败: $e');
  }
}

/// 保存文件，去除顶层目录
void _saveFilesWithoutTopDir(
  List<ArchiveFile> files,
  String extractTo,
  String format,
) {
  // 创建目标目录
  Directory(extractTo).createSync(recursive: true);
  print('解压 $format 文件到 $extractTo');
  // 先分析所有文件，找出顶层目录
  String? topLevelDir;
  for (final file in files) {
    if (file.name.isNotEmpty) {
      // 获取第一个路径分隔符的位置
      final firstSeparator = file.name.indexOf('/');
      if (firstSeparator != -1) {
        final candidate = file.name.substring(0, firstSeparator);
        if (topLevelDir == null || candidate.length < topLevelDir.length) {
          topLevelDir = candidate;
        }
      }
    }
  }

  print('检测到顶层目录: ${topLevelDir ?? "无"}');

  // 处理所有文件，去除顶层目录
  for (final file in files) {
    if (file.isFile) {
      try {
        final data = file.content as List<int>;

        // 跳过空文件名
        if (file.name.isEmpty) continue;

        String relativePath = file.name;

        // 去除顶层目录
        if (topLevelDir != null && relativePath.startsWith('$topLevelDir/')) {
          relativePath = relativePath.substring(topLevelDir.length + 1);
        }

        // 如果去除后为空，跳过
        if (relativePath.isEmpty) continue;

        // 完整的输出路径
        final outputPath = path.join(extractTo, relativePath);

        // 确保文件的父目录存在
        final parentDir = path.dirname(outputPath);
        if (parentDir != extractTo) {
          Directory(parentDir).createSync(recursive: true);
        }

        // 写入文件
        File(outputPath).writeAsBytesSync(data);
      } catch (e) {
        print('文件 ${file.name} 保存失败: $e');
      }
    } else {
      // 处理目录（如果顶层目录被去除，也需要相应地处理目录）
      if (file.name.isNotEmpty) {
        String relativePath = file.name;

        // 去除顶层目录
        if (topLevelDir != null && relativePath.startsWith('$topLevelDir/')) {
          relativePath = relativePath.substring(topLevelDir.length + 1);

          // 如果去除后不为空，创建目录
          if (relativePath.isNotEmpty) {
            final dirPath = path.join(extractTo, relativePath);
            Directory(dirPath).createSync(recursive: true);
          }
        }
      }
    }
  }
}
