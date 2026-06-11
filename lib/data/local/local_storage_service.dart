import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:instagram/data/models/user_model.dart';

class LocalStorageService {
  static const String _boxName = 'userBox';
  static const String _key = 'current_user';
  static const String favBoxName = 'favorite_post';

  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
    _box = await Hive.openBox(favBoxName);
  }

  // ---------------------------
  // FULL USER (optional use)
  // ---------------------------
  Future<void> saveUser(UserModel user) async {
    await _box.put(_key, _toMap(user));
  }

  UserModel? getUser() {
    final data = _box.get(_key);
    if (data == null) return null;

    return _fromMap(Map<String, dynamic>.from(data));
  }

  Future<void> clearUser() async {
    await _box.delete(_key);
  }

  Future<void> storeSingleField(String key, dynamic value) async {
    final Map<String, dynamic> userMap = Map<String, dynamic>.from(
      _box.get(_key) ?? {},
    );

    userMap[key] = value;

    await _box.put(_key, userMap);
  }

  bool hasUser() => _box.containsKey(_key);

  Future<void> storeUserNameLocal(String username) async {
    await _updateField('username', username);
  }

  Future<void> storeBioLocal(String bio) async {
    await _updateField('bio', bio);
  }

  Future<void> storeFullNameLocal(String fullName) async {
    await _updateField('fullName', fullName);
  }

  Future<void> storeProfileImageLocal(String url) async {
    await _updateField('profileImageUrl', url);
  }

  Future<void> storeWebsiteLocal(String website) async {
    await _updateField('website', website);
  }

  Future<void> storePhoneLocal(String phone) async {
    await _updateField('phone', phone);
  }

  Future<void> storeLocationLocal(String location) async {
    await _updateField('location', location);
  }

  Future<void> storeGenderLocal(String gender) async {
    await _updateField('gender', gender);
  }

  // Generic updater (important part)
  Future<void> _updateField(String key, dynamic value) async {
    final Map<String, dynamic> userMap = Map<String, dynamic>.from(
      _box.get(_key) ?? {},
    );

    userMap[key] = value;

    await _box.put(_key, userMap);
  }

  Map<String, dynamic> _toMap(UserModel user) {
    return {
      'fullName': user.fullName,
      'email': user.email,
      'username': user.username,
      'profileImageUrl': user.profileImageUrl,
      'gender': user.gender,
      'userId': user.userId,
      'deviceToken': user.deviceToken,
      'bio': user.bio,
      'website': user.website,
      'isPrivate': user.isPrivate,
      'isVerified': user.isVerified,
      'createdAt': user.createdAt.millisecondsSinceEpoch,
      'following': user.following,
      'followers': user.followers,
      'posts': user.posts,

      'location': user.location,
      'phone': user.phone,
      'updatedAt': user.updatedAt.millisecondsSinceEpoch,
    };
  }

  UserModel _fromMap(Map<String, dynamic> json) {
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
      createdAt: Timestamp.fromMillisecondsSinceEpoch(
        json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      following: List<String>.from(json['following'] ?? []),
      followers: List<String>.from(json['followers'] ?? []),
      posts: List<String>.from(json['posts'] ?? []),

      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      updatedAt: Timestamp.fromMillisecondsSinceEpoch(
        json['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
