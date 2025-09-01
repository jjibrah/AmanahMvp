import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_layout.dart';
import 'splash.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url:
        'https://bxodrqlzdhwnozmxfdhd.supabase.co', // Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ4b2RycWx6ZGh3bm96bXhmZGhkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0NzI3NTQsImV4cCI6MjA3MDA0ODc1NH0.g5wAJkUGvhoDbaqXHEoIFh5g6nt1pUGr6289A4tvzoI', // <-- anon key
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const Color emerald = Color(0xFF00BFA5);
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
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomeLayout(),
      },
    );
  }
}
