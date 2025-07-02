import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Helper to get platform-specific `Primewalls` folder inside app storage or Downloads (for Windows).
Future<Directory> _getPrimewallsDirectory() async {
  final Directory baseDir;

  if (Platform.isWindows) {
    final downloadsDir = await getDownloadsDirectory();
    baseDir = Directory('${downloadsDir!.path}/Primewalls');
  } else {
    final appDocDir = await getApplicationDocumentsDirectory();
    baseDir = Directory('${appDocDir.path}/Primewalls');
  }

  if (!await baseDir.exists()) {
    await baseDir.create(recursive: true);
  }

  return baseDir;
}

/// Write full API response to response.json
Future<void> writeResponseToFile(String responseBody) async {
  try {
    final dir = await _getPrimewallsDirectory();
    final jsonFile = File('${dir.path}/response.json');
    await jsonFile.writeAsString(responseBody, flush: true);
    print("✅ Full API response written to: ${jsonFile.path}");
  } catch (e) {
    print("❌ Error writing API response: $e");
  }
}

/// Write single cleaned image object to response.json
Future<void> writeSingleImageToFile(Map<String, dynamic> imageData) async {
  try {
    final dir = await _getPrimewallsDirectory();

    // Clean portrait URL
    final rawUrl = imageData['src']['original']?.split('?').first ?? '';
    imageData['src']['original'] = rawUrl;

    final jsonFile = File('${dir.path}/response.json');
    await jsonFile.writeAsString(json.encode(imageData), flush: true);
    print("✅ Cleaned image data written to: ${jsonFile.path}");
  } catch (e) {
    print("❌ Error writing single image response: $e");
  }
}
