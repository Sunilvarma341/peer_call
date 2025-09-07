part of 'auth_export.dart'; 

abstract class AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  SignUpRequested(this.email, this.password);
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  SignInRequested(this.email, this.password);
}

class GoogleSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class ResendEmailVerification extends AuthEvent {
  final User user;
  ResendEmailVerification({required this.user});
}

class VerifyEmailRequested extends AuthEvent {
  final String email;
  final String code;
  VerifyEmailRequested(this.email, this.code);
}


