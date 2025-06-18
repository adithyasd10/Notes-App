import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note.dart';

class NoteDataProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get allNotes => _notes;

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('notes');
    if (jsonString != null) {
      final List jsonData = jsonDecode(jsonString);
      _notes = jsonData.map((e) => Note.fromJson(e)).toList();
    }
    notifyListeners();
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_notes.map((n) => n.toJson()).toList());
    await prefs.setString('notes', encoded);
  }

  void addNote(Note note) {
    _notes.add(note);
    saveNotes();
    notifyListeners();
  }

  void updateNote(Note oldNote, Note newNote) {
    final idx = _notes.indexOf(oldNote);
    if (idx >= 0) _notes[idx] = newNote;
    saveNotes();
    notifyListeners();
  }

  void deleteNote(Note note) {
    _notes.remove(note);
    saveNotes();
    notifyListeners();
  }

  List<Note> searchNotes(String query) {
    query = query.toLowerCase();
    return _notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();
  }
  void toggleFavorite(Note note) {
    final index = _notes.indexOf(note);
    if (index != -1) {
      final updatedNote = note.copyWith(isFavorite: !note.isFavorite);
      _notes[index] = updatedNote;
      saveNotes();
      notifyListeners();
    }
  }

}