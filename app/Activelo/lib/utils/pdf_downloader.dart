import 'pdf_downloader_stub.dart'
    if (dart.library.html) 'pdf_downloader_web.dart'
    if (dart.library.io) 'pdf_downloader_io.dart';

Future<void> descargarYAbrirPdfAsset({
  required String assetPath,
  required String fileName,
}) {
  return descargarYAbrirPdfAssetImpl(
    assetPath: assetPath,
    fileName: fileName,
  );
}