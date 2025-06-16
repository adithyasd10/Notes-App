import 'package:flutter/material.dart';
import '../models/note.dart';
import 'add_note_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomePage({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredNotes = notes;
  }

  void deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
      filteredNotes = List.from(notes);
    });
  }

  void searchNotes(String query) {
    setState(() {
      filteredNotes = notes
          .where((note) =>
      note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void addNote(Note note) {
    setState(() {
      notes.add(note);
      filteredNotes = List.from(notes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          IconButton(
            icon:
            Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: searchNotes,
              style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: "Search your notes...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: widget.isDarkMode
                    ? Colors.black12
                    : Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (_, index) {
                final note = filteredNotes[index];
                return Card(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      note.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteNote(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        color: Colors.black,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            gap: 20,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            curve: Curves.linear,
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            mainAxisAlignment: MainAxisAlignment.center,
            onTabChange: (index) async {
              if (index == 0) {
                final newNote = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddNotePage(),
                  ),
                );
                if (newNote != null && newNote is Note) {
                  addNote(newNote);
                }
              } else if (index == 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Favorites tapped")),
                );
              }
            },
            tabs: const [
              GButton(
                icon: Icons.add,
                text: 'Add',
              )

            ],
          ),
        ),
      ),
    );
  }
}
