import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../models/note.dart';
import 'add_note_page.dart';

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
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    filteredNotes = notes;
  }

  void deleteNote(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final noteToDelete = filteredNotes[index];
                notes.removeWhere((note) => note.timestamp == noteToDelete.timestamp);
                filteredNotes = List.from(notes);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void searchNotes(String query) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        filteredNotes = notes
            .where((note) =>
        note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  void addNote(Note note) {
    setState(() {
      notes.add(note);
      filteredNotes = List.from(notes);
    });
  }

  void toggleFavorite(int index) {
    final currentNote = filteredNotes[index];
    final updatedNote = currentNote.copyWith(isFavorite: !currentNote.isFavorite);

    final originalIndex =
    notes.indexWhere((note) => note.timestamp == currentNote.timestamp);

    if (originalIndex != -1) {
      setState(() {
        notes[originalIndex] = updatedNote;
        filteredNotes[index] = updatedNote;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("My Notes"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: widget.toggleTheme,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: Tween<double>(begin: 0.75, end: 1.0).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Icon(
                  widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  key: ValueKey(widget.isDarkMode), // must be inside the Icon!
                ),
              ),
            ),
          ),
        ],

      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.scaffoldBackgroundColor.withOpacity(0.9),
              theme.scaffoldBackgroundColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.black.withOpacity(0.1)),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: searchNotes,
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                        decoration: const InputDecoration(
                          hintText: "Search your notes...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredNotes.length,
                  itemBuilder: (_, index) {
                    final note = filteredNotes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.08)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                note.title,
                                style: theme.textTheme.titleLarge,
                              ),
                              subtitle: Text(
                                note.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Wrap(
                                spacing: 8,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      note.isFavorite ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                    ),
                                    onPressed: () => toggleFavorite(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteNote(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: GNav(
                gap: 20,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                curve: Curves.easeInOut,
                backgroundColor: Colors.transparent,
                color: Colors.black,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.black.withOpacity(0.1),
                mainAxisAlignment: MainAxisAlignment.center,
                onTabChange: (index) async {
                  if (index == 0) {
                    final newNote = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddNotePage()),
                    );
                    if (newNote != null && newNote is Note) {
                      addNote(newNote);
                    }
                  }
                },
                tabs: const [
                  GButton(icon: Icons.add, text: 'Add'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
