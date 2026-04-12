import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../auth/login.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;
  bool _isChecking = true;
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startFlow();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF3EB),
      body: Stack(
        children: [
          const _BackgroundShapes(),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Image.asset(
                          'assets/icons/icon.png',
                          width: 140,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isChecking || _hasConnection) ...[
                      SizedBox(
                        width: 220,
                        child: LinearProgressIndicator(
                          value: _controller.value,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE8D5CB),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFB11D1D),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A7F7A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.wifi_off,
                        size: 36,
                        color: Color(0xFFB11D1D),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Periksa jaringan anda',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A7F7A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _startFlow,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB11D1D),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Coba lagi',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startFlow() async {
    _timer?.cancel();
    setState(() {
      _isChecking = true;
    });
    final result = await Connectivity().checkConnectivity();
    final connected = result != ConnectivityResult.none;
    if (!mounted) return;
    setState(() {
      _hasConnection = connected;
      _isChecking = false;
    });
    if (!connected) {
      _controller.stop();
      return;
    }
    _controller
      ..reset()
      ..forward();
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }
}

class _BackgroundShapes extends StatelessWidget {
  const _BackgroundShapes();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          _TriangleShape(
            top: 40,
            left: -40,
            size: 180,
            color: const Color(0xFFF3E2D8).withAlpha(130),
          ),
          _TriangleShape(
            top: -20,
            right: 40,
            size: 200,
            color: const Color(0xFFF7E9DE).withAlpha(140),
          ),
          _TriangleShape(
            bottom: 30,
            left: 40,
            size: 160,
            color: const Color(0xFFF1DED3).withAlpha(120),
          ),
          _TriangleShape(
            bottom: -30,
            right: 10,
            size: 220,
            color: const Color(0xFFF6E7DD).withAlpha(140),
          ),
        ],
      ),
    );
  }
}

class _TriangleShape extends StatelessWidget {
  const _TriangleShape({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.color,
  });

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: 0.4,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
