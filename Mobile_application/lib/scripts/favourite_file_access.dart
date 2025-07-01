import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteFileAccess {
  static const String _fileName = 'favourites.json';
  static const String _firebaseCollection = 'favourites';
  static String? _lastSyncedContent;

  /// Get path to the app's Download/Primewalls folder.
  static Future<String> _getFilePath() async {
    final dir = await getExternalStorageDirectory();
    final downloadDir = Directory('${dir!.path}/Primewalls/Downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return '${downloadDir.path}/$_fileName';
  }

  /// Reads the local favourites.json file.
  static Future<String?> _readLocalFile() async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      print('Error reading favourites.json: $e');
    }
    return null;
  }

  /// Uploads the content to Firestore under the user's email document.
  static Future<void> syncFavouritesToFirebase() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('userEmail');

      if (userEmail == null || userEmail.isEmpty) {
        print('No user email found in SharedPreferences');
        return;
      }

      final content = await _readLocalFile();
      if (content == null || content.isEmpty) {
        print('No favourites data to sync');
        return;
      }

      if (_lastSyncedContent == content) {
        print('No change in favourites.json, skipping upload');
        return;
      }

      final List<dynamic> favList = jsonDecode(content);
      final docRef = FirebaseFirestore.instance
          .collection(_firebaseCollection)
          .doc(userEmail);

      await docRef.set({'fav': favList}, SetOptions(merge: true));
      _lastSyncedContent = content;
      print('Favourites synced for $userEmail');
    } catch (e) {
      print('Error syncing favourites to Firestore: $e');
    }
  }
}
