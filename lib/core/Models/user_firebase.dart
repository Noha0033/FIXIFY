import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String password;
  final String email;
  final String? image;
  final DateTime? createdAt;

  UserModel({
    required this.userId,
    required this.password,
    required this.name,
    required this.email,
    this.image,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["userId"] ?? json["user_id"] ?? "",
      password: json["userId"] ?? json["password"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      image: json["image"],
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"]) // if stored as String
          : (json["createdAt"] is Timestamp
          ? (json["createdAt"] as Timestamp).toDate() // if from Firestore
          : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "password": password,
      "name": name,
      "email": email,
      "image": image,
      "createdAt": createdAt?.toIso8601String(),
    };
  }
}
