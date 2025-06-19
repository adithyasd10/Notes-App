import 'package:flutter/material.dart';
import 'package:notes/pages/splash_screen.dart';
import 'package:provider/provider.dart';
import 'models/note_data.dart';
import 'pages/homepage.dart';
// ✅ Hive-related imports
import 'package:hive_flutter/hive_flutter.dart';
import 'models/note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());

  // Open Hive box
  await Hive.openBox<Note>('notesBox');
  print('✅ Hive box opened: ${Hive.box<Note>('notesBox').name}');

  // ✅ Add test note (optional debug)
  final box = Hive.box<Note>('notesBox');
  if (box.isEmpty) {
    final testNote = Note(
      title: 'Hive Test Note',
      content: 'This is saved using Hive 🎉',
      timestamp: DateTime.now(),
    );
    await box.add(testNote);
    print('📦 Test note added to Hive.');
  } else {
    print('📦 Hive already contains ${box.length} notes.');
  }

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
      home: SplashScreen(
        toggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFF9F9F9),
  cardColor: Colors.white,
  primaryColor: Color(0xFF2A2E3D),
  iconTheme: const IconThemeData(color: Color(0xFF2A2E3D)),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Color(0xFF2A2E3D), fontSize: 22, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(color: Color(0xFF2A2E3D), fontSize: 16),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Color(0xFF2A2E3D),
    iconTheme: IconThemeData(color: Color(0xFF2A2E3D)),
    titleTextStyle: TextStyle(color: Color(0xFF2A2E3D), fontSize: 20, fontWeight: FontWeight.bold),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF2A2E3D),
    foregroundColor: Colors.white,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF1F2232),
  cardColor: Color(0xFF2A2E3D),
  primaryColor: Colors.white,
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF2A2E3D),
  ),
);
