import 'package:flutter/material.dart';

Text(AboutDialog(
  applicationName: 'Real-Vibe Admin Dashboard',
  applicationVersion: '1.0.0',
  applicationIcon: const Icon(Icons.dashboard),
  children: [
    const Text('Selamat datang di Real-Vibe Admin Dashboard!'),
    const SizedBox(height: 10),
    const Text('Di sini Anda dapat mengelola konten, melihat statistik, dan mengatur pengaturan aplikasi.'),
    const SizedBox(height: 10),
    const Text('Terima kasih telah menggunakan Real-Vibe!'),
  ],
))