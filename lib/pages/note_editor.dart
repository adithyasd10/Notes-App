import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../models/note_data.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note;

  const NoteEditorPage({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late final TextEditingController titleCtrl;
  late final TextEditingController contentCtrl;
  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.note?.title);
    contentCtrl = TextEditingController(text: widget.note?.content);
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    contentCtrl.dispose();
    super.dispose();
  }

  void saveNote() {
    final title = titleCtrl.text.trim();
    final content = contentCtrl.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    final newNote = Note(
      title: title,
      content: content,
      timestamp: DateTime.now(),
    );

    final provider =
    Provider.of<NoteDataProvider>(context, listen: false);

    if (isEditing) {
      provider.updateNote(widget.note!, newNote);
    } else {
      provider.addNote(newNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'Add Note'),
        actions: [
          IconButton(
            onPressed: saveNote,
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              style: theme.textTheme.titleLarge,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
            Expanded(
              child: TextField(
                controller: contentCtrl,
                style: theme.textTheme.bodyMedium,
                decoration: const InputDecoration(
                  hintText: 'Type your notes here...',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}