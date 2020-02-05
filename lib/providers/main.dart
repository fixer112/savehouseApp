import 'package:flutter/material.dart';

class MainModel with ChangeNotifier {
  String hostUrl = 'https://savehouse.altechtic.com';
  bool loggedIn = false;
  bool isLoading = false;

  setLoggedIn(bool value) {
    loggedIn = value;
    notifyListeners();
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
