import 'package:flutter/widgets.dart';

class AuthNotifier with ChangeNotifier {
  String _userid;

  String get user => _userid;

  void setUser(String user) {
    _userid = user;
    notifyListeners();
  }
  
}