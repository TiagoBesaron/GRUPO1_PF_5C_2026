import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

Future<void> descargarYAbrirPdfAssetImpl({
  required String assetPath,
  required String fileName,
}) async {
  final byteData = await rootBundle.load(assetPath);
  final bytes = byteData.buffer.asUint8List();

  if (Platform.isAndroid) {
    try {
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (await downloadsDir.exists()) {
        final publicFile = File('${downloadsDir.path}/$fileName');
        await publicFile.writeAsBytes(bytes, flush: true);
      }
    } catch (_) {}
  }

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsBytes(bytes, flush: true);

  await OpenFilex.open(file.path);
}