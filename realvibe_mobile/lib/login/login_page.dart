import 'package:flutter/material.dart';

import '../dashboard/dashboard_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF3EB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Center(
            child: Container(
              width: isMobile ? double.infinity : 980,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F1E8),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 30,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Row(
                  children: [
                    Expanded(
                      flex: 11,
                      child: Container(
                        color: const Color(0xFFF8E8DA),
                        padding: const EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: 32,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(120),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 120,
                              left: 24,
                              child: Container(
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0C9B4),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Center(
                                  child: Image.asset(
                                    'assets/icons/icon.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                const SizedBox(height: 22),
                                const Center(
                                  child: Text(
                                    'Selamat Datang',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFBF3023),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Real Cafe Jatiroto',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF4C2F2A),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const SizedBox(
                                  width: 320,
                                  child: Text(
                                    'Temukan setiap sudut, setiap cita, dan cerita yang menunggu untuk kamu rasakan.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.7,
                                      color: Color(0xFF6D4F46),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: isMobile ? 24 : 36,
                        ),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 14),
                            Center(
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1E3D8),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 42,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            const Center(
                              child: Text(
                                'Login Admin',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF221C1A),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Center(
                              child: Text(
                                'Silahkan masukkan Username dan Password Anda',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF7B7069),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            const _LoginField(
                              label: 'Username',
                              hintText: 'Username',
                            ),
                            const SizedBox(height: 16),
                            const _LoginField(
                              label: 'Password',
                              hintText: 'Password',
                              obscureText: true,
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: SizedBox(
                                width: 180,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD5968D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => const DashboardPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.label,
    required this.hintText,
    this.obscureText = false,
  });

  final String label;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5C4D47),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 18,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
