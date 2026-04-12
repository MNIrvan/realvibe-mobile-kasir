import 'package:flutter/material.dart';
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
