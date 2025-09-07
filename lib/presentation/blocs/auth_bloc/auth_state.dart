
part of 'auth_export.dart'; 



abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}


class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  final String? message;
  Unauthenticated({this.message});
}