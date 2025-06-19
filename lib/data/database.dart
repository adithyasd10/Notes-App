import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';

class NoteDatabase {
  static const String _boxName = 'notesBox';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NoteAdapter());
    await Hive.openBox<Note>(_boxName);
  }

  static Box<Note> get notesBox => Hive.box<Note>(_boxName);

  static Future<void> addNote(Note note) async {
    await notesBox.add(note);
  }

  static Future<void> updateNote(int index, Note note) async {
    await notesBox.putAt(index, note);
  }

  static Future<void> deleteNote(int index) async {
    await notesBox.deleteAt(index);
  }

  static List<Note> getAllNotes() {
    return notesBox.values.toList();
  }
}
