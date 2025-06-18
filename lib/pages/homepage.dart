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
    final bgColor = widget.isDarkMode ? const Color(0xFF222831) : Colors.white;
    final cardColor =
    widget.isDarkMode ? const Color(0xFF393E46) : Colors.grey.shade100;
    final textColor =
    widget.isDarkMode ? const Color(0xFFDFD0B8) : Colors.black87;
    final accentColor = widget.isDarkMode ? const Color(0xFF948979) : Colors.grey;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        title: Text(
          "My Notes",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: accentColor,
            ),
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
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: "Search your notes...",
                hintStyle: TextStyle(color: accentColor),
                prefixIcon: Icon(Icons.search, color: accentColor),
                filled: true,
                fillColor:
                widget.isDarkMode ? const Color(0xFF393E46) : Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
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
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      note.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: accentColor),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.redAccent,
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
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? Colors.black.withOpacity(0.3)
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            gap: 12,
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: Colors.transparent,
            color: accentColor,
            activeColor: widget.isDarkMode ? Colors.white : Colors.black,
            tabBackgroundColor:
            widget.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
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
              ),
              GButton(
                icon: Icons.star,
                text: 'Favorites',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
