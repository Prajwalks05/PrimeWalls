// file_utils.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> writeResponseToFile(Map<String, dynamic> data) async {
  try {
    final directory = await getExternalStorageDirectory();
    final downloadPath = '${directory!.path}/Downloads/Primewalls';

    final primewallsDirectory = Directory(downloadPath);
    if (!await primewallsDirectory.exists()) {
      await primewallsDirectory.create(recursive: true);
      print("Primewalls directory created: $downloadPath");
    }

    final jsonFile = File('${primewallsDirectory.path}/response.json');
    await jsonFile.writeAsString(json.encode(data), flush: true);
    print("Response JSON written to file: ${jsonFile.path}");
  } catch (e) {
    print("Error writing to response.json: $e");
  }
}
