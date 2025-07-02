import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseHandler {
  /// Sanitize email to use as Firestore document ID.
  static String sanitizeEmail(String email) {
    return email.replaceAll('.', '_dot_').replaceAll('@', '_at_');
  }

  /// Retrieve stored user email from SharedPreferences.
  static Future<String?> _getStoredEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  /// Add an image URL to the user's favourites in Firestore.
  static Future<bool> addFavourite(String imageUrl) async {
    try {
      final email = await _getStoredEmail();
      if (email == null) return false;

      final sanitizedEmail =
          sanitizeEmail(email); // Sanitize email before using it
      final docRef = FirebaseFirestore.instance
          .collection('favourites')
          .doc(sanitizedEmail); // Use sanitized email as Firestore document ID

      await docRef.set({
        'fav':
            FieldValue.arrayUnion([imageUrl]) // Add image URL to the fav array
      }, SetOptions(merge: true)); // Merge to avoid overwriting other data

      return true;
    } catch (e) {
      debugPrint("Error adding favourite: $e");
      return false;
    }
  }

  /// Remove an image URL from the user's favourites in Firestore.
  static Future<bool> removeFavourite(String imageUrl) async {
    try {
      final email = await _getStoredEmail();
      if (email == null) return false;

      final sanitizedEmail =
          sanitizeEmail(email); // Sanitize email before using it
      final docRef = FirebaseFirestore.instance
          .collection('favourites')
          .doc(sanitizedEmail); // Use sanitized email as Firestore document ID

      await docRef.set({
        'fav': FieldValue.arrayRemove(
            [imageUrl]) // Remove image URL from the fav array
      }, SetOptions(merge: true)); // Merge to avoid overwriting other data

      return true;
    } catch (e) {
      debugPrint("Error removing favourite: $e");
      return false;
    }
  }

  /// Retrieve the list of favourite image URLs for the current user.
  static Future<List<String>> getFavourites() async {
    try {
      final email = await _getStoredEmail();
      if (email == null) return [];

      final sanitizedEmail =
          sanitizeEmail(email); // Sanitize email before using it
      final docRef = FirebaseFirestore.instance
          .collection('favourites')
          .doc(sanitizedEmail); // Use sanitized email as Firestore document ID
      final snapshot = await docRef.get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        if (data['fav'] is List) {
          return List<String>.from(
              data['fav']); // Return the list of image URLs
        }
      }
    } catch (e) {
      debugPrint("Error getting favourites: $e");
    }

    return [];
  }

  /// Check whether a specific image URL is in the user's favourites.
  static Future<bool> isFavourite(String imageUrl) async {
    final favourites = await getFavourites();
    return favourites.contains(
        imageUrl); // Check if the image URL is in the list of favourites
  }

  /// Toggle favourite status for the given image URL.
  /// Returns `true` if added, `false` if removed, or `null` on error.
  static Future<bool?> toggleFavourite(String imageUrl) async {
    try {
      final email = await SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('userEmail'));
      debugPrint("Stored email: $email");
      final isFav = await isFavourite(imageUrl);
      if (isFav) {
        final removed =
            await removeFavourite(imageUrl); // Remove if already favourite
        return removed ? false : null;
      } else {
        final added = await addFavourite(imageUrl); // Add if not favourite
        return added ? true : null;
      }
    } catch (e) {
      debugPrint("Error toggling favourite: $e");
      return null;
    }
  }
}
