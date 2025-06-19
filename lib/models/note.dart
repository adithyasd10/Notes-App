import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final bool isFavorite;

   Note({
    required this.title,
    required this.content,
    required this.timestamp,
    this.isFavorite = false,
  });

  Note copyWith({
    String? title,
    String? content,
    DateTime? timestamp,
    bool? isFavorite,
  }) {
    return Note(
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'isFavorite': isFavorite,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    title: json['title'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    isFavorite: json['isFavorite'] ?? false,
  );
}
