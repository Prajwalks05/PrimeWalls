import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  List<String> _imageUrls = [];
  List<String> _imageIds = [];
  bool _isLoading = false;

  List<String> get imageUrls => _imageUrls;
  List<String> get imageIds => _imageIds;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setSearchResults(List<Map<String, String>> results) {
    _imageUrls = results.map((result) => result['url']!).toList();
    _imageIds = results.map((result) => result['id']!).toList();
    setLoading(false); // Stop loading once results are set
    notifyListeners(); // Notify listeners to update the UI
  }
}
