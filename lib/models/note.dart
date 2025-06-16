class Note {
  String title;
  String content;
  DateTime timestamp;
  bool isFavorite;
  Note({
    required this.title,
    required this.content,
    required this.timestamp,
    this.isFavorite = false
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'isFavorite': isFavorite, // ✅ Add this
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    title: json['title'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    isFavorite: json['isFavorite'] ?? false, // ✅ Add this
  );
}
