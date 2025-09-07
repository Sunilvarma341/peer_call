import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_call/core/app_colors.dart';
import 'package:peer_call/core/app_navigator.dart';
import 'package:peer_call/core/app_router.dart';
import 'package:peer_call/data/local_storage/local_storage.dart';
import 'package:peer_call/data/repositories/auth_repo.dart';
import 'package:peer_call/data/repositories/dashboard_repo.dart';
import 'package:peer_call/data/repositories/signaling_repo.dart';
import 'package:peer_call/data/services/webrtc_service.dart';
import 'package:peer_call/presentation/blocs/auth_bloc/auth_export.dart';
import 'package:peer_call/presentation/widgets/app_snackbar.dart';

Future<void> _firebaseInitialization() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _firebaseInitialization();
  LocalStorage localStorage = LocalStorage();
  final appNav = AppNavigator(localStorage: localStorage);
  await localStorage.init();
  runApp(MyApp(localStorage: localStorage, appNav: appNav));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.localStorage, required this.appNav});
  final LocalStorage localStorage;
  final AppNavigator appNav;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>(
          create: (context) {
            return AuthRepo();
          },
        ),
        RepositoryProvider.value(value: localStorage),
        RepositoryProvider.value(value: appNav),
        RepositoryProvider(create: (_) => AppColors()),
        RepositoryProvider(create: (_) => WebRTCService()),
        RepositoryProvider(create: (_) => SignalingRepo()),
        RepositoryProvider(
          create: (_) => AppNavigator(localStorage: localStorage),
        ),
        RepositoryProvider(create: (_) => DashboardRepo()),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          context.read<AuthRepo>(),
          localStorage: context.read<LocalStorage>(),
          navigator: context.read<AppNavigator>(),
        ),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Peer Call',
          scaffoldMessengerKey: AppSnackbar.scaffoldMessengerKey,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          routerConfig: AppRouter.router,
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
