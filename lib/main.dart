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

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  void toggleTheme() => setState(() => isDarkMode = !isDarkMode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(
        toggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.black,
  iconTheme: const IconThemeData(color: Colors.black87),
  textTheme: const TextTheme(
    titleLarge:
    TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 1,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  primaryColor: Colors.white,
  iconTheme: const IconThemeData(color: Colors.white70),
  textTheme: const TextTheme(
    titleLarge:
    TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: Colors.white,
    elevation: 1,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
);
