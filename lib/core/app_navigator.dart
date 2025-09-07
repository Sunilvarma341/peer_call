import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_call/core/app_router.dart';
import 'package:peer_call/core/pages.dart';
import 'package:peer_call/data/local_storage/local_storage.dart';
import 'package:peer_call/data/models/user_model.dart';

class AppNavigator {
  final LocalStorage localStorage;
  AppNavigator({required this.localStorage});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GoRouter router = AppRouter.router;

  void initiaNavigation() async {
    final UserModel? userModel = await localStorage.getUser();
    if (userModel != null) {
      router.go(PAGE.bottomNav.path);
    } else {
      router.go(PAGE.login.path);
    }
  }

  void navigateToLoginScreen() {
    router.go(PAGE.login.path);
  }

  void pop() {
    try {
      router.pop();
    } catch (e) {
      print('$e   pop  error ');
    }
  }
}
