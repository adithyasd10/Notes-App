import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'note.dart';

class NoteDataProvider extends ChangeNotifier {
  final Box<Note> _box = Hive.box<Note>('notesBox');

  List<Note> _notes = [];

  List<Note> get allNotes => _notes;

  Future<void> loadNotes() async {
    _notes = _box.values.toList();
    notifyListeners();
  }

  Future<void> saveNotes() async {
    // Hive auto-saves, so this is just a placeholder
    notifyListeners();
  }

  void addNote(Note note) {
    _box.add(note);
    _notes = _box.values.toList();
    notifyListeners();
  }

  void updateNote(Note oldNote, Note newNote) {
    final key = oldNote.key;
    _box.put(key, newNote);
    _notes = _box.values.toList();
    notifyListeners();
  }

  void deleteNote(Note note) {
    note.delete(); // delete by reference
    _notes = _box.values.toList();
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
      updateNote(note, updatedNote);
    }
  }
}
