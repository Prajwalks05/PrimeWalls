import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Platform-aware method to get the Primewalls directory
Future<Directory> _getPrimewallsDirectory() async {
  if (Platform.isWindows) {
    final downloadsDir = await getDownloadsDirectory(); // Windows Downloads folder
    return Directory('${downloadsDir!.path}/Primewalls');
  } else {
    final docDir = await getApplicationDocumentsDirectory(); // For Android/macOS/Linux
    return Directory('${docDir.path}/Primewalls');
  }
}

/// Writes the full API response to `response.json` in the Primewalls folder
Future<void> writeResponseToFile(Map<String, dynamic> data) async {
  try {
    final primewallsDir = await _getPrimewallsDirectory();

    if (!await primewallsDir.exists()) {
      await primewallsDir.create(recursive: true);
      print("Primewalls directory created: ${primewallsDir.path}");
    }

    final jsonFile = File('${primewallsDir.path}/response.json');
    await jsonFile.writeAsString(json.encode(data), flush: true);
    print("Response JSON written to file: ${jsonFile.path}");
  } catch (e) {
    print("Error writing to response.json: $e");
  }
}
