import 'dart:math';

import 'package:flutter/material.dart';

import '../../modal/form_informasi/form_informasi.dart';
class InformasiPage extends StatelessWidget {
  const InformasiPage({super.key, required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InformasiHeader(isMobile: isMobile),
          const SizedBox(height: 18),
          const _InformasiTitle(),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final targetWidth = min(constraints.maxWidth, 720.0);
              return Center(
                child: _BannerBoard(
                  isMobile: isMobile,
                  width: targetWidth,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InformasiHeader extends StatelessWidget {
  const _InformasiHeader({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isMobile)
            const Icon(Icons.menu, color: Color(0xFF8E1C1C), size: 20),
          if (isMobile) const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Welcome Admin !',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3B1F1B),
              ),
            ),
          ),
          if (!isMobile) const _HeaderSearch(),
        ],
      ),
    );
  }
}

class _HeaderSearch extends StatelessWidget {
  const _HeaderSearch();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 18,
          ),
          hintText: 'Telusuri disini',
          hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
          prefixIcon: const Icon(
            Icons.menu,
            color: Color(0xFF8A8A8A),
          ),
          suffixIcon: const Icon(
            Icons.search,
            color: Color(0xFF8A8A8A),
          ),
          filled: true,
          fillColor: const Color(0xFFF5F1EE),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _InformasiTitle extends StatelessWidget {
  const _InformasiTitle();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        'Informasi',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3B1F1B),
        ),
      ),
    );
  }
}

class _BannerBoard extends StatelessWidget {
  const _BannerBoard({
    required this.isMobile,
    required this.width,
  });

  final bool isMobile;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: max(360, width * 0.6),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFB88478), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final columns = availableWidth > 560
                  ? 3
                  : availableWidth > 380
                      ? 2
                      : 1;
              const spacing = 18.0;
              final cardWidth =
                  (availableWidth - (columns - 1) * spacing) / columns;
              return Wrap(
                spacing: spacing,
                runSpacing: 16,
                children: [
                  _BannerCard(
                    imagePath: 'assets/images/banner1.png',
                    width: cardWidth,
                  ),
                  _BannerCard(
                    imagePath: 'assets/images/banner2.png',
                    width: cardWidth,
                  ),
                  _BannerCard(
                    imagePath: 'assets/images/banner3.png',
                    width: cardWidth,
                  ),
                ],
              );
            },
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const FormInformasi(),
                );
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF8F1A1A),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(18),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_a_photo, color: Colors.white, size: 22),
                    SizedBox(height: 4),
                    Text(
                      '+Tambah Foto',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.imagePath,
    required this.width,
  });

  final String imagePath;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width * 0.55,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFB88478), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}
