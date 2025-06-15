import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../models/note_data.dart';
import 'note_editor.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final noteData = Provider.of<NoteDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Your Notes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: noteData.allNotes.length,
          itemBuilder: (context, index) {
            final note = noteData.allNotes[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NoteEditor(note: note)),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3B0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text("${note.timestamp.toLocal()}".split(' ')[0]),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NoteEditor()),
        ),
        backgroundColor: Colors.yellow[700],
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
