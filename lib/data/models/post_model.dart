// ============================================================
//  WHAT GOES HERE
//  Post document model — one file per Firestore collection.
//  Same fromJson / toJson / copyWith pattern as UserModel.
// ============================================================

class PostModel {
  final String      id;
  final String      authorId;
  final String      body;
  final List<String> imageUrls;
  final int         likesCount;
  final DateTime    createdAt;

  const PostModel({
    required this.id,
    required this.authorId,
    required this.body,
    this.imageUrls  = const [],
    this.likesCount = 0,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> j) => PostModel(
        id:         j['id']         as String,
        authorId:   j['authorId']   as String,
        body:       j['body']       as String,
        imageUrls:  List<String>.from(j['imageUrls'] ?? []),
        likesCount: (j['likesCount'] ?? 0) as int,
        createdAt:  DateTime.parse(j['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id':         id,
        'authorId':   authorId,
        'body':       body,
        'imageUrls':  imageUrls,
        'likesCount': likesCount,
        'createdAt':  createdAt.toIso8601String(),
      };
}
