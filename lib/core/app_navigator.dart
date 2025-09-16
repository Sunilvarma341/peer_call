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

  void navigateToCallScreen(String joinRoomId) {
    router.push(PAGE.callScreen.path, extra: {'joinRoomId': joinRoomId});
  }

  String getCurrentRoute() {
    final routerDelegate = AppNavigator.router.routerDelegate;
    final RouteMatchList matchList = routerDelegate.currentConfiguration;

    // Get the last matched route
    final RouteMatch lastMatch = matchList.last;

    // Current route location
    final String location = matchList.uri.toString();

    debugPrint("📍 Current route: $location   ->  ${lastMatch.route.path}");

    return location;
  }

  bool isCallScreenOpen() {
    final current = getCurrentRoute();
    return current.startsWith(PAGE.callScreen.path);
  }
}
