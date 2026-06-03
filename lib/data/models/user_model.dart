// ============================================================
//  WHAT GOES HERE
//  Plain Dart class mirroring the Firestore 'users' document.
//  Add: fromJson, toJson, copyWith, == / hashCode.
//  Never import GetX or Flutter here.
// ============================================================

class UserModel {
  final String  id;
  final String  username;
  final String  email;
  final String? avatarUrl;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        id:        j['id']        as String,
        username:  j['username']  as String,
        email:     j['email']     as String,
        avatarUrl: j['avatarUrl'] as String?,
        createdAt: DateTime.parse(j['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id':        id,
        'username':  username,
        'email':     email,
        'avatarUrl': avatarUrl,
        'createdAt': createdAt.toIso8601String(),
      };

  UserModel copyWith({String? username, String? avatarUrl}) => UserModel(
        id:        id,
        username:  username  ?? this.username,
        email:     email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        createdAt: createdAt,
      );
}
