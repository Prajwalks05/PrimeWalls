import 'dart:io';
import 'package:flutter/material.dart';

Future<void> setWallpaperWindows(String filePath, BuildContext context) async {
  try {
    // Ensure the file exists
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception("Image file does not exist at: $filePath");
    }

    final command = '''
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
  [DllImport("user32.dll", SetLastError = true)]
  public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, "$filePath", 3)
''';
    final result = await Process.run(
      'powershell',
      ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', command],
    );

    if (result.exitCode == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Wallpaper set successfully!")),
      );
    } else {
      throw Exception(result.stderr.toString().isNotEmpty
          ? result.stderr
          : "Unknown error");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Error: $e")),
    );
  }
}
