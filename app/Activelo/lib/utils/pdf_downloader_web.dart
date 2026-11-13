// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'package:flutter/services.dart' show rootBundle;

Future<void> descargarYAbrirPdfAssetImpl({
  required String assetPath,
  required String fileName,
}) async {
  final byteData = await rootBundle.load(assetPath);
  final bytes = byteData.buffer.asUint8List();

  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..style.display = 'none';

  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
}