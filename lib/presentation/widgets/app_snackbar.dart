import 'package:flutter/material.dart';

class AppSnackbar {
  AppSnackbar._();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

 static  void show(String msg) {
    final s = scaffoldMessengerKey.currentState;
    if (s != null && s.mounted) {
      s.showSnackBar(
        SnackBar(
          content: Text(msg, style: TextStyle(color: Colors.white)),
        ),
      );
    }
  }
}
