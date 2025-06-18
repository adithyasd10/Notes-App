import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/note.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _saveNote() {
    final String title = _titleController.text.trim();
    final String content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    final newNote = Note(
      title: title,
      content: content,
      timestamp: DateTime.now(),
      isFavorite: false,
    );

    Navigator.pop(context, newNote);
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    int? maxLines,
    bool expands = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFDFD0B8) : Colors.black87;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: expands ? null : maxLines,
            expands: expands,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: textColor.withOpacity(0.7),
              ),
              border: InputBorder.none,
            ),
            cursorColor: const Color(0xFF948979), // Accent
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF222831) : Colors.white;
    final textColor = isDark ? const Color(0xFFDFD0B8) : Colors.black87;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Add Note', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: const Color(0xFF948979)),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              bgColor.withOpacity(0.9),
              bgColor.withOpacity(1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildGlassTextField(
                  controller: _titleController,
                  label: 'Title',
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildGlassTextField(
                    controller: _contentController,
                    label: 'Content',
                    maxLines: null,
                    expands: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
