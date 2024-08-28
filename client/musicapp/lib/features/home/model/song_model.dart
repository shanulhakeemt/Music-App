
class SongModel {
  final String id;
  final String songName;
  final String songUrl;
  final String thumbnailUrl;
  final String artist;
  final String hexCode;
  SongModel({
    required this.id,
    required this.songName,
    required this.songUrl,
    required this.thumbnailUrl,
    required this.artist,
    required this.hexCode,
  });

  SongModel copyWith({
    String? id,
    String? songName,
    String? songUrl,
    String? thumbnailUrl,
    String? artist,
    String? hexCode,
  }) {
    return SongModel(
      id: id ?? this.id,
      songName: songName ?? this.songName,
      songUrl: songUrl ?? this.songUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      artist: artist ?? this.artist,
      hexCode: hexCode ?? this.hexCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'songName': songName,
      'songUrl': songUrl,
      'thumbnailUrl': thumbnailUrl,
      'artist': artist,
      'hexCode': hexCode,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ?? '',
      songName: map['song_name'] ?? '',
      songUrl: map['song_url'] ?? '',
      thumbnailUrl: map['thumbnail_url'] ?? '',
      artist: map['artist'] ?? '',
      hexCode: map['hex_code'] ?? '',
    );
  }
}
