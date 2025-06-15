// lib/pages/homepage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../models/note_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';

  void showNoteDialog({Note? existingNote}) {
    String title = existingNote?.title ?? '';
    String content = existingNote?.content ?? '';
    final isEditing = existingNote != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: title),
              onChanged: (val) => title = val,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: TextEditingController(text: content),
              onChanged: (val) => content = val,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (title.isEmpty || content.isEmpty) return;
              final noteData =
              Provider.of<NoteDataProvider>(context, listen: false);
              if (isEditing) {
                noteData.updateNote(existingNote!, title, content);
              } else {
                noteData.addNote(title, content);
              }
              Navigator.pop(context);
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteData = Provider.of<NoteDataProvider>(context);
    final notes = searchQuery.isEmpty
        ? noteData.allNotes
        : noteData.searchNotes(searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearchDialog();
            },
          )
        ],
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes yet.'))
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (_, i) {
          final note = notes[i];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            onTap: () => showNoteDialog(existingNote: note),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  Provider.of<NoteDataProvider>(context, listen: false)
                      .deleteNote(note),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (_) {
        String tempQuery = searchQuery;
        return AlertDialog(
          title: const Text('Search Notes'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter keyword...'),
            onChanged: (val) => tempQuery = val,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  searchQuery = tempQuery;
                });
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}
