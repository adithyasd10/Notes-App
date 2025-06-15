import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/note_data.dart';
import 'pages/homepage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NoteDataProvider()..loadNotes(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes UI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.yellow[700],
        cardColor: const Color(0xFF1C1C1E),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.yellow[700],
          foregroundColor: Colors.black,
        ),
      ),
      home: const HomePage(),
    );
  }
}

