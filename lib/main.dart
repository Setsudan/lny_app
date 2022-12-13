import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import "./app/screens/splash.dart";

// Screens
import "./app/screens/home.dart";
import "./app/screens/admin.dart";
import "./app/screens/gallery.dart";

// dynamic colorscheme
import 'package:dynamic_color/dynamic_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.green);

  static final _defaultDarkColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.purple, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        home: const SplashScreen(),
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme ?? _defaultLightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme ?? _defaultDarkColorScheme),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/gallery': (context) => const GalleryScreen(),
          '/admin': (context) => const AdminScreen(),
          '/palette': (context) => const PaletteScreen(),
        },
      );
    });
  }
}

// The palette screen shows the primary and secondary colors of the current color scheme.

class PaletteScreen extends StatelessWidget {
  const PaletteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Palette')),
      body: DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
        return Column(
          children: [
            Container(
              height: 100,
              color: lightColorScheme?.primary,
              child: Center(child: Text('Primary: ${lightColorScheme?.primary}')),
            ),
            Container(
              height: 100,
              color: lightColorScheme?.secondary,
              child: Center(child: Text('Secondary: ${lightColorScheme?.secondary}')),
            ),
            Container(
              height: 100,
              color: darkColorScheme?.primary,
              child: Center(child: Text('Primary: ${darkColorScheme?.primary}')),
            ),
            Container(
              height: 100,
              color: darkColorScheme?.secondary,
              child: Center(child: Text('Secondary: ${darkColorScheme?.secondary}')),
            ),
          ],
        );
      }),
    );
  }
}
