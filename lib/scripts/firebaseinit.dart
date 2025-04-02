import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseInit {
  static Future<void> initialize() async {
    try {
      // Ensure Firebase is only initialized once
      await Firebase.initializeApp();
      debugPrint("✅ Firebase Initialized Successfully!");
    } catch (e) {
      debugPrint("❌ Firebase Initialization Failed: $e");
    }
  }
}
