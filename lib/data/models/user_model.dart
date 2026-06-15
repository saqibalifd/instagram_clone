import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String fullName;
  final String email;
  final String username;
  final String profileImageUrl;
  final String gender;
  final String userId;
  final String deviceToken;
  final String bio;
  final String website;
  final bool isPrivate;
  final bool isVerified;
  final Timestamp createdAt;
  final List<String> following;
  final List<String> followers;
  final List<String> posts;
  final List<String> blocked;
  final List<String> likedPosts;

  final String location;
  final String phone;
  final String status;

  final Timestamp updatedAt;

  const UserModel({
    required this.fullName,
    required this.email,
    required this.username,
    required this.profileImageUrl,
    required this.gender,
    required this.userId,
    required this.deviceToken,
    required this.bio,
    required this.website,
    required this.isPrivate,
    required this.isVerified,
    required this.createdAt,
    required this.following,
    required this.followers,
    required this.posts,
    required this.blocked,
    required this.likedPosts,

    required this.location,
    required this.phone,
    required this.status,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      gender: json['gender'] ?? '',

      userId: json['userId'] ?? '',
      deviceToken: json['deviceToken'] ?? '',
      bio: json['bio'] ?? '',
      website: json['website'] ?? '',
      isPrivate: json['isPrivate'] ?? false,
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] ?? Timestamp.now(),
      following: List<String>.from(json['following'] ?? []),
      followers: List<String>.from(json['followers'] ?? []),
      posts: List<String>.from(json['posts'] ?? []),
      blocked: List<String>.from(json['blocked'] ?? []),
      likedPosts: List<String>.from(json['likedPosts'] ?? []),

      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? '',
      updatedAt: json['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'gender': gender,
      'userId': userId,
      'deviceToken': deviceToken,
      'bio': bio,
      'website': website,
      'isPrivate': isPrivate,
      'isVerified': isVerified,
      'createdAt': createdAt,
      'following': following,
      'followers': followers,
      'posts': posts,
      'blocked': blocked,
      'likedPosts': likedPosts,

      'location': location,
      'phone': phone,
      'status': status,
      'updatedAt': updatedAt,
    };
  }

  UserModel copyWith({
    String? fullName,
    String? email,
    String? username,
    String? profileImageUrl,
    String? gender,
    String? userId,
    String? deviceToken,
    String? bio,
    String? website,
    bool? isPrivate,
    bool? isVerified,
    Timestamp? createdAt,
    List<String>? following,
    List<String>? followers,
    List<String>? posts,
    List<String>? blocked,
    List<String>? likedPosts,

    String? location,
    String? phone,
    String? status,

    Timestamp? updatedAt,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      gender: gender ?? this.gender,
      userId: userId ?? this.userId,
      deviceToken: deviceToken ?? this.deviceToken,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      isPrivate: isPrivate ?? this.isPrivate,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      posts: posts ?? this.posts,
      blocked: blocked ?? this.blocked,
      likedPosts: likedPosts ?? this.likedPosts,

      location: location ?? this.location,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
