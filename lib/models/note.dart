class Note {
  final String title;
  final String content;
  final DateTime timestamp;
  final bool isFavorite;

  const Note({
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
