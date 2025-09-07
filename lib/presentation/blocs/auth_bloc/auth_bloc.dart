part of 'auth_export.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepository;
  final AppNavigator _navigator; 
  LocalStorage _localStorage;
  AuthBloc(
    this._authRepository, {
    required LocalStorage localStorage,
    required AppNavigator navigator,
  }) : _localStorage = localStorage,
     _navigator = navigator, 

       super(AuthInitial()) {
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authRepository.signUpWithEmailAndVerify(
          event.email.trim(),
          event.password.trim(),
        );

        if (user != null) {
          emit(
            Unauthenticated(
              message: "Verification email sent. Please check your inbox.",
            ),
          );
        } else {
          emit(Unauthenticated(message: "Signup failed"));
        }
      } catch (e) {
        emit(Unauthenticated(message: e.toString()));
      }
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authRepository.signInWithEmail(
          event.email.trim(),
          event.password.trim(),
        );
        if (user != null && !user.emailVerified) {
          await _authRepository.signOut();
          emit(
            Unauthenticated(
              message: "Email not verified. Please check your inbox.",
            ),
          );
        } else {
          emit(Authenticated(user!));
          await _authRepository.createUserDb(
            UserModel(
              uid: user.uid,
              email: user.email ?? '',
              displayName: user.displayName ?? '',
              photoURL: user.photoURL ?? '',
              phoneNumber: user.phoneNumber ?? '',
            ),
          );
          _localStorage.saveUser(user);
        }
        emit(Authenticated(user));
      } catch (e) {
        emit(Unauthenticated(message: e.toString()));
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authRepository.signInWithGoogle();
        if (user != null) {
          await _authRepository.createUserDb(
            UserModel(
              uid: user.uid,
              email: user.email ?? '',
              displayName: user.displayName ?? '',
              photoURL: user.photoURL ?? '',
              phoneNumber: user.phoneNumber ?? '',
            ),
          );
          _localStorage.saveUser(user);
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated(message: "Google Sign-In canceled"));
        }
      } catch (e) {
        emit(Unauthenticated(message: e.toString()));
      }
    });

    on<SignOutRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        await _authRepository.signOut();
        _localStorage.clearUser();
        emit(Unauthenticated());
        _navigator.navigateToLoginScreen();
      } catch (e) {
        Unauthenticated(message: "something went wrong!");
        log("logout: $e");
      } finally {}
    });
    on<ResendEmailVerification>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.resendVerificationEmail();
        emit(
          Unauthenticated(
            message: "Verification email resent. Please check your inbox.",
          ),
        );
      } catch (e) {
        emit(Unauthenticated(message: e.toString()));
      }
    });
    on<VerifyEmailRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authRepository.getCurrentUser();
        await user?.reload(); // Refresh user to get the latest info
        if (user != null && user.emailVerified) {
          _localStorage.saveUser(user);
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated(message: "Email not verified yet."));
        }
      } catch (e) {
        emit(Unauthenticated(message: e.toString()));
      }
    });
  }
}
