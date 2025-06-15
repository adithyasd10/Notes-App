// lib/models/note_data.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note.dart';
import 'dart:convert';

class NoteDataProvider extends ChangeNotifier {
  List<Note> _allNotes = [];

  List<Note> get allNotes => _allNotes;

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('notes');
    if (jsonString != null) {
      final List jsonData = json.decode(jsonString);
      _allNotes = jsonData.map((e) => Note.fromJson(e)).toList();
    }
    notifyListeners();
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_allNotes.map((n) => n.toJson()).toList());
    await prefs.setString('notes', jsonString);
  }

  void addNote(String title, String content) {
    final newNote = Note(
      title: title,
      content: content,
      timestamp: DateTime.now(),
    );
    _allNotes.add(newNote);
    saveNotes();
    notifyListeners();
  }

  void deleteNote(Note note) {
    _allNotes.remove(note);
    saveNotes();
    notifyListeners();
  }

  void updateNote(Note oldNote, String newTitle, String newContent) {
    for (int i = 0; i < _allNotes.length; i++) {
      if (_allNotes[i] == oldNote) {
        _allNotes[i] = Note(
          title: newTitle,
          content: newContent,
          timestamp: DateTime.now(),
        );
        break;
      }
    }
    saveNotes();
    notifyListeners();
  }

  List<Note> searchNotes(String query) {
    return _allNotes
        .where((note) =>
    note.title.toLowerCase().contains(query.toLowerCase()) ||
        note.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
