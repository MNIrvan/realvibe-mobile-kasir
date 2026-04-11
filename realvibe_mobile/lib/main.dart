import 'package:flutter/material.dart';

import 'auth/login.dart';
import 'dashboard/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RealVibe Login',
      theme: ThemeData(
        // Palet warna dasar
        scaffoldBackgroundColor: const Color(0xFFF9F1EB), // Krem pucat (latar belakang)
        primaryColor: const Color(0xFF8B4513), // Cokelat (teks utama)
        useMaterial3: true,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
 
