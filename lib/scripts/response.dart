// File: scripts/response.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> writeResponseToFile(String responseBody) async {
  try {
    final directory = await getExternalStorageDirectory();
    final downloadPath = '${directory!.path}/Download/Primewalls';
    final primewallsDirectory = Directory(downloadPath);
    if (!await primewallsDirectory.exists()) {
      await primewallsDirectory.create(recursive: true);
    }
    final jsonFile = File('${primewallsDirectory.path}/response.json');
    await jsonFile.writeAsString(responseBody, flush: true);
    print("Full API response written to file");
  } catch (e) {
    print("Error writing API response: $e");
  }
}

Future<void> writeSingleImageToFile(Map<String, dynamic> imageData) async {
  try {
    final directory = await getExternalStorageDirectory();
    final downloadPath = '${directory!.path}/Download/Primewalls';
    final primewallsDirectory = Directory(downloadPath);
    if (!await primewallsDirectory.exists()) {
      await primewallsDirectory.create(recursive: true);
    }
    final jsonFile = File('${primewallsDirectory.path}/response.json');
    await jsonFile.writeAsString(json.encode(imageData), flush: true);
    print("Single image response written to file");
  } catch (e) {
    print("Error writing single image response: $e");
  }
}
