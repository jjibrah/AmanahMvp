import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile.dart';
import 'splash.dart';
import 'signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const Color emerald = Color.fromARGB(129, 60, 232, 51);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amanah Delivery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: emerald),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
