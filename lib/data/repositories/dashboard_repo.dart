import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peer_call/data/models/user_model.dart';

class DashboardRepo {
  DashboardRepo();
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _userRef =>
      _firestore.collection("users");

  Future<List<UserModel>> getAllUsers() async {
    try {
      final userJson = await _userRef.get();
      return userJson.docs
          .map((user) => UserModel.fromJson(user.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
