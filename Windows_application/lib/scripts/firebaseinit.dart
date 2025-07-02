import 'package:firebase_core/firebase_core.dart';

class FirebaseInit {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBcVJtWIJW_QMRE7a1HHaU5lXeojhl2dm0",
        authDomain: "primewalls-8b7ab.firebaseapp.com",
        projectId: "primewalls-8b7ab",
        storageBucket: "primewalls-8b7ab.appspot.com",
        messagingSenderId: "532440882861",
        appId: "1:532440882861:web:403dce1065bd8989f67024",
        measurementId: "G-VZH9KYRWTW",
      ),
    );
  }
}
