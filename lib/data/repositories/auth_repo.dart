import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peer_call/core/app_config.dart';
import 'package:peer_call/data/models/user_model.dart';

class AuthRepo {
  AuthRepo();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn.instance;
  final String userCollection = 'users';
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _db.collection(userCollection);

  void initializeGoogleSignIn() {
    try {
      _googleAuth.initialize(
        clientId: AppConfig.fireBaseClientId,
        serverClientId: AppConfig.fireBaseClientId,
      );
    } catch (e) {
      log("Error during GoogleSignIn disconnect: $e");
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleAuth.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      log(
        "Google User: $googleUser userCredential : $userCredential ===================",
      );
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await _googleAuth.signOut();
    await _auth.signOut();
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signUpWithEmailAndVerify(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Send verification email
    await result.user?.sendEmailVerification();

    return result.user;
  }

  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  // Current User
  User? get currentUser => _auth.currentUser;

  Future<void> createUserDb(UserModel user) async {
    try {
      _usersRef.doc(user.uid).set(user.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
