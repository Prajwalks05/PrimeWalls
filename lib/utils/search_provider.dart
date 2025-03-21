import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  List<String> imageUrls = [];
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setSearchResults(List<String> results) {
    imageUrls = results;
    isLoading = false;
    notifyListeners();
  }

  void clearResults() {
    imageUrls = [];
    notifyListeners();
  }
}
