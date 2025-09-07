import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:peer_call/data/models/user_model.dart';

class LocalStorage {
  static const _stringBoxName = "stringBox";
  static const _boolBoxName = "boolBox";
  static const _intBoxName = "intBox";
  static const _userKey = "user";

  static late BoxCollection _collection;
  static late CollectionBox<String> _stringBox;
  static late CollectionBox<bool> _boolBox;
  static late CollectionBox<int> _intBox;

  /// Initialize Hive and open boxes
  Future<void> init() async {
    final dir = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    _collection = await BoxCollection.open('PeerCall', {
      _stringBoxName,
      _boolBoxName,
      _intBoxName,
    }, path: dir.path);

    _stringBox = await _collection.openBox<String>(_stringBoxName);
    _boolBox = await _collection.openBox<bool>(_boolBoxName);
    _intBox = await _collection.openBox<int>(_intBoxName);
  }

  /// Save Firebase user into Hive
  Future<void> saveUser(User user) async {
    final userModel = UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );

    final jsonString = jsonEncode(userModel.toJson());
    await _stringBox.put(_userKey, jsonString);
  }

  /// Get saved user from Hive
  Future<UserModel?> getUser() async {
    final jsonString = await _stringBox.get(_userKey);
    if (jsonString == null) return null;
    return UserModel.fromJson(jsonDecode(jsonString));
  }

  /// Clear user
  Future<void> clearUser() async {
    await _stringBox.clear();
    await _boolBox.clear();
    await _intBox.clear();
  }
}
