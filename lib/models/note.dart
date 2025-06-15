// lib/models/note.dart
import 'dart:convert';

class Note {
  String title;
  String content;
  DateTime timestamp;

  Note({
    required this.title,
    required this.content,
    required this.timestamp,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  // Convert from JSON
  factory Note.fromJson(Map<String, dynamic> json) => Note(
    title: json['title'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}