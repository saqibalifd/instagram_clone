class StoryUserModel {
  final String name;
  final String profileImage;
  final String storyImage;
  final String songTitle;
  final String timeAgo;
  final bool isPlayed;
  final String userId;

  StoryUserModel({
    required this.name,
    required this.profileImage,
    required this.storyImage,
    required this.songTitle,
    required this.timeAgo,
    required this.isPlayed,
    required this.userId,
  });

  factory StoryUserModel.fromMap(Map<String, dynamic> map) {
    return StoryUserModel(
      name: map['name'] ?? '',
      profileImage: map['profileImage'] ?? '',
      storyImage: map['storyImage'] ?? '',
      songTitle: map['songTitle'] ?? '',
      timeAgo: map['timeAgo'] ?? '',
      isPlayed: map['isPlayed'] ?? false,
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profileImage': profileImage,
      'storyImage': storyImage,
      'songTitle': songTitle,
      'timeAgo': timeAgo,
      'isPlayed': isPlayed,
      'userId': userId,
    };
  }
}
