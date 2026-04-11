import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFFA62A1B),
      ),
      backgroundColor: const Color(0xFFF7EFE5),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat datang di Real-Vibe Admin Dashboard!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C2F2A),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Di sini Anda dapat mengelola konten, melihat statistik, dan mengatur pengaturan aplikasi.',
              style: TextStyle(fontSize: 16, color: Color(0xFF6D4F46), height: 1.5),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Menu Admin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Text('- Kelola data pengguna'),
                    Text('- Lihat laporan penjualan'),
                    Text('- Atur promosi dan menu'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
