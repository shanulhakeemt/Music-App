class FavSongModel {
  final String id;
  final String songId;
  final String userId;
  FavSongModel({
    required this.id,
    required this.songId,
    required this.userId,
  });

  FavSongModel copyWith({
    String? id,
    String? songId,
    String? userId,
  }) {
    return FavSongModel(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_id': songId,
      'user_id': userId,
    };
  }

  factory FavSongModel.fromMap(Map<String, dynamic> map) {
    return FavSongModel(
      id: map['id'] ?? '',
      songId: map['song_id'] ?? '',
      userId: map['user_id'] ?? '',
    );
  }
}
