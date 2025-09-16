import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_call/core/app_navigator.dart';
import 'package:peer_call/core/pages.dart';
import 'package:peer_call/data/local_storage/local_storage.dart';
import 'package:peer_call/data/repositories/dashboard_repo.dart';
import 'package:peer_call/data/repositories/signaling_repo.dart';
import 'package:peer_call/data/services/webrtc_service.dart';
import 'package:peer_call/presentation/blocs/call_bloc/call_export.dart';
import 'package:peer_call/presentation/blocs/dash_board/dash_board_export.dart';
import 'package:peer_call/presentation/screens/auth/login_screen.dart';
import 'package:peer_call/presentation/screens/auth/sign_up_screen.dart';
import 'package:peer_call/presentation/screens/bottom_nav_bar.dart';
import 'package:peer_call/presentation/screens/call/call_screen.dart';
import 'package:peer_call/presentation/screens/profile/profile_screen.dart';
import 'package:peer_call/presentation/screens/splash/splash_screen.dart';

class AppRouter {
  AppRouter._();
  static final AppRouter instance = AppRouter._();
  static GoRouter get router => _router;
  static final GoRouter _router = GoRouter(
    navigatorKey: AppNavigator.navigatorKey,
    initialLocation: PAGE.splash.path,
    routes: [
      GoRoute(
        path: PAGE.splash.path,
        name: PAGE.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: PAGE.login.path,
        name: PAGE.login.name,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: PAGE.signup.path,
        name: PAGE.signup.name,
        builder: (context, state) {
          return const SignupScreen();
        },
      ),
      GoRoute(
        path: PAGE.bottomNav.path,
        name: PAGE.bottomNav.name,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => DashBoardBloc(
              dashBoardRepo: context.read<DashboardRepo>(),
              repo: context.read<SignalingRepo>(),
              localStorage: context.read<LocalStorage>(),
              appNav: context.read<AppNavigator>()
            )..add(GetAllUsersList()),
            child: const BottomNavBar(),
          );
        },
      ),
      GoRoute(
        path: PAGE.callScreen.path,
        name: PAGE.callScreen.name,
        builder: (context, state) {
          final j = state.extra as Map<String, dynamic>?;
          final joinRoomId = j?['joinRoomId'];
          final createdFor = j?['createdFor'];

          return BlocProvider(
            create: (context) => CallBloc(
              context.read<WebRTCService>(),
              context.read<SignalingRepo>(),
            )..init(),
            child: CallScreen(createdFor: createdFor, joinRoomId: joinRoomId),
          );
        },
      ),
    ],
  );
  

}
