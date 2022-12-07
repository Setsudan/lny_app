import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import "./app/screens/splash.dart";

// Screens
import "./app/screens/home.dart";
import "./app/screens/admin.dart";
import "./app/screens/gallery.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/gallery': (context) => const GalleryScreen(),
        '/admin': (context) => const AdminScreen(),
      },
    );
  }
}
