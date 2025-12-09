import 'dart:io';
import 'package:http/http.dart' as http;

Future<File?> downloadFile(List<String> urls, String saveDir) async {
  final dir = Directory(saveDir);
  try {
    if (!await dir.exists()) await dir.create(recursive: true);
  } catch (_) {
    return null;
  }

  for (final url in urls) {
    try {
      final uri = Uri.parse(url);
      final fileName = uri.pathSegments.lastOrNull;
      if (fileName == null || fileName.isEmpty) continue;

      final savePath = '${dir.path}/$fileName';

      final request = http.Request('GET', uri);
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final total = streamedResponse.contentLength ?? 0;
        int received = 0;
        final bytes = <int>[];

        await for (final chunk in streamedResponse.stream) {
          bytes.addAll(chunk);
          received += chunk.length;

          if (total > 0) {
            final percentage = (received / total * 100).toStringAsFixed(1);
            stdout.write('进度: $percentage% ($received/$total bytes)\r');
          }
        }

        final file = File(savePath);
        await file.writeAsBytes(bytes);
        print('\n下载完成');
        return file;
      }
    } catch (_) {
      continue;
    }
  }

  if (await dir.exists()) {
    try {
      await dir.delete(recursive: true);
    } catch (_) {}
  }

  return null;
}
