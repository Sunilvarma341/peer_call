class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
  });

  // Convert UserModel -> Map
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "displayName": displayName,
      "photoURL": photoURL,
      "phoneNumber": phoneNumber,
    };
  }

  // Convert Map -> UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"],
      email: json["email"],
      displayName: json["displayName"],
      photoURL: json["photoURL"],
      phoneNumber: json["phoneNumber"],
    );
  }
}