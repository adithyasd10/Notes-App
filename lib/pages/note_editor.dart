import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../models/note_data.dart';

class NoteEditor extends StatefulWidget {
  final Note? note;
  const NoteEditor({super.key, this.note});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        backgroundColor: Colors.transparent,
        actions: isEditing
            ? [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<NoteDataProvider>(context, listen: false).deleteNote(widget.note!);
              Navigator.pop(context);
            },
          )
        ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Title'),
            ),
            Expanded(
              child: TextField(
                controller: contentController,
                style: const TextStyle(fontSize: 16),
                maxLines: null,
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'Type something...'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final title = titleController.text.trim();
          final content = contentController.text.trim();
          if (title.isEmpty || content.isEmpty) return;

          final noteProvider = Provider.of<NoteDataProvider>(context, listen: false);
          if (isEditing) {
            noteProvider.updateNote(widget.note!, title, content);
          } else {
            noteProvider.addNote(title, content);
          }
          Navigator.pop(context);
        },
        backgroundColor: Colors.yellow[700],
        child: const Icon(Icons.save, color: Colors.black),
      ),
    );
  }
}
