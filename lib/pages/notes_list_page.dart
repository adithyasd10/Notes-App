import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_data.dart';
import '../models/note.dart';
import 'note_editor.dart';

class NotesListPage extends StatelessWidget {
  const NotesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoteDataProvider>(context);
    final notes = provider.allNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes yet'))
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (_, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(
              note.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NoteEditorPage(note: note),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NoteEditorPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
