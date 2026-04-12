import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'dashboardCs.dart'; // file yang akan kita buat

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // ⬅️ arahkan ke UI baru
    );
  }
}
=======

import 'loading/loading_page.dart';

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

      home: const LoadingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

>>>>>>> 7c57db720f0eaac1a8d7a2d80c0b0e3db15139c6
