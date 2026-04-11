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
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: isMobile
                    ? Column(
                        children: [
                          _LoginHeroSection(isMobile: isMobile),
                          _LoginFormSection(isMobile: isMobile),
                        ],
                      )
                    : Row(
                        children: const [
                          Expanded(flex: 11, child: _LoginHeroSection()),
                          Expanded(flex: 9, child: _LoginFormSection()),
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

class _LoginHeroSection extends StatelessWidget {
  const _LoginHeroSection({this.isMobile = false});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8E8DA),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
      child: Stack(
        children: [
          if (!isMobile)
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
          if (!isMobile)
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
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/icon.png',
                    width: isMobile ? 160 : 220,
                    height: isMobile ? 160 : 220,
                  ),
                  const Text(
                    'Selamat Datang',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFBF3023),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Real Cafe Jatiroto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4C2F2A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(
                    width: 320,
                    child: Text(
                      'Temukan setiap sudut, setiap cita, dan cerita yang menunggu untuk kamu rasakan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.7,
                        color: Color(0xFF6D4F46),
                      ),
                    ),
                  ),
                  if (isMobile) const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginFormSection extends StatelessWidget {
  const _LoginFormSection({this.isMobile = false});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: const Icon(Icons.person, size: 42, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 28),
          const Center(
            child: Text(
              'Login User',
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
              style: TextStyle(fontSize: 13, color: Color(0xFF7B7069)),
            ),
          ),
          const SizedBox(height: 28),
          const _LoginField(label: 'Username', hintText: 'Username'),
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
                    MaterialPageRoute(builder: (_) => const DashboardPage()),
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
